extends Control

var quit_scene = preload("res://quit_dialog.tscn")
var popup = null

func change_scene(path: String):
	var layer = CanvasLayer.new()
	var rect = ColorRect.new()
	rect.color = Color(0, 0, 0, 0)
	rect.set_anchors_preset(PRESET_FULL_RECT)
	
	layer.add_child(rect)
	add_child(layer)
	
	var tw = create_tween()
	tw.tween_property(rect, "color:a", 1.0, 1.0)
	await tw.finished
	
	get_tree().change_scene_to_file(path)

func _on_start_pressed():
	change_scene("res://gameplay.tscn")

func _on_credits_pressed():
	change_scene("res://how_to_play_the_game.tscn")

func _on_exit_pressed():
	if not is_instance_valid(popup):
		popup = quit_scene.instantiate()
		add_child(popup)
