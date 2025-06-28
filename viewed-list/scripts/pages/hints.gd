extends Control
# Подключение путей к объектам в сцене
@onready var Count = $Count
@onready var Sprites = $Sprites
@onready var Marker = $Marker
@onready var Hint = $Hint

var hint_idx: int = 0 # Номер подсказки
const hint_count: int = 7 # количество подсказок

# Применение текста подсказки
func set_hint(idx: int = 1) -> void:
	hint_idx += idx
	if hint_idx < 0: hint_idx = hint_count - 1
	elif hint_idx >= hint_count: hint_idx = 0
	match hint_idx:
		1: pass
		2: pass
		3: pass
		4: pass
		5: pass
		6: pass
		_: pass # 0

# Изменение параметро маркера
func set_marker(new_position: Vector2, new_size: Vector2) -> void:
	Marker.position = new_position
	Marker.size = new_size

# Обработка нажатия кнопки отмены
func _on_close_button_down() -> void: Global.emit_signal("change_program_mod", Global.ProgramModes.TITLE)

# Обработка нажатия кнопки следующей подсказки
func _on_nuxt_button_down() -> void: set_hint()

# Обработка нажатия кнопки предыдущей подсказки
func _on_previous_button_down() -> void: set_hint(-1)
