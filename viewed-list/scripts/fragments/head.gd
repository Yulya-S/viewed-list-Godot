extends ColorRect
# Подключение путей к объектам в сцене
@onready var SectionTitles = $SectionsTitles
@onready var Add = $Add
@onready var User = $UserName

var mode: bool = false # false -> страница разделов, true -> страница тайтлов

# Изменение шапки в зависимости от страницы
func _ready() -> void:
	User.set_text(Global.config.login)
	if Global.program_mod > 1: Add.visible = false 
	mode = bool(Global.program_mod - 1)
	if mode:
		SectionTitles.text = "К тайтлам"
		Add.text = "Добавить Раздел"
	
# Обработка нажатия кнопки добавления нового раздела / тайтла
func _on_add_button_down() -> void:
	if int(mode) or len(Requests.select_sections()) > 0: Global.emit_signal("open_object_page")

# Обработка нажатия кнопки перехода к разделам / тайтлам
func _on_sections_titles_button_down() -> void: Global.emit_signal("change_program_mod", int(mode))

# Обработка нажатия кнопки выхода из аккаунта
func _on_exit_button_down() -> void:
	Requests.connecting_users_db()
	Global.config = {"enter"=false}
	Global.update_config()
	Global.emit_signal("change_program_mod", Global.ProgramModes.REGISTRATION)

# Обработка нажатия кнопки настроек
func _on_settings_button_down() -> void: Global.emit_signal("change_program_mod", Global.ProgramModes.SETTING)

# Обработка нажатия кнопки получения рандомно тайтла
func _on_random_button_down() -> void: Global.emit_signal("change_program_mod", Global.ProgramModes.RANDOM)

# Обработка нажатия кнопки чтения подсказок
func _on_hints_button_down() -> void: Global.emit_signal("change_program_mod", Global.ProgramModes.HINTS)
