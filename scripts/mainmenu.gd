extends Node2D


func _on_continue_pressed() -> void:
	Transition.change_scean("res://scenes/lvl_prototype.tscn",1,"")
func _on_play_pressed() -> void:
	Transition.change_scean("res://scenes/main_lvl.tscn",0,"levels")
func _on_quit_pressed() -> void:
	get_tree().quit()
