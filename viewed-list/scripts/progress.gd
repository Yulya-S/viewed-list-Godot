extends Node2D

@onready var TitleBox = get_parent().get_parent().get_parent()
@onready var Part = $Part
@onready var Chapter = $Chapter


# Изменение наименований разделов
func set_labels(part_name: String, chapter_name: String) -> void:
	Part.get_child(0).set_text(part_name)
	Chapter.get_child(0).set_text(chapter_name)


# Изменение значений разделов
func set_values(part_value: int, chapter_value: int) -> void:
	Part.text = str(part_value)
	Chapter.text = str(chapter_value)


# Изменение значения части
func _on_part_text_changed() -> void:
	Global.valide_text(Part)
	var text = Part.get_text()
	if len(text) > 0 and "\n" in text: Part.release_focus()

func _on_part_text_set() -> void:
	if "box" in TitleBox.scene_file_path: TitleBox.save_part(int(Part.get_text()))


# Изменение значения главы
func _on_chapter_text_changed() -> void:
	Global.valide_text(Chapter)
	var text = Chapter.get_text()
	if len(text) > 0 and "\n" in text: Chapter.release_focus()

func _on_chapter_text_set() -> void:
	if "box" in TitleBox.scene_file_path: TitleBox.save_chapter(int(Chapter.get_text()))
