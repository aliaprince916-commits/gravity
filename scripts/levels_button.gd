extends Node2D

# دالة تغيير المشهد + التحقق
func _on_pressed(lvl, num):
	if Gm.is_open(lvl):
		Transition.change_scean(lvl, num,"")



func _on_level_1_pressed() -> void:
	_on_pressed("res://scenes/lvl_prototype.tscn","level1")
func _on_level_2_pressed() -> void:
	_on_pressed("res://scenes/lvl.tscn","level2")

func _on_home_pressed() -> void:
	Transition.change_scean("res://scenes/mainmenu.tscn",0,"home")


func _on_level_3_pressed() -> void:
	_on_pressed("res://scenes/lvl2.tscn","level3")
