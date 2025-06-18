extends Container
# Подключение путей к объектам в сцене
@onready var Title = $ColorRect/Label
@onready var Part = $ColorRect/Status/Part
@onready var Chapter = $ColorRect/Status/Chapter
@onready var Count = $ColorRect/Status/Count

# Состояние объекта
enum BoxStates {NORMAL, HOVER} 
var box_state = BoxStates.NORMAL

var id: int = 0 # Подключенный раздел

# Привязка Раздела к контейнеру
func set_object(data: Dictionary) -> void:
	id = data.id
	Title.set_text(data.title)
	Count.set_text(str(data.titles_count))
	Part.set_text(data.part_name)
	Chapter.set_text(data.chapter_name)
	Part.visible = data.display	
	Chapter.visible = data.display	

# Обрабоотка нажатия клавишь мыши
func _input(event: InputEvent) -> void:
	if box_state == BoxStates.NORMAL: return
	if event.is_action("click") and event.is_pressed(): Global.emit_signal("open_object_page", self)

# Обработка наведения мыши на контейнер
func _on_label_mouse_entered() -> void: box_state = BoxStates.HOVER

func _on_label_mouse_exited() -> void: box_state = BoxStates.NORMAL
