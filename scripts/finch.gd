extends Area2D


@export var target=PackedScene
# داخل السكربت الخاص بـ Area2D (بوابة الانتقال)
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.is_in_group("player"):
		ScenesTr.change_(target)
