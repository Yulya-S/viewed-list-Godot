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
	if Global.config.enter and Requests.db:	_entrance(Global.config.login, Global.config.password)

# Замена текста ошибки
func errors(enter: bool, users: Array = [""]) -> bool:
	if not Global.config.enter and (not Login.get_text() or not Password.get_text()):
		return Global.set_error(Error, "Все поля должны быть заполнены")
	if enter and len(users) == 0: return Global.set_error(Error, "Неверный логин или пароль")
	if not enter and len(users) > 0: return Global.set_error(Error, "Имя аккаунта занято") 
	return false

# Изменение значений
func _on_login_text_changed() -> void: Global.text_changed_TextEdit(Login)

func _on_password_text_changed() -> void: Global.text_changed_TextEdit(Password)

# Переключение видимости пароля
func _on_show_toggled(_toggled_on: bool) -> void:
	if _toggled_on: Password.add_theme_color_override("font_color", Color.html("#ffffff"))
	else: Password.add_theme_color_override("font_color", Color.html("#00000000"))

# Обработка нажатия кнопки создания нового пользователя
func _on_registration_button_down() -> void:
	var users: Array = Requests.select(Requests.Tables.USERS, "*", 'login="'+Login.get_text()+'"')
	if errors(false, users): return
	Requests.insert_record(Requests.Tables.USERS, ['"'+Login.get_text()+'"',
		'"'+Global.hide_data(Password.get_text())+'"', '"'+Global.hide_data(Requests.generate_db_name())+'"'])
	_on_enter_button_down()

# Обработка нажатия кнопки входа в программу
func _on_enter_button_down() -> void:
	if errors(true): return
	_entrance(Login.get_text(), Global.hide_data(Password.get_text()))

# Вход в программу
func _entrance(user_login: String, user_password: String) -> void:
	var users: Array = Requests.select_user(user_login, user_password)
	if errors(true, users): return
	Global.config = users[0]
	Global.config["enter"] = Remember.button_pressed
	if Remember.button_pressed: Global.update_config()
	Requests.connecting_db("res://bases/"+Marshalls.base64_to_utf8(users[0].base)+".db")
	var color_scheme: Array = Requests.select(Requests.Tables.SETTINGS, "*")
	for i in color_scheme[0].keys(): if i != "id": Global.config[i] = color_scheme[0][i]
	ColorScheme.apply_palette(users[0].color_scheme, users[0].dark_theme)
	Global.emit_signal("change_program_mod", Global.ProgramModes.TITLE)

# Обработка нажатия кнопки загрузки старой базы данных
func _on_load_button_down() -> void:
	Background.visible = true
	Background.get_child(0).visible = true

# Закрытие окна выбора файла
func _on_file_dialog_canceled() -> void: Background.visible = false

# Считывание данных из старой базы
func _on_file_dialog_file_selected(path: String) -> void:
	Requests.select_old_db(path)
	_on_file_dialog_canceled()
