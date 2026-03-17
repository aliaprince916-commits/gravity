extends CanvasLayer

func change_scean(target, level_number):
	# تحديث النص ليظهر رقم المرحلة
	$Label.text = "Level " + str(level_number)
	
	# تحديث نظام الحفظ إذا كانت المرحلة جديدة
	if level_number > Gm.un_locked:
		Gm.un_locked = level_number
		Gm.save_game() # حفظ التلقائي
	
	# بدء الأنميشن
	$AnimationPlayer.play("Fade")
	
	# انتظار انتهاء الأنميشن قبل تغيير المشهد
	await $AnimationPlayer.animation_finished
	
	# تغيير المرحلة
	get_tree().change_scene_to_file(target)
	
	# إنهاء الأنميشن (ظهور المرحلة الجديدة)
	$AnimationPlayer.play_backwards("Fade")
