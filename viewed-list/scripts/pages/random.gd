extends Node2D
# Подключение путей к объектам в сцене
@onready var Head = $Head
@onready var FilterBox = $Filters
@onready var FiltersSection = $Filters/Section
@onready var FiltersStatus = $Filters/Status
@onready var FiltersRating = $Filters/Rating
@onready var Background = $Background

# Создание страницы
func _ready() -> void:
	Head.Add.visible = false
	# Замена цвета
	FilterBox.color = ColorScheme.get_color(Global.Colors.COLOR2)
	Background.color = ColorScheme.get_color(Global.Colors.COLOR4)
	for i in [FiltersSection, FiltersStatus, FiltersRating]:
		ColorScheme.set_font_color(i.get_child(-1))
	for i in range(3): ColorScheme.set_font_color(Background.get_child(i))
