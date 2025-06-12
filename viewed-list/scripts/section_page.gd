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
	Global.db.query("SELECT s.*, j.titles_count FROM `sections` AS s INNER JOIN (SELECT t.section_id, " + \
					"COUNT(t.section_id) AS titles_count FROM `titles` AS t GROUP BY t.section_id) AS j ON j.section_id = s.id WHERE s.id = " + \
					str(section.id) + " ORDER BY s.title;")
	var value = Global.db.query_result[0]
	TitlesCount.set_text("Количество тайтлов относящихся к разделу: " + str(value.titles_count))
	Name.set_text(value.title)
	Display.button_pressed = bool(value.display)
	PartName.set_text(value.part_name)
	ChapterName.set_text(value.chapter_name)
	_on_display_toggled(bool(value.display))
	$Window/Delete.visible = true
	
	
# Изменение названия раздела
func _on_name_text_changed() -> void:
	var text: String = Name.get_text()
	if len(text) > 0 and "\n" in text:
		Name.set_text(Name.get_text().replace("\n", ""))
		Name.release_focus()

# Изменение названия Части
func _on_part_name_text_changed() -> void:
	var text: String = PartName.get_text()
	if len(text) > 0 and "\n" in text:
		PartName.set_text(PartName.get_text().replace("\n", ""))
		PartName.release_focus()
	
# Изменение названия Главы
func _on_chapter_name_text_changed() -> void:
	var text: String = ChapterName.get_text()
	if len(text) > 0 and "\n" in text:
		ChapterName.set_text(ChapterName.get_text().replace("\n", ""))
		ChapterName.release_focus()

# Обработка нажатия кнопки отмены
func _on_close_button_down() -> void:
	queue_free()
	get_parent().remove_child(self)


# Переключение отображения Части и Главы тайтла
func _on_display_toggled(toggled_on: bool) -> void:
	PartName.visible = toggled_on
	ChapterName.visible = toggled_on
