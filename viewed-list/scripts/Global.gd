extends Node
# Сигналы
signal open_object_page(page)
signal next_section()
signal update_page()

# Проверка что текст это число
func valide_text(text_container) -> void:
	var text = text_container.get_text()
	if len(text) > 0:
		var filtered_text = ""
		for i in text: if i.is_valid_int(): filtered_text += i
		if filtered_text != text: text_container.set_text(filtered_text)	
