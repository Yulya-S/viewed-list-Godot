extends object_container
# Подключение путей к объектам в сцене
@onready var Status = $ColorRect/Status
@onready var StatusLabel = $ColorRect/Status/Status
@onready var Section = $ColorRect/Status/Section

# Пути к подгружаемым сценам
const FragmentsRating: String = "res://scenes/fragments/rating.tscn"
const FragmentsProgress: String = "res://scenes/fragments/progress.tscn"

# Состояния
enum TitleStatus {NONE, PROGRESS, WAIT, UNLIKE, COMPLETED} # Состояния тайтла


# Привязка тайтла к контейнеру
func set_object(data: Dictionary) -> void:
	set_title(data.id, data.title)
	Section.set_text(data.section_title)
	# Измение названия статуса
	match TitleStatus.values()[data.status - 1]:
		TitleStatus.NONE: StatusLabel.set_text("Не начато")
		TitleStatus.WAIT: add_rating(data.rating, "Ожидается продолжение")
		TitleStatus.UNLIKE: StatusLabel.set_text("Не понравилось")
		TitleStatus.COMPLETED:  add_rating(data.rating, "Завершено")
		TitleStatus.PROGRESS:
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
