extends object_container
# Подключение путей к объектам в сцене
@onready var StatusName = $Object/Object/Status
@onready var Section = $Object/Object/Section
@onready var Rating = $Object/Object/Rating
@onready var Progress = $Object/Object/Progress

var display_progress: bool = true # Параметр отображения прогресса
	
# Привязка тайтла к контейнеру
func set_object(data: Dictionary) -> void:
	super.set_object(data)
	Section.set_text(data.section_title)
	display_progress = data.display
	_on_status_item_selected(data.status - 1, false)
	Progress.set_values(data.part, data.chapter)
	Progress.set_labels(data.part_name, data.chapter_name)
	Rating.value = data.rating

# Изменение статуса тайтла
func _on_status_item_selected(index: int, save: bool = true) -> void:
	StatusName.select(index)
	Rating.visible = index in [Global.TitleStates.WAIT, Global.TitleStates.COMPLETED]
	Progress.visible = display_progress and index == Global.TitleStates.PROGRESS
	if save: Global.save_title_data(self, Global.TitleParameters.STATUS, index+1)
