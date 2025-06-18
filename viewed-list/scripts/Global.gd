extends Node
# Сигналы
signal open_object_page(page)
signal next_section()
signal update_page()

# Проверка что контейнер находится в сцене из папки fragments
func container_in_fragments(parent) -> bool: return "fragment" in parent.scene_file_path

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
