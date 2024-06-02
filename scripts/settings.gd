extends CanvasLayer

# Video Settings
@export var display_options : Button
@export var main_menu_options : OptionButton

# Audio Settings
@export var master_vol : Slider
@export var music_vol : Slider
@export var sfx_vol : Slider

# Controls
@export var control_settings : GridContainer

@export var back_button : Button

# Functions
func _ready():
	SaveSystem.load_game()
	display_options.selected = SaveSystem.settings.display_option_value
	main_menu_options.selected = SaveSystem.settings.main_menu_value
	master_vol.value = SaveSystem.settings.master_vol_value
	music_vol.value = SaveSystem.settings.music_vol_value
	sfx_vol.value = SaveSystem.settings.sfx_vol_value
	SaveSystem.settings.toggle_fullscreen(SaveSystem.settings.display_option_value)
	visible = false
	#create_action_remap_items()

func _on_display_mode_btn_item_selected(index) -> void:
	SaveSystem.settings.toggle_fullscreen(index)

func _on_master_vol_slider_value_changed(value) -> void:
	SaveSystem.settings.update_vol(0, value)

func _on_music_vol_slider_value_changed(value) -> void:
	SaveSystem.settings.update_vol(1, value)

func _on_sfx_vol_slider_value_changed(value) -> void:
	SaveSystem.settings.update_vol(2, value)

func _on_back_button_pressed() -> void:
	SaveSystem.save_settings()
	visible = false
	Global.change_menu.emit()

#func create_action_remap_items() -> void:
	#var previous_item = control_settings.get_child(control_settings.get_child_count() - 1)
	#for index in range(action_items.size()):
		#var action = action_items[index]
		#var label = Label.new()
		#label.text = action
		#label.label_settings = load("res://resources/control_label_settings.tres")
		#control_settings.add_child(label)
		#var button = RemapButton.new()
		#button.action = action
		#button.focus_neighbor_top = previous_item.get_path()
		#previous_item.focus_neighbor_bottom = button.get_path()
		#if index == action_items.size() - 1:
			#button.focus_neighbor_bottom = back_button.get_path()
		#previous_item = button
		#control_settings.add_child(button)

func _on_main_menu_btn_item_selected(index):
	SaveSystem.settings.toggle_main_menu(index)
	SaveSystem.save_settings()
