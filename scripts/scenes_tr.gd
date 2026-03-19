extends CanvasLayer
@onready var portal: AudioStreamPlayer2D = $portal
func change_(target:PackedScene):
# بدء الأن
	portal.play()
	$AnimationPlayer.play("Fade")
# انتظار انتهاء الأنميشن قبل تغيير المشهد
	await $AnimationPlayer.animation_finished# تغيير المرحلة
	get_tree().change_scene_to_packed(target)
	await  get_tree().process_frame
	$AnimationPlayer.play_backwards("Fade")
	Gm.un_locked+=1
	Gm.save_game()
