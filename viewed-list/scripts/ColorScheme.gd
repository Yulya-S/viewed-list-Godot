extends Node

# Получить цвет по имени
func get_color(color_state: Global.Colors) -> Color: return Global.color_palette[Global.Colors.keys()[color_state].to_lower()]

# Замена цвета текста
func set_font_color(object: Label) -> void: object.add_theme_color_override("font_color", get_color(Global.Colors.FONT_COLOR))

# Замена цвета на объектах в списке
func set_color_to_objects(objects: Array, color_state: Global.Colors) -> void:
	for i in objects:
		if color_state == Global.Colors.FONT_COLOR: set_font_color(i)
		else: i.color = get_color(color_state)

# Получение цветовой палитры по индексу
func return_color_palette(idx: int, dark: bool = false) -> Dictionary:
	if dark: return _return_color_palette_dark(idx)
	return _return_color_palette_light(idx)

# Получение цветовой палитры по индексу светлая тема
func _return_color_palette_light(idx: int) -> Dictionary:
	match idx:
		1: return {"font_color"=Color.BLACK, "color1"=Color.html("#BF5930"), "color2"=Color.html("#FF7640"), "color3"=Color.html("#FF9B73"), "color4"=Color.WHITE}
		_: return {"font_color"=Color.BLACK, "color1"=Color.html("#BF3030"), "color2"=Color.html("#FF4040"), "color3"=Color.html("#FF7373"), "color4"=Color.WHITE}
	
# Получение цветовой палитры по индексу темная тема
func _return_color_palette_dark(idx: int) -> Dictionary:
	match idx:
		1: return {"font_color"=Color.WHITE, "color1"=Color.html("#BF5930"), "color2"=Color.html("#A62F00"), "color3"=Color.html("#FF7640"), "color4"=Color.BLACK}
		_: return {"font_color"=Color.WHITE, "color1"=Color.html("#BF3030"), "color2"=Color.html("#A60000"), "color3"=Color.html("#FF4040"), "color4"=Color.BLACK}
