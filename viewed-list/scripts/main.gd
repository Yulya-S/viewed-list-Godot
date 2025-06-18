extends Node2D
# Пути к подгружаемым сценам
const WindowsDir: String = "res://scenes/windows/"
const PagesDir: String = "res://scenes/pages/"


func _ready() -> void:
	Global.connect("open_object_page", Callable(self, "_open_object_page"))
	Global.connect("change_program_mod", Callable(self, "_change_program_mod"))
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
	add_child(load(WindowsDir+Global.program_mod_text()+".tscn").instantiate())
	if page: get_child(-1).set_window(page)

# Открытие новой страницы
func _change_program_mod(new_mod: Global.ProgramModes):
	get_child(0).queue_free()
	remove_child(get_child(0))
	Global.program_mod = new_mod
	add_child(load(PagesDir+Global.program_mod_text()+".tscn").instantiate())
