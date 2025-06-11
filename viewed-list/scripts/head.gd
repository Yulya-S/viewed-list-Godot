extends ColorRect

# Обработка нажатия кнопки добавления нового тайтла
func _on_add_button_down() -> void: Global.emit_signal("open_title_page")

# Обработка нажатия кнопки перехода к разделам / тайтлам
func _on_sections_titles_button_down() -> void: Global.emit_signal("next_section")
