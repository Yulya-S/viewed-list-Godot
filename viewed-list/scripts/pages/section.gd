extends page_class
# Подключение путей к объектам в сцене
@onready var FilterPageName = $Filters/PartName
@onready var FilterChapterName = $Filters/ChapterName
@onready var FilterCount = $Filters/Count
@onready var FilterOrder = $Filters/Order

# Создание страницы
func _ready() -> void:
	Global.connect("update_page", Callable(self, "_on_filter_button_down"))
	FilterOrder.selected = int(not bool(Global.config.order_by))
	_on_filter_button_down()

# Изменение значения фильтра названия части
func _on_part_name_text_changed() -> void: Global.text_changed_TextEdit(FilterPageName)

# Изменение значения фильтра названия главы
func _on_chapter_name_text_changed() -> void: Global.text_changed_TextEdit(FilterChapterName)

# Изменение значения количества тайтлов
func _on_count_text_changed() -> void: Global.text_changed_TextEdit(FilterCount, true)

# Нажатие кнопки фильтра
func _on_filter_button_down() -> void:
	# Фильтры
	var filter_text: String = Requests.add_part_request("", "s.title", FilterName.get_text(), "LIKE")
	filter_text = Requests.add_part_request(filter_text, "s.part_name", FilterPageName.get_text(), "LIKE")
	filter_text = Requests.add_part_request(filter_text, "s.chapter_name", FilterChapterName.get_text(), "LIKE")
	var having: String = Requests.add_part_request(filter_text, "titles_count", FilterCount.get_text(), ">=")
	
	# Сортировка
	var order: String = ""
	match FilterOrder.selected:
		1: order = "s.title"
		2: order = "titles_count DESC"
		_: order = "s.id"
	add_objects(Requests.select_sections(filter_text, having, order))
