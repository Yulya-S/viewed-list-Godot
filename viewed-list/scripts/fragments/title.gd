extends object_container
# Подключение путей к объектам в сцене
@onready var Status = $ColorRect/Status
@onready var StatusLabel = $ColorRect/Status/Status
@onready var Section = $ColorRect/Status/Section

# Пути к подгружаемым сценам
const FragmentsRating: String = "res://scenes/fragments/rating.tscn"
const FragmentsProgress: String = "res://scenes/fragments/progress.tscn"
const states = ["Не начато", "Ожидается продолжение", "Не понравилось", "Завершено", "В процессе"]

# Привязка тайтла к контейнеру
func set_object(data: Dictionary) -> void:
	set_title(data.id, data.title)
	Section.set_text(data.section_title)
	# Измение названия статуса
	StatusLabel.set_text(states[data.status - 1])
	if data.status-1 in [Global.TitleStates.WAIT, Global.TitleStates.COMPLETED]: add_rating(data.rating)
	elif data.status-1 == Global.TitleStates.PROGRESS and data.display:
		Status.add_child(load(FragmentsProgress).instantiate())
		Status.get_child(-1).position = Vector2(300, 8)
		Status.get_child(-1).set_values(data.part, data.chapter)
		Status.get_child(-1).set_labels(data.part_name, data.chapter_name)

# Добавление рейтинга
func add_rating(rating: int) -> void:
	Status.add_child(load(FragmentsRating).instantiate())
	Status.get_child(-1).position = Vector2(220, 0)
	Status.get_child(-1).value = rating
