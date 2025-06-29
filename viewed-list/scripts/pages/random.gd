extends Node2D
# Подключение путей к объектам в сцене
@onready var FilterSection = $Filters/Section
@onready var FilterStatus = $Filters/Status
@onready var FilterRating = $Filters/Rating
@onready var State = $Window/State
@onready var title = $Window/Name
@onready var section_title = $Window/Section
@onready var note = $Window/Note
@onready var Count = $Window/Count
@onready var Rating = $Window/Rating

var objects: Array = [] # Индексы тайтлов, которые могут быть получены

# Создание страницы
func _ready() -> void:
	_set_filter() # Получение списка тайтлов
	Global.filling_out_sections(FilterSection)
	hide_labels() # Скрытие полей
	ColorScheme.set_color(self) # Замена цвета

# Скрытие контейнеров о рандомном тайтле
func hide_labels() -> void:
	for i in [State, title, section_title, note]: i.set_text("")
	Rating.visible = false

# Применение фильтра после снятия фокуса с контейнеров фильтрации
func _on_section_focus_exited() -> void: _set_filter()

func _on_status_focus_exited() -> void: _set_filter()

func _on_rating_focus_exited() -> void: _set_filter()

# Изменение значения рейтинга
func _on_filter_rating_text_changed() -> void: Global.text_changed_TextEdit(FilterRating, true)

# Обработка нажатия кнопки фильтрации
func _set_filter() -> void:
	var filter_text: String = Requests.add_part_request("", "section_id", FilterSection.selected)
	filter_text = Requests.add_part_request(filter_text, "status", FilterStatus.selected)
	filter_text = Requests.add_part_request(filter_text, "rating", FilterRating.get_text())
	objects = []
	for i in Requests.select(Requests.Tables.TITLES, "id", filter_text): objects.append(i.id)
	hide_labels()
	if len(objects) == 0: title.set_text("Отсутствуют тайтлы подходящие по выбранным фильтрам")
	Count.set_text("Количество тайтлов подходящих по фильтрам: "+str(len(objects)))

# Замена значений контейнеров информации о тайтлах
func set_title(idx: int) -> void:
	var data: Dictionary = Requests.select_titles("t.id="+str(objects[idx]))[0]
	State.set_text(FilterStatus.get_item_text(data.status))
	for i in ["title", "section_title", "note"]: get(i).set_text(data[i])
	Rating.value = data.rating
	Rating.visible = data.status - 1 in [Global.TitleStates.WAIT, Global.TitleStates.COMPLETED]

# Обработка нажатия кнопки получения рандомного тайтла
func _on_random_button_down() -> void: if len(objects) > 0: set_title(randi()%len(objects))
