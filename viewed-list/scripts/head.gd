extends ColorRect

# Обработка нажатия кнопки добавления нового тайтла
func _on_add_button_down() -> void: Global.emit_signal("open_title_page")
