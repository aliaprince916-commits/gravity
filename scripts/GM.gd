extends Node

var levels = ["res://scenes/lvl_prototype.tscn", "res://scenes/lvl.tscn","res://scenes/lvl2.tscn"]
var un_locked = 0

func _ready():
	load_game()

func save_game():
	var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
	if file:
		file.store_var(un_locked)
		file.close()

func load_game():
	if FileAccess.file_exists("user://save.dat"):
		var file = FileAccess.open("user://save.dat", FileAccess.READ)
		if file:
			un_locked = file.get_var()
			file.close()

func is_open(l):
	for i in range(len(levels)):
		if l == levels[i]:
			if levels.find(l) <= un_locked:
				return true
	return false
