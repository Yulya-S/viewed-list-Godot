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
	for i in Requests.select(Requests.Tables.SECTIONS, "id, title"):
		Section.add_item(i.title, i.id)
	Name.grab_focus()


# Изменение данных на странице
func set_title(new_title):
	title = new_title
	var value = Requests.select(Requests.Tables.TITLES, "*", "id="+str(title.id))[0]
	Name.set_text(value.title)
	Section.selected = value.section_id - 1
	Status.selected = value.status - 1
	Progress.set_values(value.part, value.chapter)
	if value.rating: Rating.value = value.rating
	Note.set_text(value.note)
	_on_status_item_selected(Status.selected)
	Delete.visible = true


# Отображение ошибки если тайтл уже есть в разделе
func check_title():
	var value = Requests.select(Requests.Tables.TITLES, "id", 'title="'+Name.get_text()+'" AND section_id='+str(Section.selected + 1))
	Error.visible = false
	if not title and len(value) > 0: Error.visible = true
	else: for i in value: if i.id != title.id: Error.visible = true
	if Error.visible: Error.set_text("тайтл с таким именем в выбранном разделе уже существует")

# Отображение процесса просмотра тайтла 
func progress_display():
	var value = Requests.select(Requests.Tables.SECTIONS, "*", "id="+str(Section.selected + 1))[0]
	Progress.set_labels(value.part_name, value.chapter_name)
	Progress.visible = false
	if Status.selected > 0: Progress.visible = bool(value.display)


# Изменение названия тайтла
func _on_name_text_changed() -> void:
	Global.text_changed_TextEdit(Name)
	check_title()

# Изменение текста заметки о тайтле
func _on_note_text_changed() -> void: Global.text_changed_TextEdit(Note)

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
	
	var values: Array = [Section.selected + 1, '"'+Name.get_text()+'"', Status.selected, Progress.Part.get_text(),
						 Progress.Chapter.get_text(), '"'+Note.get_text()+'"', Rating.value]
	if title: Requests.update_record(Requests.Tables.TITLES, title.id, values)
	else: Requests.insert_record(Requests.Tables.TITLES, values)
	Global.emit_signal("update_page")
	_on_close_button_down()

# Обработка нажатия кнопки удаления
func _on_delete_button_down() -> void:
	Requests.delete_record(Requests.Tables.TITLES, title.id)
	Global.emit_signal("update_page")
	_on_close_button_down()
