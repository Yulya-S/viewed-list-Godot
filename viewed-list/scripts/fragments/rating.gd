extends TextureProgressBar
# Подключение путей к объектам в сцене
@onready var TitleBox = get_parent().get_parent().get_parent()

# Состояние объекта
enum States {NORMAL, HOVER}
var state = States.NORMAL

# Обработка нажатия мыши
func _input(event: InputEvent) -> void:
	if state == States.NORMAL: return
	var pos: Vector2 = get_local_mouse_position()
	if pos.x > 0 and pos.x < size.x and pos.y > 0 and pos.y < size.y:
		if event.is_action("click") and event.is_pressed():
			value = floor(pos.x / (size.x / max_value)) + 1
			Global.save_title_data(TitleBox, Global.TitleParameters.RATING, value)

# Обработка наведения мыши на контейнер
func _on_mouse_entered() -> void: state = States.HOVER

func _on_mouse_exited() -> void: state = States.NORMAL
