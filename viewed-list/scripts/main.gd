extends Node2D

enum States {REGISTRATION, TITLE, SECTION, RANDOM}
var state: States = States.TITLE


func _ready() -> void:
	Global.connect("open_title_page", Callable(self, "_open_title_page"))
	Global.connect("next_section", Callable(self, "_next_section"))
	# здесь нужно открывать список пользователей из таблицы users
	# после этого если пароль совпадает с введенным войти в аккаунт
	# подключившись к базе данных соответствующего пользователя
	# связь прирывать только после выхода из аккаунта
	pass


# Открытие страницы изменения тайтла
func _open_title_page(page = null):
	add_child(load("res://scenes/title_page.tscn").instantiate())
	if page: get_child(-1).set_title(page)
	
	
# Открытие новой страницы
func update_state():
	get_child(0).queue_free()
	remove_child(get_child(0))
	match state:
		States.REGISTRATION: pass
		States.TITLE: add_child(load("res://scenes/main_page.tscn").instantiate())
		States.SECTION: add_child(load("res://scenes/sections.tscn").instantiate())
		States.RANDOM: pass
		_: pass
	

# Открытие страницы с разделами / тайтлами
func _next_section():
	if state == States.TITLE: state = States.SECTION
	else: state = States.TITLE
	update_state()
