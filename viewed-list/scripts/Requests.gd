extends Node
enum Tables {USERS, SECTIONS, TITLES, SQLITE_SEQUENCE}

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
	Global.db.query("PRAGMA table_info(`"+_get_table_name(table)+"`)")
	var result: Array = []
	for i in Global.db.query_result: result.append(i.name)
	result.pop_front()
	return result
	

# Отправка запроса на изменение записей в таблице
func update(table: Tables, values: String, where: String) -> void:
	Global.db.query("UPDATE `"+_get_table_name(table)+"` SET "+values+" WHERE "+where + ";")

# Изменение тайтла
func update_record(table: Tables, id: int, values: Array) -> void:
	var request_text = walk_through_columns(_get_columns(table), values, ", ")
	update(table, request_text, "id=" + str(id))


# Отправка запроса на создание записи таблице
func insert(table: Tables, columns: Array, values: Array) -> void:
	Global.db.query("INSERT INTO `"+_get_table_name(table)+"` ("+",".join(columns)+") VALUES ("+",".join(values)+");")

# Добавление записи
func insert_record(table: Tables, values: Array) -> void:
	insert(table, _get_columns(table), values)


# Отправка запроса на удаление записи таблице
func _delete(table: Tables, where: String) -> void:
	Global.db.query("DELETE FROM `" + _get_table_name(table) + "` WHERE " + where + ";")

# Удаление записи
func delete_record(table: Tables, id: int) -> void:
	Requests._delete(table, "id="+str(id))
	Requests.update(Tables.SQLITE_SEQUENCE, "seq=seq-1", 'name="'+_get_table_name(table)+'"')
	Requests.update(table, "id=id-1", "id>"+str(id))

# Удаление 
func delete_records_related_tables(table_1: Tables, table_2: Tables, id: int, general_column: String):
	# Удаление связанных записей
	Global.db.query("Select id FROM `"+_get_table_name(table_2)+"` WHERE "+general_column+ "="+str(id)+";")
	var values: Array = Global.db.query_result
	for i in range(len(values)): Requests.delete_record(table_2, values[i].id-i)
	# Удаление самого раздела
	Requests.update(table_2, general_column+"="+general_column+"-1", general_column+">"+str(id))
	Requests.delete_record(table_1, id)
