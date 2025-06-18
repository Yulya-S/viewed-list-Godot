extends Node2D
# Подключение путей к объектам в сцене
@onready var SectionContainer = $ScrollContainer/VBoxContainer
@onready var FilterName = $Filters/Name
@onready var FilterPageName = $Filters/PartName
@onready var FilterChapterName = $Filters/ChapterName
@onready var FilterCount = $Filters/Count
@onready var FilterOrder = $Filters/Order

var section = load("res://scenes/fragments/section.tscn")


# Создание страницы
func _ready() -> void:
	Global.connect("update_page", Callable(self, "_on_filter_button_down"))
	add_sections(Requests.select_sections("", "", "s.title"))

# Заполнение страницы разделами
func add_sections(values: Array) -> void: Global.filling_out_page(SectionContainer, section, values)

# Изменение значения фильтра названия
func _on_name_text_changed() -> void: Global.text_changed_TextEdit(FilterName)

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
	add_sections(Requests.select_sections(filter_text, having, order))
