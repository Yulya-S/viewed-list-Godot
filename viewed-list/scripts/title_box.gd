extends Container
@onready var box = $ColorRect
@onready var title = $ColorRect/Label
var id: int = 0

func _ready() -> void: pass


# Привязка тайтла к контейнеру
func set_title(data):
	id = data.id
	title.set_text(data.title)
	box.tooltip_text = data.title
	
