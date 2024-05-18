extends CanvasLayer

# Video Settings
@export var display_options : Button
@onready var settings_menu = self

# Audio Settings
@export var master_vol : Slider
@export var music_vol : Slider
@export var sfx_vol : Slider

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
	SaveSystem.save_settings()
	self.visible = false

func _on_popup_hide() -> void:
	SaveSystem.save_settings()

func _on_visibility_changed():
	SaveSystem.load_game()
	display_options.selected = SaveSystem.settings.display_option_value
	master_vol.value = SaveSystem.settings.master_vol_value
	music_vol.value = SaveSystem.settings.music_vol_value
	sfx_vol.value = SaveSystem.settings.sfx_vol_value
