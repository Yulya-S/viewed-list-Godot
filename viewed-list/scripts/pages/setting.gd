extends Control
# Подключение путей к объектам в сцене
@onready var Order = $Order
@onready var Palette = $Palette
@onready var Dark = $Dark
@onready var Color1 = $Border/ColorRect1
@onready var Color2 = $Border/ColorRect2
@onready var Color3 = $Border/ColorRect3
@onready var Color4 = $Border/Background

# Получние настроек
func _ready() -> void:
	Order.selected = int(not bool(Global.config.order_by))
	Palette.selected = Global.config.color_scheme
	Dark.button_pressed = Global.config.dark_theme
	_on_palette_item_selected(Palette.selected)

# Смена выбранной цветовой темы
func _on_palette_item_selected(index: int) -> void:
	var palette: Dictionary = ColorScheme.return_color_palette(index, Dark.button_pressed)
	Color1.color = palette.color1
	Color2.color = palette.color2
	Color3.color = palette.color3
	Color4.color = palette.color4
	for i in [Color1, Color2, Color3]: i.get_child(-1).add_theme_color_override("font_color", palette.font_color)

# Обработка нажатия кнопки отмены
func _on_close_button_down() -> void:
	Global.color_palette = ColorScheme.return_color_palette(Global.config.color_scheme, Global.config.dark_theme)
	Global.emit_signal("change_program_mod", Global.ProgramModes.TITLE)

# Изменение темы между светлой и темной
func _on_display_toggled(_toggled_on: bool) -> void: _on_palette_item_selected(Palette.selected)

# Обработка нажатия кнопки удаления пользователя
func _on_delete_button_down() -> void:
	Requests.connecting_users_db()
	DirAccess.remove_absolute("res://bases/"+Marshalls.base64_to_utf8(Global.config.base)+".db")
	Requests.delete_record(Requests.Tables.USERS, Global.config.id)
	Global.config = {"login"="", "password"="", "enter"=false}
	Global.update_config()
	Global.emit_signal("change_program_mod", Global.ProgramModes.REGISTRATION)

# Применение новых настроек
func _on_apply_button_down() -> void:
	Requests.connecting_users_db()
	Requests.update_record(Requests.Tables.USERS, Global.config.id, ['"'+Global.config.login+'"',
		'"'+Global.config.password+'"', '"'+Global.config.base+'"',
		Palette.selected, int(Dark.button_pressed), int(not bool(Order.selected))])
	Global.config.order_by = int(not bool(Order.selected))
	Global.config.color_scheme = Palette.selected
	Global.config.dark_theme = Dark.button_pressed
	Requests.connecting_db("res://bases/"+Marshalls.base64_to_utf8(Global.config.base)+".db")
	_on_close_button_down()
