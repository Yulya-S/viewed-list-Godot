extends Node2D

@onready var Name = $Window/Name
@onready var Section = $Window/Section
@onready var Status = $Window/Status
@onready var Progress = $Window/Progress
@onready var Rating = $Window/Rating
@onready var Note = $Window/Note

var title = null


# Заполнение списка разделов
func _ready() -> void:
	Global.db.query("SELECT id, title FROM sections;")
	for i in Global.db.query_result: Section.add_item(i.title, i.id)


# Изменение данных на странице
func set_title(new_title):
	title = new_title
	Global.db.query("SELECT * FROM titles WHERE id = " + str(title.id) + ";")
	var value = Global.db.query_result[0]
	Name.set_text(value.title)
	Section.selected = value.section_id - 1
	Status.selected = value.status
	Progress.set_values(value.part, value.chapter)
	if value.rating: Rating.value = value.rating
	Note.set_text(value.note)
	

# Обработка нажатия кнопки отмены
func _on_close_button_down() -> void:
	queue_free()
	get_parent().remove_child(self)
