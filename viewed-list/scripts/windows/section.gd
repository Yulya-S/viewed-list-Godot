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
	Global.db.query("SELECT s.*, COALESCE(COUNT(t.id), 0) AS titles_count FROM `sections` AS s " + \
					"LEFT JOIN `titles` AS t ON t.section_id = s.id WHERE s.id = " + str(section.id) + \
					" GROUP BY s.id ORDER BY s.title;")
	var value = Global.db.query_result[0]
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
	Global.db.query('SELECT id FROM `sections` WHERE title = "' + Name.get_text() + '";')
	var value = Global.db.query_result
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
	if section:
		Global.db.query('UPDATE `sections` SET title = "' + Name.get_text() + \
						'", part_name = "' + PartName.get_text() + '", chapter_name = "' + ChapterName.get_text() + \
						'", display = ' + str(int(Display.button_pressed)) + " WHERE id = " + str(section.id) + ";")
	else:
		Global.db.query("INSERT INTO `sections` (`title`, `part_name`, `chapter_name`, `display`)" + \
						' VALUES ("' + Name.get_text() + '", "' + PartName.get_text() + '", "' + \
						ChapterName.get_text() + '", ' + str(int(Display.button_pressed)) + ");")
	Global.emit_signal("update_page")
	_on_close_button_down()

# Обработка нажатия кнопки удаления раздела
func _on_delete_button_down() -> void:
	var save_id: int = section.id
	
	# Удаление всех тайтлов которые относятся к удаляемому разделу
	Global.db.query("Select id FROM `titles` WHERE section_id = " + str(section.id) + ";")
	for i in Global.db.query_result:
		Global.db.query("DELETE FROM `titles` WHERE id = " + str(i.id) + ";")
		Global.db.query('UPDATE `sqlite_sequence` SET seq = seq - 1 WHERE name = "titles";')
		Global.db.query("UPDATE `titles` SET id = id - 1 WHERE id > " + str(i.id) + ";")
	
	# Удаление самого раздела
	Global.db.query("DELETE FROM `sections` WHERE id = " + str(section.id) + ";")
	Global.db.query('UPDATE `sqlite_sequence` SET seq = seq - 1 WHERE name = "sections";')
	Global.db.query("UPDATE `sections` SET id = id - 1 WHERE id > " + str(save_id) + ";")
	Global.db.query("UPDATE `titles` SET section_id = section_id - 1 WHERE section_id > " + str(save_id) + ";")
	Global.emit_signal("update_page")
	_on_close_button_down()
