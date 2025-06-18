extends Node2D
# Пути к подгружаемым сценам
const WindowsDir: String = "res://scenes/windows/"
const PagesDir: String = "res://scenes/pages/"

# Состояние программы
enum States {REGISTRATION, TITLE, SECTION, RANDOM}
var state: States = States.TITLE


func _ready() -> void:
	Global.connect("open_object_page", Callable(self, "_open_object_page"))
	Global.connect("next_section", Callable(self, "_next_section"))
	# здесь нужно открывать список пользователей из таблицы users
	# после этого если пароль совпадает с введенным войти в аккаунт
	# подключившись к базе данных соответствующего пользователя
	# связь прирывать только после выхода из аккаунта
	pass
	

# Закрытие БД во время закрытия приложения
func _notification(what):
	if Requests.db: if what == Window.NOTIFICATION_WM_CLOSE_REQUEST: Requests.db.close_db()

# Открытие страницы изменения тайтла
func _open_object_page(page = null):
	add_child(load(WindowsDir+States.keys()[state].to_lower()+".tscn").instantiate())
	if page: get_child(-1).set_window(page)
	
# Открытие новой страницы
func update_state():
	get_child(0).queue_free()
	remove_child(get_child(0))
	add_child(load(PagesDir+States.keys()[state].to_lower()+".tscn").instantiate())

# Открытие страницы с разделами / тайтлами
func _next_section():
	if state == States.TITLE: state = States.SECTION
	else: state = States.TITLE
	update_state()
