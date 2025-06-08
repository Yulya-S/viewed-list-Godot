extends TextureProgressBar

@onready var TitleBox = get_parent().get_parent().get_parent()

enum States {NORMAL, HOVER}
var state = States.NORMAL

# Обработка нажатия мыши
func _input(event: InputEvent) -> void:
	var pos: Vector2 = get_local_mouse_position()
	if state == States.NORMAL: return
	if pos.x > 0 and pos.x < size.x and pos.y > 0 and pos.y < size.y:
		if event.is_action("click") and event.is_pressed():
			value = floor(pos.x / (size.x / max_value)) + 1
			if "box" in TitleBox.scene_file_path:
				TitleBox.save_rating(value)

func _on_mouse_entered() -> void: state = States.HOVER

func _on_mouse_exited() -> void: state = States.NORMAL
