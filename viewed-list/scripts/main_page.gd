extends Node2D

var title = load("res://scenes/title_box.tscn")

var db: SQLite = null

func _ready() -> void:
	connecting_db("res://bases/base.db")
	add_titles("SELECT * FROM titles ORDER BY title;")
	

# Подключение БД
func connecting_db(db_name: String):
	db = SQLite.new()
	db.path = db_name
	db.open_db()


# Заполнение страницы тайтлами
func add_titles(request_text: String):
	for i in range($ScrollContainer/VBoxContainer.get_child_count()):
		$ScrollContainer/VBoxContainer.get_child(0).queue_free()
		$ScrollContainer/VBoxContainer.remove_child(get_child(0))
	db.query(request_text)
	for i in db.query_result:
		$ScrollContainer/VBoxContainer.add_child(title.instantiate())
		$ScrollContainer/VBoxContainer.get_child(-1).set_title(i)


# Закрытие БД во время закрытия приложения
func _notification(what):
	if db:
		if what == Window.NOTIFICATION_WM_CLOSE_REQUEST:
			db.close_db()
