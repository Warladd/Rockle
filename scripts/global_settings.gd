class_name Settings extends Resource

@export var display_option_value = 0
@export var master_vol_value = -15
@export var music_vol_value = -15
@export var sfx_vol_value = -15
@export var standard_run = false

# Cheats
@export var godmode : bool = false
@export var ohko : bool = false

# Abilities
@export var jump : bool = true
@export var sprint : bool = true
@export var dash : bool = false
@export var double_jump : bool = false
@export var wall_climb : bool = false
@export var charged_dash : bool = false
@export var teleport : bool = false

func toggle_fullscreen(value) -> void:
	display_option_value = value
	if value == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func update_vol(bus_idx, vol) -> void:
	if bus_idx == 0:
		master_vol_value = vol
	elif bus_idx == 1:
		music_vol_value = vol
	elif bus_idx == 2:
		sfx_vol_value = vol
	AudioServer.set_bus_volume_db(bus_idx, vol)

func god_mode_set(value) -> void:
	godmode = value

func ohko_set(value) -> void:
	ohko = value
	
func move_set(value) -> void:
	sprint = value
	
func jump_set(value) -> void:
	jump = value
	
func dash_set(value) -> void:
	dash = value
	
func double_jump_set(value) -> void:
	double_jump = value
	
func wall_jump_set(value) -> void:
	wall_climb = value
	
func charged_dash_set(value) -> void:
	charged_dash = value
	
func teleport_set(value) -> void:
	teleport = value
