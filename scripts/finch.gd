extends Area2D


@export var target=PackedScene
# داخل السكربت الخاص بـ Area2D (بوابة الانتقال)
func _on_body_entered(body: Node2D) -> void:
	
	if body.name == "player":
		Transition.change_scean(Gm.levels[Gm.un_locked + 1], Gm.un_locked + 1, "Next Level!")
