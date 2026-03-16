extends Node2D

# كود زر البداية (PLAY)
func _on_button_pressed() -> void:
		# تأكد أن "level1.tscn" هو نفس اسم ملف مرحلتك بالضبط
	get_tree().change_scene_to_file("res://scenes/main_lvl.tscn")
	pass # Replace with function body.
# كود زر الخروج (EXIT)

func _on_button_3_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
