extends ColorRect

# Отображение окна
func show_window() -> void:
	visible = true
	$SelectionWindow.visible = true

# Обработка нажатия на кнопку "НЕТ"
func _on_canceled() -> void: visible = false

# Обработка нажатия на кнопку "ДА"
func _on_confirmed() -> void: get_parent().delete_object()
