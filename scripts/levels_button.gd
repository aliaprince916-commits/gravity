extends Node2D

# دالة تغيير المشهد + التحقق
func _on_pressed(lvl, num):
	if Gm.is_open(lvl):
		Transition.change_scean(lvl, num)

func _on_level_2_pressed() -> void:
	_on_pressed("res://scenes/lvl.tscn",2)


func _on_level_1_pressed() -> void:
	_on_pressed("res://scenes/lvl_prototype.tscn",1)
