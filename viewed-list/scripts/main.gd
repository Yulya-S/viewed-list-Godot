extends Node2D
# Пути к подгружаемым сценам
const WindowsTitle: String = "res://scenes/windows/title.tscn"
const PagesTitles: String = "res://scenes/pages/titles.tscn"
const WindowsSection: String = "res://scenes/windows/section.tscn"
const PagesSections: String = "res://scenes/pages/sections.tscn"

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


# Открытие страницы изменения тайтла
func _open_object_page(page = null):
	if state == States.TITLE: add_child(load(WindowsTitle).instantiate())
	else: add_child(load(WindowsSection).instantiate())
	if page:
		if state == States.TITLE: get_child(-1).set_title(page)
		else: get_child(-1).set_section(page)
	
	
# Открытие новой страницы
func update_state():
	get_child(0).queue_free()
	remove_child(get_child(0))
	match state:
		States.REGISTRATION: pass
		States.TITLE: add_child(load(PagesTitles).instantiate())
		States.SECTION: add_child(load(PagesSections).instantiate())
		States.RANDOM: pass
		_: pass
	

# Открытие страницы с разделами / тайтлами
func _next_section():
	if state == States.TITLE: state = States.SECTION
	else: state = States.TITLE
	update_state()
