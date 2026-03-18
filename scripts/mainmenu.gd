extends Node2D


@onready var click: AudioStreamPlayer2D = $click

func _on_continue_pressed() -> void:
	click.play()
	Transition.change_scean("res://scenes/lvl_prototype.tscn",1,"")
func _on_play_pressed() -> void:
	click.play()
	Transition.change_scean("res://scenes/main_lvl.tscn",0,"levels")
func _on_quit_pressed() -> void:
	get_tree().quit()
