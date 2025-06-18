extends ColorRect
# Подключение путей к объектам в сцене
@onready var SectionTitles = $SectionsTitles
@onready var Add = $Add

var mode: bool = false # false -> страница разделов, true -> страница тайтлов

# Изменение шапки в зависимости от страницы
func _ready() -> void:
	mode = bool(Global.program_mod)
	if not mode:
		SectionTitles.text = "К тайтлам"
		Add.text = "Добавить Раздел"
	
# Обработка нажатия кнопки добавления нового тайтла
func _on_add_button_down() -> void: Global.emit_signal("open_object_page")

# Обработка нажатия кнопки перехода к разделам / тайтлам
func _on_sections_titles_button_down() -> void: Global.emit_signal("change_program_mod", int(not mode))
