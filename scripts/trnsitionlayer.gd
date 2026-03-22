extends CanvasLayer
@onready var click: AudioStreamPlayer2D = $click
func change_scean(target, level_number,text_):
	click.play()
	# تحديث النص ليظهر رقم 
	if target in Gm.levels:
		$Label.text = "Level " + str(level_number)
	else:
		$Label.text = text_
					# بدء الأنميشن
	$AnimationPlayer.play("Fade")
	# انتظار انتهاء الأنميشن قبل تغيير المشهد
	await $AnimationPlayer.animation_finished# تغيير 
	get_tree().change_scene_to_file(target)
	get_tree().paused=true
	await  get_tree().process_frame
	# إنهاء الأنميشن (ظهور المرحلة الج
	$AnimationPlayer.play_backwards("Fade")
	await $AnimationPlayer.animation_finished
	get_tree().paused=false
