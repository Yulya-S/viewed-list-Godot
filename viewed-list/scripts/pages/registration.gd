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

# Нажатие кнопки создания нового пользоавтеля
func _on_registration_button_down() -> void:
	var base_name: String = ""
	const chars: String = 'abcdefghijklmnopqrstuvwxyz1234567890'
	for i in range(10): base_name += chars[randi()%len(chars)]
	Requests.insert_record(Requests.Tables.USERS, ['"'+Login.get_text()+'"',
		'"'+Marshalls.utf8_to_base64(Password.get_text())+'"',
		'"'+Marshalls.utf8_to_base64(base_name)+'"', 0])
	_on_enter_button_down()
	
# Нажатие кнопки входа в программу
func _on_enter_button_down() -> void:
	var users: Array = Requests.select_user(Login.get_text(), Marshalls.utf8_to_base64(Password.get_text()))
	if len(users) > 0:
		Requests.connecting_db("res://bases/"+Marshalls.base64_to_utf8(users[0].base)+".db")
		Global.emit_signal("change_program_mod", Global.ProgramModes.TITLE)
