extends Container

@onready var MainPage = get_parent().get_parent().get_parent()
@onready var Box = $ColorRect
@onready var Title = $ColorRect/Label
@onready var Status = $ColorRect/Status


enum TitleStatus {NONE, PROGRESS, WAIT, UNLIKE, COMPLETED}
var id: int = 0


# Привязка тайтла к контейнеру
func set_title(data):
	id = data.id
	Title.set_text(data.title)
	Box.tooltip_text = data.title
	
	match TitleStatus.values()[data.status]:
		TitleStatus.NONE: Status.get_child(0).set_text("Не начато")
		TitleStatus.WAIT: add_rating(data.rating, "Ожидается продолжение")
		TitleStatus.UNLIKE: Status.get_child(0).set_text("Не понравилось")
		TitleStatus.COMPLETED:  add_rating(data.rating, "Завершено")
		TitleStatus.PROGRESS:
			Status.add_child(load("res://scenes/progress.tscn").instantiate())
			Status.get_child(-1).position = Vector2(120, 8)
			Status.get_child(-1).set_values(data.part, data.chapter)
			Status.get_child(-1).set_labels(data.part_name, data.chapter_name)
			Status.get_child(0).set_text("В процессе")
		_: Status.get_child(0).set_text("Не известный статус")


# Добавление рейтинга
func add_rating(rating: int, text: String):
	Status.add_child(load("res://scenes/rating.tscn").instantiate())
	Status.get_child(-1).position = Vector2(0, 5)
	Status.get_child(-1).value = rating
	Status.get_child(0).set_text(text)


# изменение значения рейтинга
func save_rating(value: float):
	MainPage.db.query("UPDATE `titles` SET rating = " + str(value) + " WHERE id = " + str(id) + ";")

# изменение значения части
func save_part(value: int):
	MainPage.db.query("UPDATE `titles` SET part = " + str(value) + " WHERE id = " + str(id) + ";")

# изменение значения главы
func save_chapter(value: int):
	MainPage.db.query("UPDATE `titles` SET chapter = " + str(value) + " WHERE id = " + str(id) + ";")
