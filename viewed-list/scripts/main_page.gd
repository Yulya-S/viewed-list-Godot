extends Node2D

@onready var TitleContainer = $ScrollContainer/VBoxContainer
@onready var FilterSection = $Filters/Section
@onready var FilterName = $Filters/Name
@onready var FilterStatus = $Filters/Status
@onready var FilterOrder = $Filters/Order
@onready var FilterRating = $Filters/Rating
@onready var FilterPart = $Filters/Part
@onready var FilterChapter = $Filters/Chapter

var title = load("res://scenes/title_box.tscn")

# Создание страницы
func _ready() -> void:
	Global.connect("update_main_page", Callable(self, "_on_filter_button_down"))
	connecting_db("res://bases/base.db")
	Global.db.query("SELECT id, title FROM sections;")
	for i in Global.db.query_result: FilterSection.add_item(i.title, i.id)
	add_titles("SELECT t.id, t.title, t.status, t.part, t.chapter, t.rating, j.title AS section_title, j.part_name, j.chapter_name, j.display FROM `titles` t INNER JOIN ( SELECT s.id, s.title, s.part_name, s.chapter_name, s.display FROM `sections` s) AS j ON j.id = t.section_id ORDER BY t.title;")
	

# Подключение БД
func connecting_db(db_name: String):
	Global.db = SQLite.new()
	Global.db.path = db_name
	Global.db.open_db()


# Заполнение страницы тайтлами
func add_titles(request_text: String):
	for i in TitleContainer.get_children():
		i.queue_free()
		TitleContainer.remove_child(i)
	Global.db.query(request_text)
	for i in Global.db.query_result:
		TitleContainer.add_child(title.instantiate())
		TitleContainer.get_child(-1).set_title(i)


# Закрытие БД во время закрытия приложения
func _notification(what):
	if Global.db: if what == Window.NOTIFICATION_WM_CLOSE_REQUEST: Global.db.close_db()
				

# Изменение значения рейтинга
func _on_filter_rating_text_changed() -> void: Global.valide_text(FilterRating)
		
# Изменение значения части	
func _on_filter_part_text_changed() -> void: Global.valide_text(FilterPart)

# Изменение значения главы
func _on_filter_chapter_text_changed() -> void: Global.valide_text(FilterChapter)

# Нажатие кнопки фильтра
func _on_filter_button_down() -> void:
	# Фильтры
	var filter_text: String = ""
	if FilterSection.selected > 0:
		filter_text = Global.filter_text(filter_text, "t.section_id", str(FilterSection.selected))
	if FilterName.get_text() != "":
		filter_text = Global.filter_text(filter_text, "t.title", FilterName.get_text(), "LIKE")
	if FilterStatus.selected > 0:
		filter_text = Global.filter_text(filter_text, "t.status", str(FilterStatus.selected - 1))
	if FilterRating.get_text() != "":
		filter_text = Global.filter_text(filter_text, "t.rating", FilterRating.get_text())
	if FilterPart.get_text() != "":
		filter_text = Global.filter_text(filter_text, "t.part", FilterPart.get_text())
	if FilterChapter.get_text() != "":
		filter_text = Global.filter_text(filter_text, "t.chapter", FilterChapter.get_text())
	if filter_text != "": filter_text = " WHERE " + filter_text + " "
	
	# Сортировка
	var order: String = ""
	match FilterOrder.selected:
		0: order = "t.id"
		1: order = "t.section_id"
		2: order = "t.title"
		3: order = "t.status"
		4: order = "t.rating DESC"
		5: order = "t.part DESC, t.chapter DESC"
	
	# Сборка запроса
	var request = "SELECT t.id, t.title, t.status, t.part, t.chapter, t.rating, j.title AS section_title, j.part_name, j.chapter_name, j.display " + \
				   "FROM `titles` t INNER JOIN ( SELECT s.id, s.title, s.part_name, s.chapter_name, s.display FROM `sections` s) "+\
				   "AS j ON j.id = t.section_id "+ filter_text +" ORDER BY " + order + ";"
	add_titles(request)
