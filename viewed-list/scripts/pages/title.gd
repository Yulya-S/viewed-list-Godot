extends page_class
# Подключение путей к объектам в сцене
@onready var FilterSection = $Filters/Section
@onready var FilterStatus = $Filters/Status
@onready var FilterOrder = $Filters/Order
@onready var FilterRating = $Filters/Rating
@onready var FilterPart = $Filters/Part
@onready var FilterChapter = $Filters/Chapter

# Создание страницы
func _ready() -> void:
	Global.connect("update_page", Callable(self, "_on_filter_button_down"))
	for i in Requests.select(Requests.Tables.SECTIONS, "id, title"): FilterSection.add_item(i.title, i.id)
	FilterOrder.selected = int(not bool(Global.config.order_by))
	_on_filter_button_down()

# Изменение значения рейтинга
func _on_filter_rating_text_changed() -> void: Global.text_changed_TextEdit(FilterRating, true)
		
# Изменение значения части	
func _on_filter_part_text_changed() -> void: Global.text_changed_TextEdit(FilterPart, true)

# Изменение значения главы
func _on_filter_chapter_text_changed() -> void: Global.text_changed_TextEdit(FilterChapter, true)

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
		1: order = "t.title"
		2: order = "t.section_id"
		3: order = "t.status"
		4: order = "t.rating DESC"
		5: order = "t.part DESC, t.chapter DESC"
		_: order = "t.id"
	add_objects(Requests.select_titles(filter_text, order))
