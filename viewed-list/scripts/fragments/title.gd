extends Container
# Подключение путей к объектам в сцене
@onready var Box = $ColorRect
@onready var Title = $ColorRect/Label
@onready var Status = $ColorRect/Status
@onready var StatusLabel = $ColorRect/Status/Status
@onready var Section = $ColorRect/Status/Section

# Пути к подгружаемым сценам
const FragmentsRating: String = "res://scenes/fragments/rating.tscn"
const FragmentsProgress: String = "res://scenes/fragments/progress.tscn"

# Состояния
enum TitleStatus {NONE, PROGRESS, WAIT, UNLIKE, COMPLETED} # Состояния тайтла
enum BoxStatus {NORMAL, HOVER} # Состояние контейнера

# Параметры
var id: int = 0
var box_state = BoxStatus.NORMAL

# Привязка тайтла к контейнеру
func set_title(data) -> void:
	id = data.id
	Title.set_text(data.title)
	Box.tooltip_text = data.title
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


# изменение значения рейтинга
func save_rating(value: float) -> void:	Requests.update(Requests.Tables.TITLES, "rating="+str(value), "id="+str(id))

# изменение значения части
func save_part(value: int) -> void: Requests.update(Requests.Tables.TITLES, "part="+str(value), "id="+str(id))

# изменение значения главы
func save_chapter(value: int) -> void: Requests.update(Requests.Tables.TITLES, "chapter="+str(value), "id="+str(id))

# Обрабоотка нажатия клавишь мыши
func _input(event: InputEvent) -> void:
	if box_state == BoxStatus.NORMAL: return
	if event.is_action("click") and event.is_pressed(): Global.emit_signal("open_object_page", self)

# Обработка наведения мыши на контейнер
func _on_label_mouse_entered() -> void: box_state = BoxStatus.HOVER

func _on_label_mouse_exited() -> void: box_state = BoxStatus.NORMAL
