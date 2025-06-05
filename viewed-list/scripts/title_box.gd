extends Container
@onready var Box = $ColorRect
@onready var Title = $ColorRect/Label
@onready var Status = $ColorRect/Status

enum TitleStatus {NONE, PROGRESS, WAIT, UNLIKE, COMPLETED}
var id: int = 0

func _ready() -> void: pass


# Привязка тайтла к контейнеру
func set_title(data):
	id = data.id
	Title.set_text(data.title)
	Box.tooltip_text = data.title
	
	match TitleStatus.values()[data.status]:
		TitleStatus.NONE: Status.get_child(0).set_text("Не начато")
		TitleStatus.PROGRESS:
			Status.add_child(load("res://scenes/progress.tscn").instantiate())
			Status.get_child(-1).position = Vector2(120, 8)
			Status.get_child(-1).set_values(data.part, data.chapter)
			Status.get_child(-1).set_labels(data.part_name, data.chapter_name)
			Status.get_child(0).set_text("В процессе")
		TitleStatus.WAIT:
			Status.add_child(load("res://scenes/rating.tscn").instantiate())
			Status.get_child(-1).value = data.rating
			Status.get_child(0).set_text("Ожидается продолжение")
		TitleStatus.UNLIKE: Status.get_child(0).set_text("Не понравилось")
		TitleStatus.COMPLETED:
			Status.add_child(load("res://scenes/rating.tscn").instantiate())
			Status.get_child(-1).value = data.rating
			Status.get_child(0).set_text("Завершено")
		_: Status.get_child(0).set_text("Не известный статус")


# сохранение значения рейтинга
func save_rating(value: float): pass

func save_part(value: float): pass

func save_chapter(value: float): pass
