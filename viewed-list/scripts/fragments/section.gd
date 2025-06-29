extends object_container
# Подключение путей к объектам в сцене
@onready var Part = $Object/Object/Part
@onready var Chapter = $Object/Object/Chapter
@onready var Count = $Object/Object/Count
	
# Привязка Раздела к контейнеру
func set_object(data: Dictionary) -> void:
	super.set_object(data)
	Count.set_text(str(data.titles_count))
	Part.set_text(data.part_name)
	Chapter.set_text(data.chapter_name)
	Part.visible = data.display	
	Chapter.visible = data.display
