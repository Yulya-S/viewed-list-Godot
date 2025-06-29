extends Node2D
class_name ListPage
# Подключение путей к объектам в сцене
@onready var FilterName = $Filters/Name
@onready var FilterOrder = $Filters/Order
@onready var ObjectsContainer = $ScrollContainer/VBoxContainer

# Переменные
var objects: Array = [] # Объекты, которые будут добавлены
var object_dir = load(Global.FragmentsDir+Global.program_mod_text()+".tscn") # Путь к сцене объекта

# Создание страницы
func _ready() -> void:
	Global.connect("update_page", Callable(self, "_on_filter_button_down"))
	FilterOrder.selected = int(not bool(Global.config.order_by))
	_on_filter_button_down()
	ColorScheme.set_color(self) # Замена цвета

# Динамическое добавление объектов списка
func _process(_delta: float) -> void:
	if len(objects) > 0:
		ObjectsContainer.add_child(object_dir.instantiate())
		ObjectsContainer.get_child(-1).set_object(objects[0])
		objects.pop_front()

# Получение списка объектов, которые будут добавлены
func add_objects(values: Array) -> void:
	Global.clear_page(ObjectsContainer)
	objects = values

# Изменение значения фильтра названия
func _on_filter_name_text_changed() -> void: Global.text_changed_TextEdit(FilterName)

func _on_filter_button_down() -> void: pass # Обработка нажатие кнопки фильтра
