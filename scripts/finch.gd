extends Area2D

# تحديد المسار والرقم من الـ Inspector
@export_file("*.tscn") var target_level: String
@export var level_number: int = 2
# داخل السكربت الخاص بـ Area2D (بوابة الانتقال)
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.is_in_group("player"):
		if target_level != "":
			# إذا كانت المرحلة التالية أكبر من المفتوح حالياً، حدّث الحفظ
			if level_number > Gm.un_locked:
				Gm.un_locked = level_number
				Gm.save_game() # حفظ التقدم الجديد على الجهاز
			
			Transition.change_scean(target_level, level_number, "")
