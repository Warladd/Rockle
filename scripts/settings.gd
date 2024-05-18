extends Popup

# Video Settings
@export var display_options : Button
@onready var settings_menu = self

# Audio Settings
@export var master_vol : Slider
@export var music_vol : Slider
@export var sfx_vol : Slider

# Gameplay
@export var godmode_button : Button
@export var ohko_button : Button
@export var walk_button : Button
@export var jump_button : Button
@export var dash_button : Button
@export var double_jump_button : Button
@export var wall_jump_button : Button
@export var lunge_button : Button
@export var charged_dash_button : Button
@export var grappling_hook_button : Button
@export var teleport_button : Button

# Functions
func _ready():
	self.visible = false

func _on_display_mode_btn_item_selected(index) -> void:
	SaveSystem.settings.toggle_fullscreen(index)

func _on_master_vol_slider_value_changed(value) -> void:
	SaveSystem.settings.update_vol(0, value)

func _on_music_vol_slider_value_changed(value) -> void:
	SaveSystem.settings.update_vol(1, value)

func _on_sfx_vol_slider_value_changed(value) -> void:
	SaveSystem.settings.update_vol(2, value)

func _on_back_button_pressed() -> void:
	SaveSystem.settings_saving()
	self.visible = false

func _on_ohko_button_toggled(button_pressed) -> void:
	SaveSystem.settings.ohko_set(button_pressed)

func _on_god_mode_button_toggled(button_pressed) -> void:
	SaveSystem.settings.god_mode_set(button_pressed)

func _on_popup_hide() -> void:
	SaveSystem.settings_saving()

func _on_about_to_popup() -> void:
	SaveSystem.settings_load()
	display_options.selected = SaveSystem.settings.display_option_value
	master_vol.value = SaveSystem.settings.master_vol_value
	music_vol.value = SaveSystem.settings.music_vol_value
	sfx_vol.value = SaveSystem.settings.sfx_vol_value
	godmode_button.button_pressed = SaveSystem.settings.godmode
	ohko_button.button_pressed = SaveSystem.settings.ohko
	walk_button.button_pressed = SaveSystem.settings.sprint
	jump_button.button_pressed = SaveSystem.settings.jump
	dash_button.button_pressed = SaveSystem.settings.dash
	double_jump_button.button_pressed = SaveSystem.settings.double_jump
	wall_jump_button.button_pressed = SaveSystem.settings.wall_climb
	charged_dash_button.button_pressed = SaveSystem.settings.charged_dash
	teleport_button.button_pressed = SaveSystem.settings.teleport


func _on_walk_button_toggled(button_pressed):
	SaveSystem.settings.move_set(button_pressed)

func _on_jump_button_toggled(button_pressed):
	SaveSystem.settings.jump_set(button_pressed)
	
func _on_dash_button_toggled(button_pressed):
	SaveSystem.settings.dash_set(button_pressed)
	
func _on_double_jump_button_toggled(button_pressed):
	SaveSystem.settings.double_jump_set(button_pressed)
	
func _on_wall_jump_button_toggled(button_pressed):
	SaveSystem.settings.wall_jump_set(button_pressed)
	
func _on_charged_dash_button_toggled(button_pressed):
	SaveSystem.settings.charged_dash_set(button_pressed)
	
func _on_teleport_button_toggled(button_pressed):
	SaveSystem.settings.teleport_set(button_pressed)
