extends Node2D


@onready var click: AudioStreamPlayer2D = $click

func _on_continue_pressed() -> void:
	click.play()
	# التأكد من أن الرقم لا يتخطى عدد المراحل المتاحة
	var index = clamp(Gm.un_locked, 0, Gm.levels.size() - 1)
	var target_path = Gm.levels[index]
	Transition.change_scean(target_path, index + 1, "")
func _on_play_pressed() -> void:
	click.play()
	Transition.change_scean("res://scenes/main_lvl.tscn",0,"levels")
func _on_quit_pressed() -> void:
	get_tree().quit()
