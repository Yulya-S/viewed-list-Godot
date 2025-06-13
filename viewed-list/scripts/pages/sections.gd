extends Node2D

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
	$Head.SectionTitles.text = "К тайтлам"
	$Head.Add.text = "Добавить Раздел"
	add_sections("SELECT s.*, COALESCE(COUNT(t.id), 0) AS titles_count FROM `sections` AS s LEFT JOIN `titles` AS t ON t.section_id = s.id GROUP BY s.id ORDER BY s.title;")


# Заполнение страницы разделами
func add_sections(request_text: String):
	for i in SectionContainer.get_children():
		i.queue_free()
		SectionContainer.remove_child(i)
	Global.db.query(request_text)
	for i in Global.db.query_result:
		SectionContainer.add_child(section.instantiate())
		SectionContainer.get_child(-1).set_section(i)


# Изменение значения Количества тайтлов
func _on_count_text_changed() -> void:
	var text: String = FilterCount.get_text()
	Global.valide_text(FilterCount)
	if len(text) > 0 and "\n" in text:
		FilterCount.set_text(FilterCount.get_text().replace("\n", ""))
		FilterCount.find_next_valid_focus().grab_focus()

# Нажатие кнопки фильтра
func _on_filter_button_down() -> void:
	# Фильтры
	var filter_text: String = ""
	if FilterName.get_text() != "":
		filter_text = Global.filter_text(filter_text, "s.title", FilterName.get_text(), "LIKE")
	if FilterPageName.get_text() != "":
		filter_text = Global.filter_text(filter_text, "s.part_name", FilterPageName.get_text(), "LIKE")
	if FilterChapterName.get_text() != "":
		filter_text = Global.filter_text(filter_text, "s.chapter_name", FilterChapterName.get_text(), "LIKE")
	if FilterCount.get_text() != "":
		filter_text = Global.filter_text(filter_text, "j.titles_count", FilterCount.get_text(), ">=")
	if filter_text != "": filter_text = " WHERE " + filter_text	
	
	# Сортировка
	var order: String = ""
	match FilterOrder.selected:
		0: order = "s.id"
		1: order = "s.title"
		2: order = "titles_count DESC"
		_: order = "s.id"
	
	# Сборка запроса
	var request: String = "SELECT s.*, COALESCE(COUNT(t.id), 0) AS titles_count FROM `sections` AS s " + \
						  " LEFT JOIN `titles` AS t ON t.section_id = s.id " + filter_text + " GROUP BY s.id ORDER BY " + order + ";"
	add_sections(request)


func _on_name_text_changed() -> void:
	var text: String = FilterName.get_text()
	if len(text) > 0 and "\n" in text:
		FilterName.set_text(FilterName.get_text().replace("\n", ""))
		FilterName.find_next_valid_focus().grab_focus()


func _on_part_name_text_changed() -> void:
	var text: String = FilterPageName.get_text()
	if len(text) > 0 and "\n" in text:
		FilterPageName.set_text(FilterPageName.get_text().replace("\n", ""))
		FilterPageName.find_next_valid_focus().grab_focus()


func _on_chapter_name_text_changed() -> void:
	var text: String = FilterChapterName.get_text()
	if len(text) > 0 and "\n" in text:
		FilterChapterName.set_text(FilterChapterName.get_text().replace("\n", ""))
		FilterChapterName.find_next_valid_focus().grab_focus()
