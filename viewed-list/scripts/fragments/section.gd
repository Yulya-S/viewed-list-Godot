extends object_container
# Подключение путей к объектам в сцене
@onready var part_name = $Object/Object/Part
@onready var chapter_name = $Object/Object/Chapter
@onready var titles_count = $Object/Object/Count
	
# Привязка Раздела к контейнеру
func set_object(data: Dictionary) -> void:
	super.set_object(data)
	for i in ["part_name", "chapter_name", "titles_count"]: get(i).set_text(str(data[i]))
	part_name.visible = data.display	
	chapter_name.visible = data.display
