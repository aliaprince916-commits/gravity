extends Node2D


func _on_level_one_pressed() -> void:
	if  Gm.is_open("res://scenes/lvl_prototype.tscn"):

		Transition.change_scean("res://scenes/lvl_prototype.tscn",1)

		Transition.change_scean("res://scenes/lvl_prototype.tscn")




func _on_level_one_2_pressed() -> void:
	if  Gm.is_open("res://scenes/lvl.tscn"):
		Transition.change_scean("res://scenes/lvl.tscn",2)
