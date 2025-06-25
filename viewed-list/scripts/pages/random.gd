extends page_class
# Подключение путей к объектам в сцене
@onready var FiltersSection = $Filters/Section
@onready var FiltersStatus = $Filters/Status
@onready var FiltersRating = $Filters/Rating

# Замена цвета
func _ready() -> void:
	set_colors()
	for i in [FiltersSection, FiltersStatus, FiltersRating]:
		ColorScheme.set_font_color(i.get_child(-1))
	for i in range(3): ColorScheme.set_font_color(Background.get_child(i))
