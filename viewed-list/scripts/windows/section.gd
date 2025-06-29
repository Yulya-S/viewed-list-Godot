extends CreationPage
# Подключение путей к объектам в сцене
@onready var TitlesCount = $Window/TitlesCount
@onready var Display = $Window/Display
@onready var part_name = $Window/PartName
@onready var chapter_name = $Window/ChapterName

# Получение данных о разделе
func get_object_data(id: int) -> Dictionary:
	var value: Dictionary = Requests.select_sections("s.id="+str(id), "", "s.title")[0]
	TitlesCount.set_text("Количество тайтлов относящихся к разделу: " + str(value.titles_count))
	TitlesCount.visible = true
	Display.button_pressed = bool(value.display)
	for i in ["part_name", "chapter_name"]: get(i).set_text(value[i])
	_on_display_toggled(bool(value.display))
	return value
	
# Получение значений контейнеров
func get_values() -> Array:
	return ['"'+Name.get_text()+'"','"'+part_name.get_text()+'"','"'+chapter_name.get_text()+'"',int(Display.button_pressed)]

# Получение списка похожих значений в базе данных
func get_similar() -> Array:
	return Requests.select(Requests.Tables.SECTIONS, "id", 'title="'+Name.get_text()+'"')

# Изменение значений текстовых контейнеров
func _on_part_name_text_changed() -> void: Global.text_changed_TextEdit(part_name)
	
func _on_chapter_name_text_changed() -> void: Global.text_changed_TextEdit(chapter_name)

# Переключение отображения Части и Главы тайтла
func _on_display_toggled(toggled_on: bool) -> void:
	part_name.visible = toggled_on
	chapter_name.visible = toggled_on

# Удаление раздела
func delete_object():
	Requests.delete_records_related_tables(Requests.Tables.SECTIONS, Requests.Tables.TITLES, object.id, "section_id")
	super.delete_object()
