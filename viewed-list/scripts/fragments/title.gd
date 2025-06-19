extends object_container
# Подключение путей к объектам в сцене
@onready var Status = $ColorRect/Status
@onready var StatusLabel = $ColorRect/Status/Status
@onready var Section = $ColorRect/Status/Section

# Пути к подгружаемым сценам
const FragmentsRating: String = "res://scenes/fragments/rating.tscn"
const FragmentsProgress: String = "res://scenes/fragments/progress.tscn"

# Привязка тайтла к контейнеру
func set_object(data: Dictionary) -> void:
	set_title(data.id, data.title)
	Section.set_text(data.section_title)
	# Измение названия статуса
	match Global.TitleStates.values()[data.status - 1]:
		Global.TitleStates.NONE: StatusLabel.set_text("Не начато")
		Global.TitleStates.WAIT: add_rating(data.rating, "Ожидается продолжение")
		Global.TitleStates.UNLIKE: StatusLabel.set_text("Не понравилось")
		Global.TitleStates.COMPLETED:  add_rating(data.rating, "Завершено")
		Global.TitleStates.PROGRESS:
			if data.display:
				Status.add_child(load(FragmentsProgress).instantiate())
				Status.get_child(-1).position = Vector2(300, 8)
				Status.get_child(-1).set_values(data.part, data.chapter)
				Status.get_child(-1).set_labels(data.part_name, data.chapter_name)
			StatusLabel.set_text("В процессе")
		_: StatusLabel.set_text("Не известный статус")


# Добавление рейтинга
func add_rating(rating: int, text: String) -> void:
	Status.add_child(load(FragmentsRating).instantiate())
	Status.get_child(-1).position = Vector2(220, 0)
	Status.get_child(-1).value = rating
	StatusLabel.set_text(text)
