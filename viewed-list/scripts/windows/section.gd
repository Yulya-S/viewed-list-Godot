extends Node2D

@onready var TitlesCount = $Window/TitlesCount
@onready var Error = $Window/Error
@onready var Name = $Window/Name
@onready var Display = $Window/Display
@onready var PartName = $Window/PartName
@onready var ChapterName = $Window/ChapterName

var section = null


# Фокусировка на названии раздела
func _ready() -> void: Name.grab_focus()


# Изменение данных на странице
func set_section(new_section) -> void:
	section = new_section
	var value = Requests.select_sections("s.id="+str(section.id), "s.title")[0]
	TitlesCount.set_text("Количество тайтлов относящихся к разделу: " + str(value.titles_count))
	Name.set_text(value.title)
	Display.button_pressed = bool(value.display)
	PartName.set_text(value.part_name)
	ChapterName.set_text(value.chapter_name)
	_on_display_toggled(bool(value.display))
	$Window/Delete.visible = true
	$Window/TitlesCount.visible = true


# Отображение ошибки если тайтл уже есть в разделе
func check_section():
	var value = Requests.select(Requests.Tables.SECTIONS, "id", 'title="'+Name.get_text()+'"')
	Error.visible = false
	if not section and len(value) > 0: Error.visible = true
	else: for i in value: if i.id != section.id: Error.visible = true
	if Error.visible: Error.set_text("раздел с таким именем уже существует")
	
	
# Изменение названия раздела
func _on_name_text_changed() -> void:
	var text: String = Name.get_text()
	Name.set_text(Name.get_text().replace("\t", ""))
	if len(text) > 0 and "\n" in text:
		Name.set_text(Name.get_text().replace("\n", ""))
		check_section()
		Name.find_next_valid_focus().grab_focus()


# Изменение названия Части
func _on_part_name_text_changed() -> void:
	var text: String = PartName.get_text()
	PartName.set_text(PartName.get_text().replace("\t", ""))
	if len(text) > 0 and "\n" in text:
		PartName.set_text(PartName.get_text().replace("\n", ""))
		PartName.find_next_valid_focus().grab_focus()
	
# Изменение названия Главы
func _on_chapter_name_text_changed() -> void:
	var text: String = ChapterName.get_text()
	ChapterName.set_text(ChapterName.get_text().replace("\t", ""))
	if len(text) > 0 and "\n" in text:
		ChapterName.set_text(ChapterName.get_text().replace("\n", ""))
		ChapterName.find_next_valid_focus().grab_focus()

# Обработка нажатия кнопки отмены
func _on_close_button_down() -> void:
	queue_free()
	get_parent().remove_child(self)

# Переключение отображения Части и Главы тайтла
func _on_display_toggled(toggled_on: bool) -> void:
	PartName.visible = toggled_on
	ChapterName.visible = toggled_on

# Обработка нажатия кнопки создания / изменения раздела
func _on_apply_button_down() -> void:
	check_section()
	if Name.get_text() == "":
		Error.visible = true
		Error.set_text("Поле названия должно быть не пустым")
	if Error.visible: return
	
	var values: Array = ['"'+Name.get_text()+'"','"'+PartName.get_text()+'"','"'+ChapterName.get_text()+'"',int(Display.button_pressed)]
	if section: Requests.update_record(Requests.Tables.SECTIONS, section.id, values)
	else: Requests.insert_record(Requests.Tables.SECTIONS, values)
	Requests.emit_signal("update_page")
	_on_close_button_down()

# Обработка нажатия кнопки удаления раздела
func _on_delete_button_down() -> void:
	Requests.delete_records_related_tables(Requests.Tables.SECTIONS, Requests.Tables.TITLES, section.id, "section_id")
	Requests.emit_signal("update_page")
	_on_close_button_down()
