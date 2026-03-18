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
	await $AnimationPlayer.animation_finished# تغيير المرحلة
	get_tree().change_scene_to_file(target)
	await  get_tree().process_frame
	# إنهاء الأنميشن (ظهور المرحلة الجديدة)
	$AnimationPlayer.play_backwards("Fade")
