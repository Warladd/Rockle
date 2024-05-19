extends Button 
class_name RemapButton

@export var action : String = "kick"
var is_remapping : bool = false

func _init():
	toggle_mode = true

func _ready() -> void:
	_load_keybindings_from_settings()

func _load_keybindings_from_settings():
	var keybindings = SaveSystem.settings.load_keybindings()
	InputMap.action_erase_events(action)
	var i
	if action == "straight":
		i = 0
	elif action == "stomp":
		i = 1
	elif action == "kick":
		i = 2
	elif action == "uppercut":
		i = 3
	InputMap.action_add_event(action, keybindings[i])
	text = "%s" % InputMap.action_get_events(action)[0].as_text()

func _toggled(toggled_on):
	if !is_remapping:
		is_remapping = true
		text = "Awaiting Input..."
	#elif !toggled_on:
		#update_key_text()
		#grab_focus()

func _input(event):
	if is_remapping:
		if (
			event is InputEventKey or
			(event is InputEventMouseButton and event.pressed)
		):
			# Turn double click into single click
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			#if event is InputEventMouseButton:
				#if "mouse_" + str(event.button_index) == SaveSystem.settings.straight_input or "mouse_" + str(event.button_index) == SaveSystem.settings.kick_input or "mouse_" + str(event.button_index) == SaveSystem.settings.stomp_input or "mouse_" + str(event.button_index) == SaveSystem.settings.uppercut_input:
					#return
			#if event == SaveSystem.settings.straight_input or event == SaveSystem.settings.kick_input or event == SaveSystem.settings.stomp_input or event == SaveSystem.settings.uppercut_input:
				#return
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			SaveSystem.settings.save_keybinding(action, event)
			text = "%s" % InputMap.action_get_events(action)[0].as_text()
			
			is_remapping = false
			
			accept_event()
