extends window_class
# Подключение путей к объектам в сцене
@onready var Section = $Window/Section
@onready var Status = $Window/Status
@onready var Progress = $Window/Progress
@onready var Rating = $Window/Rating
@onready var Note = $Window/Note

# Заполнение списка разделов
func _ready() -> void:
	for i in Requests.select(Requests.Tables.SECTIONS, "id, title"): Section.add_item(i.title, i.id)
	Name.grab_focus()

# Получение данных о тайтле
func get_object_data(id: int) -> Dictionary:
	var value: Dictionary = Requests.select(Requests.Tables.TITLES, "*", "id="+str(id))[0]
	Section.selected = value.section_id - 1
	Status.selected = value.status - 1
	Progress.set_values(value.part, value.chapter)
	if value.rating: Rating.value = value.rating
	Note.set_text(value.note)
	_on_status_item_selected(Status.selected)
	return value
	
# Получение значений контейнеров
func get_values() -> Array:
	if not Progress.Part.get_text(): Progress.Part.set_text("1")
	if not Progress.Chapter.get_text(): Progress.Chapter.set_text("1")
	return [Section.selected+1, '"'+Name.get_text()+'"', Status.selected+1, Progress.Part.get_text(),
			Progress.Chapter.get_text(), '"'+Note.get_text()+'"', Rating.value]

# Получение списка похожих знаечний в базе данных
func get_similar() -> Array:
	return Requests.select(Requests.Tables.TITLES, "id", 'title="'+Name.get_text()+'" AND section_id='+str(Section.selected + 1))

# Отображение процесса просмотра тайтла 
func progress_display() -> void:
	var value = Requests.select(Requests.Tables.SECTIONS, "*", "id="+str(Section.selected + 1))[0]
	Progress.set_labels(value.part_name, value.chapter_name)
	Progress.visible = false
	if Status.selected > 0: Progress.visible = bool(value.display)

# Изменение текста заметки о тайтле
func _on_note_text_changed() -> void: Global.text_changed_TextEdit(Note)

# Изменение раздела
func _on_section_item_selected(_index: int) -> void:
	check_name()
	progress_display()

# Отображения Части, Главы и рейтинга при изменении статуса тайтла
func _on_status_item_selected(_index: int) -> void:
	progress_display()
	Rating.visible = Status.selected > 1 and Status.selected != 3

# Обработка нажатия кнопки удаления
func _on_delete_button_down() -> void:
	Requests.delete_record(Requests.Tables.TITLES, object.id)
	apply_changes()
