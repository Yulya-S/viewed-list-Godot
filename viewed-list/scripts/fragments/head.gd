extends ColorRect
# Подключение путей к объектам в сцене
@onready var SectionTitles = $SectionsTitles
@onready var Add = $Add
@onready var User = $UserName

var mode: bool = false # false -> страница разделов, true -> страница тайтлов

# Изменение шапки в зависимости от страницы
func _ready() -> void:
	User.set_text(Global.config.login)
	mode = bool(Global.program_mod)
	if not mode:
		SectionTitles.text = "К тайтлам"
		Add.text = "Добавить Раздел"
	
# Обработка нажатия кнопки добавления нового раздела / тайтла
func _on_add_button_down() -> void:
	if int(not mode) or len(Requests.select_sections()) > 0: Global.emit_signal("open_object_page")

# Обработка нажатия кнопки перехода к разделам / тайтлам
func _on_sections_titles_button_down() -> void: Global.emit_signal("change_program_mod", int(not mode))

# Обоработка нажатия кнопки выхода из аккаунта
func _on_exit_button_down() -> void:
	Requests.connecting_users_db()
	Global.config = {"login"="", "password"="", "enter"=false}
	Global.update_config()
	Global.emit_signal("change_program_mod", Global.ProgramModes.REGISTRATION)
