extends CanvasLayer
@onready var click: AudioStreamPlayer2D = $click
func change_scean(target, level_number, text_):
	click.play()
 
	
	$AnimationPlayer.play("Fade")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	get_tree().paused=true
	await  get_tree().process_frame
	# إنهاء الأنميشن (ظهور المرحلة الج
	$AnimationPlayer.play_backwards("Fade")
	await $AnimationPlayer.animation_finished
	get_tree().paused=false
