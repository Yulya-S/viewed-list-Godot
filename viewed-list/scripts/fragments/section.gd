extends object_container
# Подключение путей к объектам в сцене
@onready var Part = $ColorRect/Status/Part
@onready var Chapter = $ColorRect/Status/Chapter
@onready var Count = $ColorRect/Status/Count

# Замена цвета
func _ready() -> void:
	ColorScheme.set_color_to_objects([Box, Status], Global.Colors.COLOR3)
	ColorScheme.set_color_to_objects([Title, Part, Chapter, Count], Global.Colors.FONT_COLOR)
	
# Привязка Раздела к контейнеру
func set_object(data: Dictionary) -> void:
	set_title(data.id, data.title)
	Count.set_text(str(data.titles_count))
	Part.set_text(data.part_name)
	Chapter.set_text(data.chapter_name)
	Part.visible = data.display	
	Chapter.visible = data.display
