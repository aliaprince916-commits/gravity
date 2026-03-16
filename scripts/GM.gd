extends Node
var levels=["res://scenes/lvl_prototype.tscn","res://scenes/lvl.tscn"]
var un_locked=0

func save_game():
	var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
	file.store_var(un_locked)

func load_game():
	if FileAccess.file_exists("user://save.dat"):
		var file = FileAccess.open("user://save.dat", FileAccess.READ)
		un_locked = file.get_var()

func is_open(l):
	for i in range(len(levels)):
		if l==levels[i]:
			if levels.find(l)<=un_locked:
				return true
			else:
				return false
