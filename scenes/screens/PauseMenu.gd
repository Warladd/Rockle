extends CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		self.visible = !self.visible
		get_tree().paused = self.visible

func _on_resume_button_pressed():
	self.visible = !self.visible
	get_tree().paused = self.visible

func _on_quit_button_pressed():
	SaveSystem.saving()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit(0)

func _on_restart_button_pressed():
	$ColorRect/VBoxContainer.hide()
	$ColorRect.color = Color("c6966900")
	$ColorRect/VBoxContainer2.show()

func _on_yes_button_pressed():
	SaveSystem.restart()

func _on_no_button_pressed():
	$ColorRect/VBoxContainer.show()
	$ColorRect.color = Color("c69669c9")
	$ColorRect/VBoxContainer2.hide()
