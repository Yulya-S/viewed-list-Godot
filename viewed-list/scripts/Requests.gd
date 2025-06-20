extends Node
enum Tables {USERS, SECTIONS, TITLES, SQLITE_SEQUENCE} # Таблицы в базе данных
var db: SQLite = null # Подключенная база данных

# открытие базы данных
func _ready() -> void: if not db: connecting_users_db()

# Создание таблицы пользователей
func create_users_db() -> void:
	db.query("""CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT,
		login VARCHAR(255), password VARCHAR(255), base VARCHAR(255), display BOOLEAN);""")

func create_title_db() -> void:
	db.query("""CREATE TABLE IF NOT EXISTS sections (id INTEGER PRIMARY KEY AUTOINCREMENT,
		title VARCHAR(255), part_name VARCHAR(255), chapter_name VARCHAR(255), display BOOLEAN);""")
	db.query("""CREATE TABLE IF NOT EXISTS titles (id INTEGER PRIMARY KEY AUTOINCREMENT,
		section_id INT, title VARCHAR(255), status INT(4), part INT, chapter INT,
		note VARCHAR(255), rating INT, FOREIGN KEY (`section_id`) REFERENCES `sections`(`id`));""")

# Подключение базы данных
func _open_db(db_name: String) -> void:
	db = SQLite.new()
	db.path = db_name
	db.open_db()

# Подключение базы данных пользователей
func connecting_users_db() -> void:
	_open_db("res://bases/users.db")
	create_users_db()

# Подключение базы данных тайтлов
func connecting_db(db_name: String) -> void:
	_open_db(db_name)
	create_title_db()

# Добавление фрагмента текста в запрос
func add_part_request(text: String, column: String, value, operator: String = "=",
					  sep: String = " AND ") -> String:
	if not value: return text
	if text: text += sep 
	if operator == "LIKE": value = '"%' + str(value) + '%"'
	text += column + " " + operator + " " + str(value)
	return text

# Получить название таблици из enum Tables
func _get_table_name(table: Tables) -> String: return Tables.keys()[table].to_lower()

# Получить названия колонок
func _get_columns(table: Tables) -> Array:
	db.query("PRAGMA table_info(`"+_get_table_name(table)+"`)")
	var result: Array = []
	for i in db.query_result: result.append(i.name)
	result.pop_front()
	return result
	

# Отправка запроса на изменение записей в таблице
func update(table: Tables, values: String, where: String) -> void:
	db.query("UPDATE `"+_get_table_name(table)+"` SET "+values+" WHERE "+where + ";")

# Изменение тайтла
func update_record(table: Tables, id: int, values: Array) -> void:
	var request_text: String = ""
	var columns: Array = _get_columns(table)
	for i in len(values): request_text = add_part_request(request_text, columns[i], values[i], "=", ", ")
	update(table, request_text, "id=" + str(id))


# Отправка запроса на создание записи таблице
func insert(table: Tables, columns: Array, values: Array) -> void:
	db.query("INSERT INTO `"+_get_table_name(table)+"` ("+",".join(columns)+") VALUES ("+",".join(values)+");")

# Добавление записи
func insert_record(table: Tables, values: Array) -> void:
	insert(table, _get_columns(table), values)


# Отправка запроса на удаление записи таблице
func _delete(table: Tables, where: String) -> void:
	db.query("DELETE FROM `" + _get_table_name(table) + "` WHERE " + where + ";")

# Удаление записи
func delete_record(table: Tables, id: int) -> void:
	Requests._delete(table, "id="+str(id))
	Requests.update(Tables.SQLITE_SEQUENCE, "seq=seq-1", 'name="'+_get_table_name(table)+'"')
	Requests.update(table, "id=id-1", "id>"+str(id))

# Удаление 
func delete_records_related_tables(table_1: Tables, table_2: Tables, id: int, general_column: String) -> void:
	# Удаление связанных записей
	var values: Array = select(table_2, "id", general_column+"="+str(id))
	for i in range(len(values)): Requests.delete_record(table_2, values[i].id-i)
	# Удаление самого раздела
	Requests.update(table_2, general_column+"="+general_column+"-1", general_column+">"+str(id))
	Requests.delete_record(table_1, id)
	

# Простой запрос к базе данных
func select(table: Tables, columns: String, where: String = "", order: String = "") -> Array:
	if where: where = " WHERE "+where
	if order: order = " ORDER BY "+order
	db.query("SELECT "+columns+" FROM `"+_get_table_name(table)+"` "+where+order+";")
	return db.query_result

# Получение данных пользователя
func select_user(login: String = "", password: String = "") -> Array:
	db.query('SELECT * FROM `users` WHERE login="'+login+'" AND password="'+password+'";')
	return db.query_result

# Получение списка разделов
func select_sections(filters: String = "", having: String = "", order: String = "") -> Array:
	if filters: filters = " WHERE "+filters
	if having: having = " HAVING "+having
	if order: order = " ORDER BY "+order
	db.query("SELECT s.*, COALESCE(COUNT(t.id), 0) titles_count FROM `sections` s "+\
		"LEFT JOIN `titles` AS t ON t.section_id = s.id"+filters+" GROUP BY s.id"+having+order+";")
	return db.query_result
	
# Получение списка тайтлов
func select_titles(filters: String = "", order: String = "") -> Array:
	if filters: filters = " WHERE "+filters
	if order: order = " ORDER BY "+order
	db.query("SELECT t.*, j.title section_title, j.part_name, j.chapter_name, j.display "+\
		"FROM `titles` t INNER JOIN ( SELECT s.* FROM `sections` s) j ON "+\
		"j.id = t.section_id"+filters+order+";")
	return db.query_result
