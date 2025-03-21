class_name Settings extends Resource

@export var display_option_value = 0
@export var master_vol_value = -15
@export var music_vol_value = -15
@export var sfx_vol_value = -15
@export var main_menu_value = 0

func toggle_fullscreen(value) -> void:
	display_option_value = value
	if value == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func toggle_main_menu(value) -> void:
	main_menu_value = value

func update_vol(bus_idx, vol) -> void:
	if bus_idx == 0:
		master_vol_value = vol
	elif bus_idx == 1:
		music_vol_value = vol
	elif bus_idx == 2:
		sfx_vol_value = vol
	if vol <= -40:
		AudioServer.set_bus_mute(bus_idx, true)
	AudioServer.set_bus_volume_db(bus_idx, vol)
