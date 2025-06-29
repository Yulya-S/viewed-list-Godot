extends ColorRect

# Отображение окна
func show_window() -> void:
	visible = true
	$SelectionWindow.visible = true

func _on_canceled() -> void: visible = false # Обработка нажатия на кнопку «НЕТ»

func _on_confirmed() -> void: get_parent().delete_object() # Обработка нажатия на кнопку «ДА»
