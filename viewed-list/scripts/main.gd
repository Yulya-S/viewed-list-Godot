extends Node2D


func _ready() -> void:
	Global.connect("open_title_page", Callable(self, "_open_title_page"))
	# здесь нужно открывать список пользователей из таблицы users
	# после этого если пароль совпадает с введенным войти в аккаунт
	# подключившись к базе данных соответствующего пользователя
	# связь прирывать только после выхода из аккаунта
	pass


func _open_title_page(page = null):
	add_child(load("res://scenes/title_page.tscn").instantiate())
	if page: get_child(-1).set_title(page)
