extends Node
# Сигналы
signal open_object_page(page)
signal change_program_mod(new_mod: ProgramModes)
signal update_page()

# Перечисление
enum ProgramModes {SECTION, TITLE, REGISTRATION, RANDOM} # Страницы в приложении
enum TitleParameters {PART, CHAPTER, RATING, STATUS} # Числовые параметры для Тайтлов
enum MouseOver {NORMAL, HOVER} # Состояния курсора мыши
enum TitleStates {NONE, PROGRESS, WAIT, UNLIKE, COMPLETED} # Состояния прочтения/прочтения тайтла

# Параметры
var program_mod: ProgramModes = ProgramModes.TITLE # текущая страница
var config: Dictionary = {"login" = "", "password" = "", "enter" = false} # Настройки программы

# Константы
const FragmentsDir: String = "res://scenes/fragments/"
const ConfigFilePath: String = "res://bases/config.json"

func _ready() -> void:
	Global.create_config()
	Global.read_config()

# Получить название текущей страницы
func program_mod_text() -> String: return ProgramModes.keys()[program_mod].to_lower()

# Проверка что текст это число
func valide_numeric_text(text_container: TextEdit) -> void:
	var text = text_container.get_text()
	if len(text) > 0:
		var filtered_text = ""
		for i in text: if i.is_valid_int(): filtered_text += i
		if filtered_text != text:
			var caret = text_container.get_caret_column()
			text_container.set_text(filtered_text)
			text_container.set_caret_column(caret - (len(text) - len(filtered_text)))
		
		
# Изменение текста в TextEdit
func text_changed_TextEdit(container: TextEdit, is_numeric: bool = false) -> void:
	var text = container.get_text()
	if is_numeric: Global.valide_numeric_text(container)
	if len(text) > 0 and "\t" in text:
		container.set_text(container.get_text().replace("\t", ""))
		if container.find_next_valid_focus():
			container.find_next_valid_focus().grab_focus()
			
# Заполнение списка объектами
func clear_page(container: VBoxContainer) -> void:
	for i in container.get_children():
		i.queue_free()
		container.remove_child(i)

# Изменение текста ошибки	
func set_error(container: Label, text: String) -> void:
	container.visible = true
	container.set_text(text)
		
# Изменение значений процесса и рейтинга в базе данных
func save_title_data(container, parameter: TitleParameters, value) -> void:
	if not FragmentsDir in container.scene_file_path: return
	Requests.update(Requests.Tables.TITLES, TitleParameters.keys()[parameter].to_lower()+"="+str(value), "id="+str(container.id))

# Создание файла конфигурации
func create_config() -> void:
	if FileAccess.file_exists(ConfigFilePath): return
	update_config()

# Изменить данные в файле конфигурации
func update_config() -> void:
	var file = FileAccess.open(ConfigFilePath, FileAccess.WRITE)
	file.store_line(JSON.stringify(config))
	file.close()
	
# Загрузка настроек
func read_config():
	var data = FileAccess.open(ConfigFilePath, FileAccess.READ).get_line()
	var json = JSON.new()
	if not json.parse(data) == OK: return
	data = json.data
	for i in data.keys(): config[i] = data[i]
