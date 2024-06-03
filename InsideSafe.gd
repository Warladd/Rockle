extends CanvasLayer
@export var safe : TextureRect
@export var pass_key : LineEdit
@export var coins : Node2D
@export var back_btn : Button
@export var tiny_safe : TextureButton

func _ready():
	if SaveSystem.save_game.safe_opened:
		tiny_safe.hide()
	hide()

func _input(event):
	if event.is_action_pressed("left_click") and SaveSystem.save_game.safe_opened and coins.visible:
		coins.hide()
		SaveSystem.save_game.gear_coins += 5000
		back_btn.disabled = false
		tiny_safe.hide()

func _on_visibility_changed():
	get_tree().paused = visible

func _on_safe_pressed():
	if SaveSystem.save_game.safe_opened:
		return
	show()

func _on_back_button_pressed():
	hide()

func _on_line_edit_text_submitted(new_text):
	print(new_text)
	if new_text == "8332":
		safe.texture = load("res://assets/images/safe_open.png")
		pass_key.visible = false
		coins.show()
		SaveSystem.save_game.safe_opened = true
		back_btn.disabled = true
