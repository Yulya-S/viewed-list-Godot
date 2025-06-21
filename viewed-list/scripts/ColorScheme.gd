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

# Сборка словаря
func create_dictionary(color1: String, color2: String, color3: String, color4: String = "ffffff", dark: bool = false) -> Dictionary:
	var font_color: Color = Color.BLACK
	if dark: font_color = Color.WHITE
	return {"font_color"=font_color, "color1"=Color.html("#"+color1), "color2"=Color.html("#"+color2), "color3"=Color.html("#"+color3), "color4"=Color.html("#"+color4)}

# Получение цветовой палитры по индексу светлая тема
func _return_color_palette_light(idx: int) -> Dictionary:
	match idx:
		1: return create_dictionary("DF8662", "EEA588", "f1c4b3")
		2: return create_dictionary("DF9B62", "EEB688", "F1C49F")
		3: return create_dictionary("DFB562", "EECC88", "F1DCB3")
		4: return create_dictionary("DFCA62", "EEDC88", "F1E39F")
		5: return create_dictionary("C3D75F", "D9EA85", "E0EE9D")
		6: return create_dictionary("A9D05C", "C5E683", "D7EBAF")
		7: return create_dictionary("8AC757", "ACE180", "C7E7AC")
		8: return create_dictionary("4FB34F", "7AD67A", "A6DEA6")
		9: return create_dictionary("439974", "72C8A3", "9fd3bc")
		10: return create_dictionary("3B8686", "6CBEBE", "89cbcb")
		11: return create_dictionary("446F90", "75A1C3", "9fbacf")
		12: return create_dictionary("52529C", "8080CA", "a7a7d4")
		13: return create_dictionary("6B4A97", "9B79C7", "b7a3d2")
		14: return create_dictionary("794695", "AA76C6", "bfa0d1")
		15: return create_dictionary("914091", "C470C4", "cf9ccf")
		16: return create_dictionary("B34F87", "D67AAE", "dea6c6")
		17: return create_dictionary("C7587A", "E1809E", "e7acbe")
		18: return create_dictionary("E1809E", "E198AE", "B9E198")
		19: return create_dictionary("DF8662", "72C8A3", "f1c4b3")
		20: return create_dictionary("AA76C6", "DFDF62", "EEEEA0")
		
		21: return create_dictionary("954747", "ACA6A6", "F2E9E9")
		
		
		_: return create_dictionary("DF6262", "EE8888", "F19F9F")
	
# Получение цветовой палитры по индексу темная тема
func _return_color_palette_dark(idx: int) -> Dictionary:
	match idx:
		1: return create_dictionary("994625", "7A381D", "b26b4e", "5B2A16", true)
		2: return create_dictionary("995925", "7A471D", "b27c4e", "5B3516", true)
		3: return create_dictionary("997225", "7A5B1D", "b2904e", "5B4416", true)
		4: return create_dictionary("998525", "7A6A1D", "b2a14e", "5B4F16", true)
		5: return create_dictionary("809424", "66761C", "9cac4c", "4C5815", true)
		6: return create_dictionary("6B8F23", "55721C", "87a649", "405515", true)
		7: return create_dictionary("508821", "406C1A", "6e9f45", "305113", true)
		8: return create_dictionary("1E7A1E", "186118", "3f8f3f", "124912", true)
		9: return create_dictionary("196947", "145438", "357a5c", "0f3f2a", true)
		10: return create_dictionary("165C5C", "114949", "2f6b6b", "0d3737", true)
		11: return create_dictionary("1A4362", "14354e", "365873", "0f283a", true)
		12: return create_dictionary("1F1F6B", "181855", "41417c", "121240", true)
		13: return create_dictionary("3C1C68", "301653", "553b78", "24103e", true)
		14: return create_dictionary("4B1A66", "3c1451", "603877", "2d0f3d", true)
		15: return create_dictionary("631863", "4f134f", "743374", "3b0e3b", true)
		16: return create_dictionary("7B1E52", "621841", "8f3f6c", "491231", true)
		17: return create_dictionary("892140", "6d1a33", "9f4661", "521326", true)
		18: return create_dictionary("892140", "C7587A", "508821", "305113", true)
		19: return create_dictionary("DF8662", "439974", "994625", "6b3119", true)
		20: return create_dictionary("999925", "6b6b19", "794695", "341247", true)
		21: return create_dictionary("954747", "787474", "444242", "222121", true)
		_: return create_dictionary("992525", "7A1D1D", "b24e4e", "5B1616", true)
