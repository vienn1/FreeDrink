extends Control

func _on_yes_button_pressed():
	if OS.has_feature("web"):
		$Label.text = "Silakan tutup tab browser."
		$YesButton.hide()
		return
	
	var layer = CanvasLayer.new()
	var fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	fade.set_anchors_preset(PRESET_FULL_RECT)
	
	layer.add_child(fade)
	get_tree().root.add_child(layer)
	
	var tw = create_tween()
	tw.tween_property(fade, "color:a", 1.0, 0.8)
	await tw.finished
	get_tree().quit()

func _on_no_button_pressed():
	queue_free()
