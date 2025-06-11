extends Node2D

@onready var SectionContainer = $ScrollContainer/VBoxContainer

var section = load("res://scenes/section_box.tscn")


# Создание страницы
func _ready() -> void:
	$Head.SectionTItles.text = "К тайтлам"
	#add_sections("SELECT * FROM sections;")
	add_sections("SELECT s.*, j.titles_count FROM `sections` AS s INNER JOIN (SELECT t.section_id, COUNT(t.section_id) AS titles_count FROM `titles` AS t GROUP BY t.section_id) AS j ON j.section_id = s.id;")


# Заполнение страницы разделами
func add_sections(request_text: String):
	for i in SectionContainer.get_children():
		i.queue_free()
		SectionContainer.remove_child(i)
	Global.db.query(request_text)
	for i in Global.db.query_result:
		SectionContainer.add_child(section.instantiate())
		SectionContainer.get_child(-1).set_section(i)
