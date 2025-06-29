extends Node2D
# Подключение путей к объектам в сцене
@onready var FilterSection = $Filters/Section
@onready var FilterStatus = $Filters/Status
@onready var FilterRating = $Filters/Rating
@onready var State = $Window/State
@onready var Name = $Window/Name
@onready var Section = $Window/Section
@onready var Note = $Window/Note
@onready var Count = $Window/Count
@onready var Rating = $Window/Rating

var titles: Array = [] # Индексы тайтлов, которые могут быть получены

# Создание страницы
func _ready() -> void:
	_set_filter() # Получение списка тайтлов
	Global.filling_out_sections(FilterSection)
	# Скрытие полей
	hide_labels()
	ColorScheme.set_color(self) # Замена цвета

# Скрытие контейнеров о рандомном тайтле
func hide_labels() -> void:
	for i in [Name, State, Section, Note]: i.set_text("")
	Rating.visible = false

# Применение фильтра после снятия фокуса с контейнеров фильтрации
func _on_section_focus_exited() -> void: _set_filter()

func _on_status_focus_exited() -> void: _set_filter()

func _on_rating_focus_exited() -> void: _set_filter()


# Обработка нажатия кнопки фильтрации
func _set_filter() -> void:
	var filter_text: String = Requests.add_part_request("", "section_id", FilterSection.selected)
	filter_text = Requests.add_part_request(filter_text, "status", FilterStatus.selected)
	filter_text = Requests.add_part_request(filter_text, "rating", FilterRating.get_text())
	titles = []
	for i in Requests.select(Requests.Tables.TITLES, "id", filter_text): titles.append(i.id)
	hide_labels()
	if len(titles) == 0: Name.set_text("Отсутствуют тайтлы подходящие по выбранным фильтрам")
	Count.set_text("Количество тайтлов подходящих по фильтрам: "+str(len(titles)))

# Изменение значения рейтинга
func _on_filter_rating_text_changed() -> void: Global.text_changed_TextEdit(FilterRating, true)

# Замена значений контейнеров информации о тайтлах
func set_title(idx: int) -> void:
	var data: Dictionary = Requests.select_titles("t.id="+str(titles[idx]))[0]
	Name.set_text(data.title)
	State.set_text(FilterStatus.get_item_text(data.status))
	Section.set_text(data.section_title)
	Note.set_text(data.note)
	Rating.value = data.rating
	Rating.visible = data.status-1 in [Global.TitleStates.WAIT, Global.TitleStates.COMPLETED]

# Обработка нажатия кнопки получения рандомного тайтла
func _on_random_button_down() -> void: if len(titles) > 0: set_title(randi()%len(titles))
