extends CanvasLayer
@export var settings : CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("esc") and !Global.shop:
		self.visible = !self.visible
		get_tree().paused = self.visible
	if Input.is_action_just_pressed("codes"):
		pass
		
func _on_resume_button_pressed():
	self.visible = !self.visible
	get_tree().paused = self.visible

func _on_quit_button_pressed():
	SaveSystem.saving()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit(0)

func _on_restart_button_pressed():
	$ColorRect/VBoxContainer.hide()
	$ColorRect/VBoxContainer2.show()

func _on_yes_button_pressed():
	SaveSystem.restart()
	$ColorRect/VBoxContainer2.hide()
	$ColorRect/VBoxContainer.show()
	self.visible = !self.visible
	get_tree().paused = self.visible
	get_tree().reload_current_scene()

func _on_no_button_pressed():
	$ColorRect/VBoxContainer.show()
	$ColorRect/VBoxContainer2.hide()

func _on_quitto_menu_button_pressed():
	SaveSystem.saving()
	await get_tree().create_timer(0.5).timeout
	self.visible = !self.visible
	get_tree().paused = self.visible
	if SaveSystem.settings.main_menu_value == 1:
		Global.get_tree().change_scene_to_file("res://scenes/screens/main_menu_alt.tscn")
	elif SaveSystem.settings.main_menu_value == 0:
		Global.get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")

func _on_settings_button_pressed():
	settings.show()
