extends Node2D
# Подключение путей к объектам в сцене
@onready var Head = $Head
@onready var FilterBox = $Filters
@onready var FiltersSection = $Filters/Section
@onready var FiltersStatus = $Filters/Status
@onready var FiltersRating = $Filters/Rating
@onready var Background = $Background

var titles: Array = [] # Индексты тайтлов которые могут быть получены

# Создание страницы
func _ready() -> void:
	_on_filter_button_down()
	# Скрытие полей
	Head.Add.visible = false
	# Замена цвета
	FilterBox.color = ColorScheme.get_color(Global.Colors.COLOR2)
	Background.color = ColorScheme.get_color(Global.Colors.COLOR4)
	for i in [FiltersSection, FiltersStatus, FiltersRating]:
		ColorScheme.set_font_color(i.get_child(-1))
	for i in range(3): ColorScheme.set_font_color(Background.get_child(i))

# Обработка нажатия кнопки фильтрации
func _on_filter_button_down() -> void:
	var filter_text: String = Requests.add_part_request("", "section", FiltersSection.selected)
	filter_text = Requests.add_part_request(filter_text, "status", FiltersStatus.selected)
	filter_text = Requests.add_part_request(filter_text, "rating", FiltersRating.get_text())
	titles = []
	for i in Requests.select(Requests.Tables.TITLES, "id", filter_text): titles.append(i.id)
	print(titles)
