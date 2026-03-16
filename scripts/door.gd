extends Area2D

# السطر الذي سيظهر في الـ Inspector لتربط الأبواب
@export var target_door_path: NodePath
# خيار جديد لنحدد هل يبدأ هذا الباب مفتوحاً أم مغلقاً
@export var starts_open: bool = true 

@onready var anim: AnimationPlayer = $Visuals/AnimationPlayer
@onready var spawn_point: Marker2D = $SpawnPoint

var is_locked: bool = false

func _ready() -> void:
	# نحدد حالة الباب عند بداية المرحلة بناءً على الخيار في الـ Inspector
	if starts_open:
		if anim.has_animation("idle_open"):
			anim.play("idle_open")
		else:
			anim.play("open") # إذا لم يكن لديك idle_open استخدم open
	else:
		anim.play("close") # يبدأ مغلقاً

func _on_body_entered(body: Node2D) -> void:
	if body.name==("player") and not is_locked:
		var target_door = get_node_or_null(target_door_path)
		if target_door:
			start_teleport(body, target_door)

func start_teleport(player: Node2D, target: Node2D) -> void:
	is_locked = true
	target.is_locked = true
	
	# 1. تجميد حركة اللاعب فور دخوله
	player.set_physics_process(false)
	
	# 2. انتظر قليلاً واللاعب داخل منطقة الباب (قبل القفل)
	await get_tree().create_timer(0.5).timeout 
	
	# 3. تشغيل أنيميشن الغلق
	anim.play("close")
	await anim.animation_finished
	
	# 4. انتظر قليلاً والباب مغلق قبل الانتقال (لزيادة الغموض)
	await get_tree().create_timer(0.4).timeout
	
	# 5. نقل اللاعب للباب الآخر
	player.global_position = target.spawn_point.global_position
	
	# 6. تفعيل الاستقبال في الباب الثاني
	target.receive_player(player)
	
	# قفل أمان لمنع التكرار
	await get_tree().create_timer(1.5).timeout
	is_locked = false
	target.is_locked = false

func receive_player(player: Node2D) -> void:
	# 1. انتظر قليلاً قبل أن يفتح الباب الثاني (وكأن اللاعب خلفه)
	await get_tree().create_timer(0.5).timeout
	
	# 2. فتح الباب الجديد
	anim.play("open")
	await anim.animation_finished
	
	# 3. إعادة الحركة للاعب
	player.set_physics_process(true)
	
	# 4. انتظر قليلاً قبل غلق الباب خلف اللاعب
	await get_tree().create_timer(0.6).timeout
	anim.play("close")
