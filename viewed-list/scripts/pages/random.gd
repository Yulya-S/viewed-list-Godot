extends Node2D
# Подключение путей к объектам в сцене
@onready var Head = $Head
@onready var FilterBox = $Filters
@onready var FilterSection = $Filters/Section
@onready var FilterStatus = $Filters/Status
@onready var FilterRating = $Filters/Rating
@onready var Background = $Background
@onready var Name = $Background/Name
@onready var Section = $Background/Section
@onready var Note = $Background/Note
@onready var Rating = $Background/Rating

var titles: Array = [] # Индексты тайтлов которые могут быть получены

# Создание страницы
func _ready() -> void:
	_on_filter_button_down() # Получение списка тайтлов
	# Скрытие полей
	Head.Add.visible = false
	hide_labels()
	# Замена цвета
	FilterBox.color = ColorScheme.get_color(Global.Colors.COLOR2)
	Background.color = ColorScheme.get_color(Global.Colors.COLOR4)
	for i in [FilterSection, FilterStatus, FilterRating]:
		ColorScheme.set_font_color(i.get_child(-1))
	for i in range(3): ColorScheme.set_font_color(Background.get_child(i))

# Скрытие контейнеров о рандомном тайтле
func hide_labels() -> void:
	for i in [Name, Section, Note]: i.set_text("")
	Rating.visible = false

# Обработка нажатия кнопки фильтрации
func _on_filter_button_down() -> void:
	var filter_text: String = Requests.add_part_request("", "section", FilterSection.selected)
	filter_text = Requests.add_part_request(filter_text, "status", FilterStatus.selected)
	filter_text = Requests.add_part_request(filter_text, "rating", FilterRating.get_text())
	titles = []
	for i in Requests.select(Requests.Tables.TITLES, "id", filter_text): titles.append(i.id)
	hide_labels()
	if len(titles) == 0: Name.set_text("Отсутствуют тайтлы подходящие по выбранным фильтрам")

# Изменение значения рейтинга
func _on_filter_rating_text_changed() -> void: Global.text_changed_TextEdit(FilterRating, true)

# Замена значений контейнеров информации о тайтлах
func set_title(id: int) -> void: pass

# Обработка нажатия кнопки получения рандомного тайтла
func _on_random_button_down() -> void: pass
