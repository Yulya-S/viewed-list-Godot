extends window_class
# Подключение путей к объектам в сцене
@onready var TitlesCount = $Window/TitlesCount
@onready var Display = $Window/Display
@onready var PartName = $Window/PartName
@onready var ChapterName = $Window/ChapterName

# Фокусировка на названии раздела
func _ready() -> void:
	Name.grab_focus()
	# Замена цвета
	Border.color = ColorScheme.get_color(Global.Colors.COLOR1)
	WindowBox.color = ColorScheme.get_color(Global.Colors.COLOR3)
	ColorScheme.set_color_to_objects([TitlesCount, Error], Global.Colors.FONT_COLOR)
	Display.add_theme_color_override("font_color", ColorScheme.get_color(Global.Colors.FONT_COLOR))
	Display.add_theme_color_override("font_focus_color", ColorScheme.get_color(Global.Colors.FONT_COLOR))
	Display.add_theme_color_override("font_pressed_color", ColorScheme.get_color(Global.Colors.FONT_COLOR))
	for i in [Name, PartName, ChapterName]: ColorScheme.set_font_color(i.get_child(-1))

# Получение данных о разделе
func get_object_data(id: int) -> Dictionary:
	var value: Dictionary = Requests.select_sections("s.id="+str(id), "", "s.title")[0]
	TitlesCount.set_text("Количество тайтлов относящихся к разделу: " + str(value.titles_count))
	TitlesCount.visible = true
	Display.button_pressed = bool(value.display)
	PartName.set_text(value.part_name)
	ChapterName.set_text(value.chapter_name)
	_on_display_toggled(bool(value.display))
	return value
	
# Получение значений контейнеров
func get_values() -> Array:
	return ['"'+Name.get_text()+'"','"'+PartName.get_text()+'"','"'+ChapterName.get_text()+'"',int(Display.button_pressed)]

# Получение списка похожих знаечний в базе данных
func get_similar() -> Array:
	return Requests.select(Requests.Tables.SECTIONS, "id", 'title="'+Name.get_text()+'"')

# Изменение названия Части
func _on_part_name_text_changed() -> void: Global.text_changed_TextEdit(PartName)
	
# Изменение названия Главы
func _on_chapter_name_text_changed() -> void: Global.text_changed_TextEdit(ChapterName)

# Переключение отображения Части и Главы тайтла
func _on_display_toggled(toggled_on: bool) -> void:
	PartName.visible = toggled_on
	ChapterName.visible = toggled_on

# Обработка нажатия кнопки удаления раздела
func _on_delete_button_down() -> void:
	Requests.delete_records_related_tables(Requests.Tables.SECTIONS, Requests.Tables.TITLES, object.id, "section_id")
	apply_changes()
