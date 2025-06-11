extends Container

@onready var Title = $ColorRect/Label
@onready var Part = $ColorRect/Status/Part
@onready var Chapter = $ColorRect/Status/Chapter
@onready var Count = $ColorRect/Status/Count

var id: int = 0


# Привязка Раздела к контейнеру
func set_section(data):
	id = data.id
	Title.set_text(data.title)
	Count.set_text(str(data.titles_count))
	Part.set_text(data.part_name)
	Chapter.set_text(data.chapter_name)
	Part.visible = data.display	
	Chapter.visible = data.display	
	
