extends CharacterBody2D
var dir_g=1
func _physics_process(delta: float) -> void:
	var is_floor=is_grav(dir_g)
	if !is_floor:
		velocity=get_gravity()*delta*dir_g
	velocity.x=move_toward(velocity.x,0,5)
	move_and_slide()
# البحث عن هل هو في الجاذبية الصحيحة لتصحيح التجاه
func is_grav(g):
	if is_on_floor() and g==1:
		return true
	elif is_on_ceiling() and g==-1:
		return true
	else:
		return false
