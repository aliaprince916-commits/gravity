extends Area2D

# تحديد المسار والرقم من الـ Inspector
@export_file("*.tscn") var target_level: String
@export var level_number: int = 2

func _on_body_entered(body: Node2D) -> void:
	# التحقق من أن الكائن هو اللاعب
	if body.name == "player" or body.is_in_group("player"):
		if target_level != "":
			# استدعاء دالة الانتقال
			Transition.change_scean(target_level, level_number)
		else:
			print("Error: No target level selected!")
