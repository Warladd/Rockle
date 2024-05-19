extends Button 
class_name RemapButton

@export var action : String = "straight"

func _init():
	toggle_mode = true
	theme_type_variation = "RemapButton"

func _ready() -> void:
	set_process_unhandled_input(false)
	update_key_text()

func _toggled(toggled_on):
	set_process_unhandled_input(toggled_on)
	if toggled_on:
		text = "Awaiting Input..."
		release_focus()
	elif !toggled_on:
		update_key_text()
		grab_focus()

func _unhandled_input(event):
	if event.pressed:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false

func update_key_text():
	text = "%s" % InputMap.action_get_events(action)[0].as_text()
