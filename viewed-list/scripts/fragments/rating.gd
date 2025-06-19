extends TextureProgressBar
@onready var TitleBox = get_parent().get_parent().get_parent() # Путь к сцене родителю
var state: Global.MouseOver = Global.MouseOver.NORMAL # Текущее состояние объекта

# Обработка нажатия мыши
func _input(event: InputEvent) -> void:
	if state == Global.MouseOver.NORMAL: return
	var pos: Vector2 = get_local_mouse_position()
	if pos.x > 0 and pos.x < size.x and pos.y > 0 and pos.y < size.y:
		if event.is_action("click") and event.is_pressed():
			value = floor(pos.x / (size.x / max_value)) + 1
			Global.save_title_data(TitleBox, Global.TitleParameters.RATING, value)

# Обработка наведения мыши на контейнер
func _on_mouse_entered() -> void: state = Global.MouseOver.HOVER

func _on_mouse_exited() -> void: state = Global.MouseOver.NORMAL
