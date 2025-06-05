extends TextureProgressBar
		

# Обработка нажатия мыши
func _input(event: InputEvent) -> void:
	var pos: Vector2 = get_local_mouse_position()
	if pos.x > 0 and pos.x < size.x and pos.y > 0 and pos.y < size.y:
		if event.is_action("click") and event.is_pressed():
			value = floor(pos.x / (size.x / max_value)) + 1
			#get_parent().save_stars(value)
