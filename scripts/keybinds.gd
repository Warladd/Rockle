extends Resource
class_name Keybinds
@export var straight_input : String = "mouse_1"
@export var stomp_input : String = "space"
@export var kick_input : String = "z"
@export var uppercut_input : String = "mouse_2"
@export var parry_input : String = "x"
@export var hold_input : String = "c"
@export var explode_input : String = "v"

func save_keybinding(action : StringName, event: InputEvent):
	if action == "straight":
		if event is InputEventKey:
			straight_input = OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			straight_input = "mouse_" + str(event.button_index)
	elif action == "stomp":
		if event is InputEventKey:
			stomp_input = OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			stomp_input = "mouse_" + str(event.button_index)
	elif action == "kick":
		if event is InputEventKey:
			kick_input = OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			kick_input = "mouse_" + str(event.button_index)
	elif action == "uppercut":
		if event is InputEventKey:
			uppercut_input = OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			uppercut_input = "mouse_" + str(event.button_index)
	elif action == "parry":
		if event is InputEventKey:
			parry_input = OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			parry_input = "mouse_" + str(event.button_index)
	elif action == "hold":
		if event is InputEventKey:
			hold_input = OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			hold_input = "mouse_" + str(event.button_index)
	elif action == "explode":
		if event is InputEventKey:
			explode_input = OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			explode_input = "mouse_" + str(event.button_index)
	SaveSystem.save_keybinds()

func load_keybindings():
	var keybindings = {}
	var input_event
	if straight_input.contains("mouse_"):
		input_event = InputEventMouseButton.new()
		input_event.button_index = int(straight_input.split("_")[1])
	else:
		input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(straight_input)
	keybindings[0] = input_event
	input_event = null
	if stomp_input.contains("mouse_"):
		input_event = InputEventMouseButton.new()
		input_event.button_index = int(stomp_input.split("_")[1])
	else:
		input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(stomp_input)
	keybindings[1] = input_event
	input_event = null
	if kick_input.contains("mouse_"):
		input_event = InputEventMouseButton.new()
		input_event.button_index = int(kick_input.split("_")[1])
	else:
		input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(kick_input)
	keybindings[2] = input_event
	input_event = null
	if uppercut_input.contains("mouse_"):
		input_event = InputEventMouseButton.new()
		input_event.button_index = int(uppercut_input.split("_")[1])
	else:
		input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(uppercut_input)
	keybindings[3] = input_event
	input_event = null
	if parry_input.contains("mouse_"):
		input_event = InputEventMouseButton.new()
		input_event.button_index = int(parry_input.split("_")[1])
	else:
		input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(parry_input)
	keybindings[4] = input_event
	input_event = null
	if hold_input.contains("mouse_"):
		input_event = InputEventMouseButton.new()
		input_event.button_index = int(hold_input.split("_")[1])
	else:
		input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(hold_input)
	keybindings[5] = input_event
	input_event = null
	if explode_input.contains("mouse_"):
		input_event = InputEventMouseButton.new()
		input_event.button_index = int(explode_input.split("_")[1])
	else:
		input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(explode_input)
	keybindings[6] = input_event
	input_event = null
	return keybindings
