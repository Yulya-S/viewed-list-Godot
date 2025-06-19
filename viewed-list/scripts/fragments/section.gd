extends object_container
# Подключение путей к объектам в сцене
@onready var Part = $ColorRect/Status/Part
@onready var Chapter = $ColorRect/Status/Chapter
@onready var Count = $ColorRect/Status/Count

# Привязка Раздела к контейнеру
func set_object(data: Dictionary) -> void:
	set_title(data.id, data.title)
	Count.set_text(str(data.titles_count))
	Part.set_text(data.part_name)
	Chapter.set_text(data.chapter_name)
	Part.visible = data.display	
	Chapter.visible = data.display
