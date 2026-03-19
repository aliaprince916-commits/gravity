extends CharacterBody2D
@onready var timer: Timer = $Timer

@onready var director: RayCast2D = $director
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# هذ المتغير لازم يكون في كل حاجة حاب نبدل لها الجاذبية
var dir_g=1
var dir_m=1
# متغيرا استطاعة الاستدار
var can_turn=false
const  SPEED=50
func _physics_process(delta: float) -> void:
	# معلومات مهمة حول متغير انجاه الجاذبية والبحث عن حوله في الارض او السقف مع الجاذبية صحيحة
	var is_floor=is_grav(dir_g)
	# جاذبية 
	if not is_floor:
		velocity+=get_gravity()*delta*dir_g
	# حركة االوحش يمين ويسار
	velocity.x=SPEED*dir_m
	#تغير اتجاه الراي كاست بحسب المتغير التجاه
	if dir_m==1:
		animated_sprite_2d.flip_h=false
		director.target_position.x=8
	else:
		animated_sprite_2d.flip_h=true
		director.target_position.x=-8
	# تحديد الوضع جاذبية فوق او تحت على الانميشن
	if dir_g==1:
		animated_sprite_2d.flip_v=false
		director.target_position.y=18
	else:
		animated_sprite_2d.flip_v=true
		director.target_position.y=-18
	if dir_m>0:
		animated_sprite_2d.play("walk")
	move(is_floor)
	move_and_slide()

func move(is_floor):
	if is_floor:
		if (is_on_wall() or !director.is_colliding()) and can_turn:
			dir_m *= -1
			can_turn = false
		if !is_on_wall():
			can_turn = true
	pass
# البحث عن هل هو في الجاذبية الصحيحة لتصحيح التجاه
func is_grav(g):
	if is_on_floor() and g==1:
		return true
	elif is_on_ceiling() and g==-1:
		return true
	else:
		return false
func _die():
	set_physics_process(false) 
	animated_sprite_2d.visible = false  
	$CPUParticles2D.emitting = true
	$Timer.start()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="particulse":
		_die()
		print("hello")
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
