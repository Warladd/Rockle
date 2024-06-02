extends CanvasLayer
@export var safe = TextureRect

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("esc"):
		hide()

func _on_visibility_changed():
	get_tree().paused = visible

func _on_safe_pressed():
	if SaveSystem.save_game.safe_opened:
		return
	show()

func _on_back_button_pressed():
	hide()

func _on_line_edit_text_submitted(new_text):
	if new_text == "8332":
		safe = load("res://assets/images/safe_open.png")
		SaveSystem.save_game.gear_coins += 1000
		SaveSystem.save_game.safe_opened = true
