extends Container
class_name object_container

# Подключение путей к объектам в сцене
@onready var Box = $Object
@onready var Title = $Object/Label

# Переменные
var state: Global.MouseOver = Global.MouseOver.NORMAL # Текущее состояние объекта
var id: int = 0 # Подключенный раздел

func _ready() -> void: ColorScheme.set_color(self) # Замена цвета

# Привязка общих данных к контейнеру
func set_object(data: Dictionary) -> void:
	id = data.id
	Title.set_text(data.title)
	Box.tooltip_text = data.title

# Обработка нажатия клавиш мыши
func _input(event: InputEvent) -> void:
	if state == Global.MouseOver.NORMAL: return
	if event.is_action("click") and event.is_pressed(): Global.emit_signal("open_object_page", self)
	
# Обработка наведения мыши на контейнер
func _on_label_mouse_entered() -> void: state = Global.MouseOver.HOVER

func _on_label_mouse_exited() -> void: state = Global.MouseOver.NORMAL
