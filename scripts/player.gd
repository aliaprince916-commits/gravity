extends CharacterBody2D
# --- الكود الذي يجب إضافته ---
const SPEED = 200.0
const JUMP_VELOCITY = -280.0
const PUSH=100
const MAX_VELOCITY=150
# تأكد من أن المسار يبدأ من مكان وجود السكريبت (Player) وصولاً للعقدة
@onready var pause_button= $CanvasLayer2/PauseButton # غير CanvasLayer لاسم العقدة الأم للأزرار عندك
@onready var pause_menu = $CanvasLayer2/PauseMenu
@export var ghost_enabeld:bool=true
@export var shadow_scene :PackedScene
@onready var death_ui = $CanvasLayer
@onready var message_label = $CanvasLayer/DeathMessage
@onready var g: AudioStreamPlayer2D = $g
@onready var jump: AudioStreamPlayer2D = $jump
@onready var click: AudioStreamPlayer2D = $click
@onready var die_: AudioStreamPlayer2D = $die_
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# هذ المتغير لازم يكون في كل حاجة حاب نبدل لها الجاذبية
@export var dir_p=1

func _physics_process(delta: float) -> void:
	# 1. تحديث اتجاه الأعلى (Up Direction) بناءً على الجاذبية الحالية
	# هذا السطر يغنيك عن دالة is_grav المعقدة ويحل مشاكل التصادم
	up_direction = Vector2.UP if dir_p == 1 else Vector2.DOWN
	
	# 2. إضافة الجاذبية (تستخدم dir_p لتحديد الاتجاه)
	if not is_on_floor():
		velocity += get_gravity() * delta * dir_p

	# 3. معالجة القفز (is_on_floor الآن تعمل في السقف والأرض بفضل up_direction)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * dir_p
		jump.play()

	# 4. معالجة الحركة الأفقية
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# تغير الكولليشن بحسب الجاذبية
	$CollisionShape2D.position.x=-2 if dir_p==1 else 2
	# 5. استدعاء الحركة (يجب أن يكون قبل فحص تصادم الصناديق)
	move_and_slide()

	# 6. دفع الصندوق (RigidBody2D) - كود نظيف وبدون اهتزاز
	for i in get_slide_collision_count():
		var collision=get_slide_collision(i)
		var collision_box=collision.get_collider()
		if collision_box.is_in_group("box") and abs(collision_box.get_linear_velocity().x)<MAX_VELOCITY:
			collision_box.apply_central_impulse(collision.get_normal()*-PUSH)

	# 7. تغيير الجاذبية (الضغط على زر G)
	if Input.is_action_just_pressed("g") and is_on_floor():
		dir_p *= -1
		g.play()
		# اختيار بكسل آرت: قلب الأنميشن فوراً
		animated_sprite_2d.flip_v = (dir_p == -1)

	# 8. تحديث الأنيميشن
	update_animations(direction)

# دالة منفصلة للأنيميشن ليبقى الكود منظماً
func update_animations(direction):
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	elif direction != 0:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = (direction < 0)
	else:
		animated_sprite_2d.play("idle")
	# استدعاء الـ Scene الخاص بالظل (تأكد من عمل Preload له)
var is_dead: bool = false # تعريف المتغير في أعلى الملف

func die():
	if is_dead: 
		return # لمنع استدعاء الدالة أكثر من مرة
	
	is_dead = true
	set_physics_process(false) # إيقاف حركة اللاعب
	
	# تشغيل أنميشن الموت
	if animated_sprite_2d.sprite_frames.has_animation("die"):
		animated_sprite_2d.play("die")
		die_.play()
		
	
	# الانتظار حتى ينتهي الأنميشن تماماً (أهم خطوة في Godot 4)
	await animated_sprite_2d.animation_finished 
	
	# بعد انتهاء الأنميشن، انتظر فريم واحد إضافي للتأكد (اختياري)
	await get_tree().process_frame
	
	show_death_screen()
	# 3. إظهار رسالة الموت العشوائية
	# 4. إنشاء الظل في مكان الموت
	if ghost_enabeld and shadow_scene:
		var shadow = shadow_scene.instantiate()
		shadow.global_position = global_position
		GlobalGraveryerd.add_child(shadow)
		print("yes")
func _on_player_death():
	# 1. إظهار الرسالة العشوائية
	show_death_screen()
	# 2. إنشاء الظل في موقع الموت الحالي
	if shadow_scene:
		var shadow_instance = shadow_scene.instantiate()
		shadow_instance.global_position = global_position
		# إضافة الظل للمشهد الأساسي وليس كابن للاعب (لأنه سيموت)
		get_tree().current_scene.add_child(shadow_instance)
func show_death_screen():
	# 1. اختيار رسالة إنجليزية عشوائية
	var messages = [
		"FATAL ERROR: GRAVITY"  ,
		"THE SHADOW CONSUMED YOU",
		"WASTED IN THE VOID     ",
		"GAME OVER,try again    ",
		"no checkpoint"
	]
	message_label.text = messages.pick_random()
	
	death_ui.show()
	$CanvasLayer2/PauseButton.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _on_retry_pressed() -> void:
	get_tree().paused = false 
	get_tree().reload_current_scene()
func _on_home_pressed() -> void:
	# استبدل المسار أدناه بمسار مشهد القائمة الرئيسية عندك
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")


# 1. وظيفة زر البوز الرئيسي (PauseButton)
func _ready():
	# نخفي القائمة فقط عند بدء اللعبة
	$CanvasLayer2/PauseMenu.hide() 
	# الزر سيبقى ظاهراً لأنه ليس ابناً لـ PauseMenu
	$CanvasLayer2/PauseButton.show() 

func _on_pause_button_pressed():
	get_tree().paused = true
	$CanvasLayer2/PauseMenu.show()   # تظهر القائمة الآن فوق كل شيء
	$CanvasLayer2/PauseButton.hide() # اختياري: إذا أردت إخفاء الزر الصغير لكي لا يظهر خلف القائمة
	# إخفاء الزر

# 2. وظيفة زر العودة (resume) - الموجود داخل Control
func _on_resume_pressed():
	click.play()
	get_tree().paused = false  # تشغيل اللعبة
	pause_menu.hide()          # إخفاء القائمة
	pause_button.show()     # إظهار زر البوز

# 3. وظيفة زر الخروج (Quit)
func _on_quit_pressed():
	click.play()
	get_tree().quit()          # إغلاق اللعبة


func _on_levels_pressed() -> void:
	click.play()
	get_tree().paused = false 
	Transition.change_scean("res://scenes/main_lvl.tscn",0,"")
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("die" ) and body.name!="player":
		die()
