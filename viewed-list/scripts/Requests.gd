extends Node
enum Tables {USERS, SECTIONS, TITLES, SQLITE_SEQUENCE}
var db: SQLite = null # Подключенная база данных

# открытие базы данных
func _ready() -> void: if not db: connecting_db("res://bases/base.db")

# Подключение БД
func connecting_db(db_name: String):
	db = SQLite.new()
	db.path = db_name
	db.open_db()


# Добавление фрагмента текста в запрос
func add_part_request(text: String, column: String, value, sep: String = " AND ",
					  operator: String = "=") -> String:
	if value == null: return text
	if text: text += sep 
	if operator == "LIKE": value = '"%' + str(value) + '%"'
	text += column + operator + str(value)
	return text

# Составление общего запроса из фрагментов
func walk_through_columns(columns: Array, values: Array, sep: String = " AND ", operator: String = "=") -> String:
	var text: String = ""
	for i in len(values): text = add_part_request(text, columns[i], values[i], sep, operator)
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
	var request_text = walk_through_columns(_get_columns(table), values, ", ")
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
func delete_records_related_tables(table_1: Tables, table_2: Tables, id: int, general_column: String):
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

# Получение списка разделов
func select_sections(filters: String = "", order: String = "") -> Array:
	if filters: filters = " WHERE "+filters
	if order: order = " ORDER BY "+order
	db.query("SELECT s.*, COALESCE(COUNT(t.id), 0) titles_count FROM `sections` s "+\
		"LEFT JOIN `titles` t ON t.section_id = s.id"+filters+" GROUP BY s.id"+order+";")
	return db.query_result
	
# Получение списка тайтлов
func select_titles(filters: String = "", order: String = "") -> Array:
	if filters: filters = " WHERE "+filters
	if order: order = " ORDER BY "+order
	db.query("SELECT t.*, j.title section_title, j.part_name, j.chapter_name, j.display "+\
		"FROM `titles` t INNER JOIN ( SELECT s.* FROM `sections` s) j ON "+\
		"j.id = t.section_id"+filters+order+";")
	return db.query_result
