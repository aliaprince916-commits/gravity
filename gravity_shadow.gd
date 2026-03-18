extends Area2D

@export var pull_speed = 70

func _physics_process(delta):
	# البحث عن اللاعب لسحبه نحو مركز الظل
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "player" or body.is_in_group("player"):
			# حساب الاتجاه من اللاعب إلى مركز الظل
			var direction = (global_position - body.global_position).normalized()
			# تحريك اللاعب تدريجياً نحو المركز
			body.global_position += direction * pull_speed * delta# يختفي تماماً خلال ثانيتين
