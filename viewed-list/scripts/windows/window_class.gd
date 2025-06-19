extends Node
class_name window_class

# Подключение путей к объектам в сцене
@onready var Error = $Window/Error
@onready var Name = $Window/Name
@onready var Delete = $Window/Delete

var object = null # Выбранный для изменения объект

# Получение данных об объекте
func get_object_data(id: int) -> Dictionary: return {}

# Изменение данных на странице
func set_window(new_object) -> void:
	object = new_object
	var value = get_object_data(object.id)
	Delete.visible = true
	Name.set_text(value.title)

# Получение значений контейнеров
func get_values() -> Array: return []

# Получение списка похожих знаечний в базе данных
func get_similar() -> Array: return []

# Проверка верности заполнения
func check_name() -> void:
	var value = get_similar()
	Error.visible = false
	for i in value: if not object or i.id != object.id: Global.set_error(Error, "Такой объект уже существует")
	if Name.get_text() == "": Global.set_error(Error, "Поле названия должно быть не пустым")
		
# Изменение названия тайтла
func _on_name_text_changed() -> void:
	Global.text_changed_TextEdit(Name)
	check_name()
	
# Обработка нажатия кнопки создания / изменения раздела
func _on_apply_button_down() -> void:
	check_name()
	if Error.visible: return
	var values: Array = get_values()
	if object: Requests.update_record(Global.program_mod + 1, object.id, values)
	else: Requests.insert_record(Global.program_mod + 1, values)
	apply_changes()
	
# Обработка нажатия кнопки отмены
func _on_close_button_down() -> void:
	queue_free()
	get_parent().remove_child(self)

# Закрытие окна и применение изменений
func apply_changes() -> void:
	Global.emit_signal("update_page")
	_on_close_button_down()
	
