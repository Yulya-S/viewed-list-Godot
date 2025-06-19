extends Node
# Сигналы
signal open_object_page(page)
signal change_program_mod(new_mod: ProgramModes)
signal update_page()


# Перечисление
enum ProgramModes {SECTION, TITLE, REGISTRATION, RANDOM} # Страницы в приложении
enum TitleParameters {PART, CHAPTER, RATING} # Числовые параметры для Тайтлов
enum MouseOver {NORMAL, HOVER} # Состояния курсора мыши
enum TitleStates {NONE, PROGRESS, WAIT, UNLIKE, COMPLETED} # Состояния прочтения/прочтения тайтла


# Параметры
var program_mod: ProgramModes = ProgramModes.TITLE # текущая страница


# Получить название текущей страницы
func program_mod_text() -> String: return ProgramModes.keys()[program_mod].to_lower()

# Проверка что текст это число
func valide_numeric_text(text_container: TextEdit) -> void:
	var text = text_container.get_text()
	if len(text) > 0:
		var filtered_text = ""
		for i in text: if i.is_valid_int(): filtered_text += i
		if filtered_text != text:
			text_container.set_text(filtered_text)
		
# Изменение текста в TextEdit
func text_changed_TextEdit(container: TextEdit, is_numeric: bool = false) -> void:
	var text = container.get_text()
	if is_numeric: Global.valide_numeric_text(container)
	if len(text) > 0 and "\t" in text:
		container.set_text(container.get_text().replace("\t", ""))
		if container.find_next_valid_focus():
			container.find_next_valid_focus().grab_focus()
			
# Заполнение списка объектами
func filling_out_page(container, object, values: Array) -> void:
	for i in container.get_children():
		i.queue_free()
		container.remove_child(i)
	for i in values:
		container.add_child(object.instantiate())
		container.get_child(-1).set_object(i)
		
# Изменение значений процесса и рейтинга в базе данных
func save_title_data(container, parameter: TitleParameters, value) -> void:
	if not "fragment" in container.scene_file_path: return
	Requests.update(Requests.Tables.TITLES, TitleParameters.keys()[parameter].to_lower()+"="+str(value), "id="+str(container.id))
