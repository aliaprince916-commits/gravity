extends CharacterBody2D
# --- الكود الذي يجب إضافته ---

# تأكد من أن المسار يبدأ من مكان وجود السكريبت (Player) وصولاً للعقدة
@onready var pause_button= $CanvasLayer2/PauseButton # غير CanvasLayer لاسم العقدة الأم للأزرار عندك
@onready var pause_menu = $CanvasLayer2/PauseMenu
@export var ghost_enabeld:bool=true
const SPEED = 200.0
const JUMP_VELOCITY = -280.0
@export var shadow_scene :PackedScene
@onready var death_ui = $CanvasLayer
@onready var message_label = $CanvasLayer/DeathMessage
@onready var g: AudioStreamPlayer2D = $g
@onready var jump: AudioStreamPlayer2D = $jump

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
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _on_retry_pressed() -> void:
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
	get_tree().paused = false  # تشغيل اللعبة
	pause_menu.hide()          # إخفاء القائمة
	pause_button.show()     # إظهار زر البوز

# 3. وظيفة زر الخروج (Quit)
func _on_quit_pressed():
	get_tree().quit()          # إغلاق اللعبة


func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_lvl.tscn")
	pass # Replace with function body.
