extends Control
# Подключение путей к объектам в сцене
@onready var Login = $Login
@onready var Password = $Password
@onready var Show = $Password/Show
@onready var Remember = $Remember

# Изменение значения логина
func _on_login_text_changed() -> void: Global.text_changed_TextEdit(Login)

# Изменение значения пароля
func _on_password_text_changed() -> void: Global.text_changed_TextEdit(Password)

# Переключение видимости пароля
func _on_show_toggled(_toggled_on: bool) -> void:
	if _toggled_on: Password.add_theme_color_override("font_color", Color.html("#ffffff"))
	else: Password.add_theme_color_override("font_color", Color.html("#00000000"))
