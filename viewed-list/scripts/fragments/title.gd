extends object_container
# Подключение путей к объектам в сцене
@onready var StatusName = $ColorRect/Status/Status
@onready var Section = $ColorRect/Status/Section
@onready var Rating = $ColorRect/Status/Rating
@onready var Progress = $ColorRect/Status/Progress

# Пути к подгружаемым сценам
const FragmentsRating: String = "res://scenes/fragments/rating.tscn"
const FragmentsProgress: String = "res://scenes/fragments/progress.tscn"

var display_progress: bool = true # Параметр отображения прогресса

# Замена цвета
func _ready() -> void:
	ColorScheme.set_color_to_objects([Box, Status], Global.Colors.COLOR3)
	ColorScheme.set_color_to_objects([Title, Section], Global.Colors.FONT_COLOR)
	
# Привязка тайтла к контейнеру
func set_object(data: Dictionary) -> void:
	set_title(data.id, data.title)
	Section.set_text(data.section_title)
	StatusName.selected = data.status-1
	_on_status_item_selected(StatusName.selected)
	display_progress = data.display
	Progress.set_values(data.part, data.chapter)
	Progress.set_labels(data.part_name, data.chapter_name)
	Rating.value = data.rating

# Изменение статуса тайтла
func _on_status_item_selected(index: int) -> void:
	Rating.visible = index in [Global.TitleStates.WAIT, Global.TitleStates.COMPLETED]
	Progress.visible = display_progress and index == Global.TitleStates.PROGRESS
	Global.save_title_data(self, Global.TitleParameters.STATUS, index+1)
