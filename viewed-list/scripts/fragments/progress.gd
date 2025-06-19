extends Node2D
# Подключение путей к объектам в сцене
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
func _on_part_text_changed() -> void: Global.text_changed_TextEdit(Part, true)

func _on_part_focus_exited() -> void:
	Global.save_title_data(TitleBox, Global.TitleParameters.PART, Part.get_text())

# Изменение значения главы
func _on_chapter_text_changed() -> void: Global.text_changed_TextEdit(Chapter, true)

func _on_chapter_focus_exited() -> void:
	Global.save_title_data(TitleBox, Global.TitleParameters.CHAPTER, Chapter.get_text())
