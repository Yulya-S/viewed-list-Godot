extends Node2D

@onready var TitleContainer = $ScrollContainer/VBoxContainer
@onready var FilterSection = $Filters/Section
@onready var FilterName = $Filters/Name
@onready var FilterStatus = $Filters/Status
@onready var FilterOrder = $Filters/Order
@onready var FilterRating = $Filters/Rating
@onready var FilterPart = $Filters/Part
@onready var FilterChapter = $Filters/Chapter

var title = load("res://scenes/fragments/title.tscn")

# Создание страницы
func _ready() -> void:
	Global.connect("update_page", Callable(self, "_on_filter_button_down"))
	for i in Requests.select(Requests.Tables.SECTIONS, "id, title"):
		FilterSection.add_item(i.title, i.id)
	add_titles(Requests.select_titles("", "t.title"))


# Заполнение страницы тайтлами
func add_titles(values: Array):
	for i in TitleContainer.get_children():
		i.queue_free()
		TitleContainer.remove_child(i)
	for i in values:
		TitleContainer.add_child(title.instantiate())
		TitleContainer.get_child(-1).set_title(i)
				

# Изменение значения рейтинга
func _on_filter_rating_text_changed() -> void:
	var text: String = FilterRating.get_text()
	Global.valide_text(FilterRating)
	if len(text) > 0 and "\n" in text:
		FilterRating.set_text(FilterRating.get_text().replace("\n", ""))
		FilterRating.find_next_valid_focus().grab_focus()
		
# Изменение значения части	
func _on_filter_part_text_changed() -> void:
	var text: String = FilterPart.get_text()
	Global.valide_text(FilterPart)
	if len(text) > 0 and "\n" in text:
		FilterPart.set_text(FilterPart.get_text().replace("\n", ""))
		FilterPart.find_next_valid_focus().grab_focus()

# Изменение значения главы
func _on_filter_chapter_text_changed() -> void:
	var text: String = FilterChapter.get_text()
	Global.valide_text(FilterChapter)
	if len(text) > 0 and "\n" in text:
		FilterChapter.set_text(FilterChapter.get_text().replace("\n", ""))
		FilterChapter.find_next_valid_focus().grab_focus()

# Нажатие кнопки фильтра
func _on_filter_button_down() -> void:
	# Фильтры
	var filter_text: String = Requests.add_part_request("", "t.title", FilterName.get_text(), "LIKE")
	filter_text = Requests.add_part_request(filter_text, "t.section_id", FilterSection.selected)
	filter_text = Requests.add_part_request(filter_text, "t.status", FilterStatus.selected)
	filter_text = Requests.add_part_request(filter_text, "t.part", FilterPart.get_text())
	filter_text = Requests.add_part_request(filter_text, "t.chapter", FilterChapter.get_text())
	filter_text = Requests.add_part_request(filter_text, "t.rating", FilterRating.get_text())
	
	# Сортировка
	var order: String = ""
	match FilterOrder.selected:
		1: order = "t.section_id"
		2: order = "t.title"
		3: order = "t.status"
		4: order = "t.rating DESC"
		5: order = "t.part DESC, t.chapter DESC"
		_: order = "t.id"
	add_titles(Requests.select_titles(filter_text, order))


func _on_name_text_changed() -> void:
	var text: String = FilterName.get_text()
	FilterName.set_text(FilterName.get_text().replace("\t", ""))
	if len(text) > 0 and "\n" in text:
		FilterName.set_text(FilterName.get_text().replace("\n", ""))
		FilterName.find_next_valid_focus().grab_focus()
