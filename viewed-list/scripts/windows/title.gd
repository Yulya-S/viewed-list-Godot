extends Node2D

@onready var Error = $Window/Error
@onready var Name = $Window/Name
@onready var Section = $Window/Section
@onready var Status = $Window/Status
@onready var Progress = $Window/Progress
@onready var Rating = $Window/Rating
@onready var Note = $Window/Note
@onready var Delete = $Window/Delete

var title = null


# Заполнение списка разделов
func _ready() -> void:
	Global.db.query("SELECT id, title FROM sections;")
	for i in Global.db.query_result: Section.add_item(i.title, i.id)
	Name.grab_focus()


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
	Delete.visible = true


# Отображение ошибки если тайтл уже есть в разделе
func check_title():
	Global.db.query('SELECT id FROM titles WHERE title = "' + Name.get_text() + '" AND section_id = ' + str(Section.selected + 1)+ ";")
	var value = Global.db.query_result
	Error.visible = false
	if not title and len(value) > 0: Error.visible = true
	else: for i in value: if i.id != title.id: Error.visible = true
	if Error.visible: Error.set_text("тайтл с таким именем в выбранном разделе уже существует")

# Отображение процесса просмотра тайтла 
func progress_display():
	Global.db.query('SELECT * FROM sections WHERE id = ' + str(Section.selected + 1)+ ";")
	var value = Global.db.query_result[0]
	Progress.set_labels(value.part_name, value.chapter_name)
	Progress.visible = false
	if Status.selected > 0: Progress.visible = bool(value.display)


# Изменение названия тайтла
func _on_name_text_changed() -> void:
	var text: String = Name.get_text()
	Name.set_text(Name.get_text().replace("\t", ""))
	if len(text) > 0 and "\n" in text:
		Name.set_text(Name.get_text().replace("\n", ""))
		check_title()
		Name.find_next_valid_focus().grab_focus()


# Изменение текста заметки о тайтле
func _on_note_text_changed() -> void:
	var text: String = Note.get_text()
	Note.set_text(Note.get_text().replace("\t", ""))
	if len(text) > 0 and "\n" in text:
		Note.set_text(Note.get_text().replace("\n", ""))
		Note.find_next_valid_focus().grab_focus()


# Изменение раздела
func _on_section_item_selected(_index: int) -> void:
	check_title()
	progress_display()

# Отображения Части, Главы и рейтинга при изменении статуса тайтла
func _on_status_item_selected(_index: int) -> void:
	progress_display()
	Rating.visible = Status.selected > 1 and Status.selected != 3
	

# Обработка нажатия кнопки отмены
func _on_close_button_down() -> void:
	queue_free()
	get_parent().remove_child(self)

# Обработка нажатия кнопки сохранения
func _on_apply_button_down() -> void:
	check_title()
	if Name.get_text() == "":
		Error.visible = true
		Error.set_text("Поле названия должно быть не пустым")
	if Error.visible: return
	if not Progress.Part.get_text(): Progress.Part.set_text("1")
	if not Progress.Chapter.get_text(): Progress.Chapter.set_text("1")
	if title:
		Global.db.query("UPDATE `titles` SET section_id = " + str(Section.selected + 1) + \
						', title = "' + Name.get_text() + '", status = ' + str(Status.selected) + \
						", part = " + Progress.Part.get_text() + ", chapter = " + Progress.Chapter.get_text() + \
						', note = "' + Note.get_text() + '", rating = ' + str(Rating.value) + \
						" WHERE id = " + str(title.id) + ";")
	else:
		Global.db.query("INSERT INTO `titles` (`section_id`, `title`, `status`, `part`, `chapter`, `note`, `rating`)" + \
						" VALUES (" + str(Section.selected + 1) + ', "' + Name.get_text() + '", ' + \
						str(Status.selected) + ", " + Progress.Part.get_text() + ", " + Progress.Chapter.get_text() + \
						', "' + Note.get_text() + '", ' + str(Rating.value)+ ");")
	Global.emit_signal("update_page")
	_on_close_button_down()

# Обработка нажатия кнопки удаления
func _on_delete_button_down() -> void:
	var save_id: int = title.id
	Global.db.query("DELETE FROM `titles` WHERE id = " + str(title.id) + ";")
	Global.db.query('UPDATE `sqlite_sequence` SET seq = seq - 1 WHERE name = "titles";')
	Global.db.query("UPDATE `titles` SET id = id - 1 WHERE id > " + str(save_id) + ";")
	Global.emit_signal("update_page")
	_on_close_button_down()
