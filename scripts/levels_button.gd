extends Node2D


func _on_level_one_pressed() -> void:
	if  Gm.is_open("res://scenes/lvl_prototype.tscn"):
		get_tree().change_scene_to_file("res://scenes/lvl_prototype.tscn")



func _on_level_one_2_pressed() -> void:
	if  Gm.is_open("res://scenes/lvl.tscn"):
		get_tree().change_scene_to_file("res://scenes/lvl.tscn")
