extends Node2D
class_name page_class
# Подключение путей к объектам в сцене
@onready var ObjectsContainer = $ScrollContainer/VBoxContainer
@onready var FilterName = $Filters/Name

# Переменные
var object_idx: int = 0 # Индекс последнего добаленного объекта
var objects: Array = [] # Объекты которые будут добавлены
var object_dir = load(Global.FragmentsDir+Global.program_mod_text()+".tscn") # Объект который будет добавлен

# Динамическое добаление объектов списка
func _process(_delta: float) -> void:
	if object_idx != len(objects):
		ObjectsContainer.add_child(object_dir.instantiate())
		ObjectsContainer.get_child(-1).set_object(objects[object_idx])
		object_idx += 1

# Получение списка объектов которые будут добавлены
func add_objects(values: Array) -> void:
	Global.clear_page(ObjectsContainer)
	object_idx = 0
	objects = values

# Изменение значения фильтра названия
func _on_filter_name_text_changed() -> void: Global.text_changed_TextEdit(FilterName)
