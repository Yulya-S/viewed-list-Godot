extends Control
# Подключение путей к объектам в сцене
@onready var Login = $Login
@onready var Password = $Password
@onready var Remember = $Remember

var password_text: String = "" # Текст пароля

# Изменение значения логина
func _on_login_text_changed() -> void: Global.text_changed_TextEdit(Login)

# Изменение значения пароля
func _on_password_text_changed() -> void:
	var caret = Password.get_caret_column()
	password_text = Password.get_text()
	for i in range(len(Password.get_text())): Password.text[i] = "*"
	Password.set_caret_column(caret)
	Global.text_changed_TextEdit(Password)
