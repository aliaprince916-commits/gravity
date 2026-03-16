extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -280.0

@onready var g: AudioStreamPlayer2D = $g
@onready var jump: AudioStreamPlayer2D = $jump
@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# هذ المتغير لازم يكون في كل حاجة حاب نبدل لها الجاذبية
var dir_p=1

func _physics_process(delta: float) -> void:
	# معلومات مهمة حول متغير انجاه الجاذبية والبحث عن حوله في الارض او السقف مع الجاذبية صحيحة
	var is_floor=is_grav(dir_p)
	# هذ متغير اتجاه التحرك يمين اوي سار على حسب الزر الذي انت ظاغط عليه 
	gravity_jump(delta,is_floor)
	var direction := Input.get_axis("ui_left", "ui_right")
	# Add the gravity.
	move(direction,is_floor)
	move_and_slide()
	# عملية تغير الجاذبية لنفسه 
	if Input.is_action_just_pressed("g") and is_floor:
		dir_p*=-1
		g.play()
	
# دالة القفز والجمب
func gravity_jump(delta,is_floor):
	if !is_floor:
		velocity +=get_gravity()*delta*dir_p
	if Input.is_action_just_pressed("ui_accept") and is_floor:
		velocity.y =JUMP_VELOCITY*dir_p
		jump.play()
	if not is_floor:
		animated_sprite_2d.play("jump")
		if dir_p==1:
			animated_sprite_2d.flip_v=false
		else:
			animated_sprite_2d.flip_v=true
		
# دالة المشي وفق متغير الاتجاه
func move(direction,is_floor):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	pass

	if direction>0:
		animated_sprite_2d.flip_h=false
	if direction<0:
		animated_sprite_2d.flip_h=true
	if is_floor:
		if direction==0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	
# البحث عن هل هو في الجاذبية الصحيحة لتصحيح التجاه
func is_grav(g):
	if is_on_floor() and g==1:
		return true
	elif is_on_ceiling() and g==-1:
		return true
	else:
		return false
func die():
	set_physics_process(false)
	animated_sprite_2d.play("die")
	timer.start()
