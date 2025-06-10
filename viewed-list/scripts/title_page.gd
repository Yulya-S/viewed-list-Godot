extends Node2D

@onready var Error = $Window/Error
@onready var Name = $Window/Name
@onready var Section = $Window/Section
@onready var Status = $Window/Status
@onready var Progress = $Window/Progress
@onready var Rating = $Window/Rating
@onready var Note = $Window/Note

var title = null


# Заполнение списка разделов
func _ready() -> void:
	Global.db.query("SELECT id, title FROM sections;")
	for i in Global.db.query_result: Section.add_item(i.title, i.id)


# Изменение данных на странице
func set_title(new_title):
	title = new_title
	Global.db.query("SELECT * FROM titles WHERE id = " + str(title.id) + ";")
	var value = Global.db.query_result[0]
	Name.set_text(value.title)
	Section.selected = value.section_id - 1
	Status.selected = value.status
	Progress.set_values(value.part, value.chapter)
	if value.rating: Rating.value = value.rating
	Note.set_text(value.note)
	_on_status_item_selected(Status.selected)
	$Window/Delete.visible = true


# Отображение ошибки если тайтл уже есть в разделе
func check_title():
	Global.db.query('SELECT id FROM titles WHERE title = "' + Name.get_text() + '" AND section_id = ' + str(Section.selected + 1)+ ";")
	var value = Global.db.query_result
	Error.visible = false
	if not title and len(value) > 0: Error.visible = true
	else: for i in value: if i.id != title.id: Error.visible = true

# Отображение процесса просмотра тайтла 
func progress_display():
	Global.db.query('SELECT * FROM sections WHERE id = ' + str(Section.selected + 1)+ ";")
	var value = Global.db.query_result[0]
	Progress.set_labels(value.part_name, value.chapter_name)
	Progress.visible = false
	if Status.selected > 0:	Progress.visible = bool(value.display)


# Изменение названия тайтла
func _on_name_text_changed() -> void:
	var text: String = Name.get_text()
	if len(text) > 0 and "\n" in text:
		Name.set_text(Name.get_text().replace("\n", ""))
		Name.release_focus()

func _on_name_text_set() -> void: check_title()

# Изменение раздела
func _on_section_item_selected(_index: int) -> void:
	check_title()
	progress_display()

# Отображения Части, Главы и рейтинга при изменении статуса тайтла
func _on_status_item_selected(_index: int) -> void:
	progress_display()
	Rating.visible = Status.selected > 1
	

# Обработка нажатия кнопки отмены
func _on_close_button_down() -> void:
	queue_free()
	get_parent().remove_child(self)

# Обработка нажатия кнопки сохранения
func _on_apply_button_down() -> void:
	_on_name_text_set()
	if Error.visible: return
	if title:
		Global.db.query("UPDATE `titles` SET section_id = " + str(Section.selected + 1) + \
						', title = "' + Name.get_text() + '", status = ' + str(Status.selected) + \
						", part = " + Progress.Part.get_text() + ", chapter = " + Progress.Chapter.get_text() + \
						', note = "' + Note.get_text() + '", rating = ' + str(Rating.value) + \
						" WHERE id = " + str(title.id) + ";")
	else:
		Global.db.query("INSERT INTO `titles` (`section_id`, `title`, `status`, `part`, `chapter`, `note`, `rating`)" + \
						" VALUES (" + str(Section.selected + 1) + ", " + Name.get_text() + ", " + \
						str(Status.selected) + ", " + Progress.Part.get_text() + ", " + Progress.Chapter.get_text() + \
						", " + Note.get_text() + ", " + str(Rating.value)+ ");")
	Global.emit_signal("update_main_page")
	_on_close_button_down()
