extends Control
# Подключение путей к объектам в сцене
@onready var Login = $Login
@onready var Password = $Password
@onready var Show = $Password/Show
@onready var Remember = $Remember
@onready var Background = $Background
@onready var Error = $Error

# Автоматический вход в программу
func _process(_delta: float) -> void:
	if Global.config.enter and Requests.db:
		Error.visible = false
		_entrance(Global.config.login, Global.config.password)

# Проверка верности заполнения текстовых полей
func check_text() -> void:
	Error.visible = false
	if not Login.get_text() or not Password.get_text(): Global.set_error(Error, "Все поля должны быть заполнены")

# Изменение значения логина
func _on_login_text_changed() -> void: Global.text_changed_TextEdit(Login)

# Изменение значения пароля
func _on_password_text_changed() -> void: Global.text_changed_TextEdit(Password)

# Переключение видимости пароля
func _on_show_toggled(_toggled_on: bool) -> void:
	if _toggled_on: Password.add_theme_color_override("font_color", Color.html("#ffffff"))
	else: Password.add_theme_color_override("font_color", Color.html("#00000000"))

# Обработка нажатия кнопки создания нового пользоавтеля
func _on_registration_button_down() -> void:
	check_text()
	var users: Array = Requests.select(Requests.Tables.USERS, "*", 'login="'+Login.get_text()+'"')
	if len(users) > 0: Global.set_error(Error, "Имя аккаунта занято")
	if Error.visible: return
	Requests.insert_record(Requests.Tables.USERS, ['"'+Login.get_text()+'"',
		'"'+Marshalls.utf8_to_base64(Password.get_text())+'"',
		'"'+Marshalls.utf8_to_base64(Requests.generate_db_name())+'"', 0, 0, 0])
	_on_enter_button_down()

# Вход в программу
func _entrance(user_login: String, user_password: String) -> void:
	var users: Array = Requests.select_user(user_login, user_password)
	if len(users) == 0: Global.set_error(Error, "Неверный логин или пароль")
	if Error.visible: return
	Global.color_palette = ColorScheme.return_color_palette(users[0].color_scheme, users[0].dark_theme)
	Global.config = users[0]
	if Remember.button_pressed:
		Global.config["enter"] = true
		Global.update_config()
	Requests.connecting_db("res://bases/"+Marshalls.base64_to_utf8(users[0].base)+".db")
	Global.emit_signal("change_program_mod", Global.ProgramModes.TITLE)
	
# Обработка нажатия кнопки входа в программу
func _on_enter_button_down() -> void:
	check_text()
	if Error.visible: return
	_entrance(Login.get_text(), Marshalls.utf8_to_base64(Password.get_text()))

# Обработка нажатия кнопки загрузки старой базы данных
func _on_load_button_down() -> void:
	Background.visible = true
	Background.get_child(0).visible = true

# Закрытие окна выбора файла
func _on_file_dialog_canceled() -> void: Background.visible = false

# Считыванние данных из старой базы
func _on_file_dialog_file_selected(path: String) -> void:
	Requests.select_old_db(path)
	_on_file_dialog_canceled()
