extends Control
@export var settings : CanvasLayer
@export var surge : Sprite2D
@export var adamant : Sprite2D
@export var flow : Sprite2D
@export var volatile : Sprite2D
@export var tower : Sprite2D
@export var gear_coin : TextureRect
@export var gc_amount : Label
@export var sfx_player : AudioStreamPlayer2D

func _ready():
	SaveSystem.load_game()
	change_menu()
	settings.hide()
	if SaveSystem.save_game.belt == 6:
		tower.texture = load("res://assets/images/tower%d.png" % SaveSystem.save_game.belt)
		gear_coin.texture = load("res://assets/images/gear_coin%d.png" % SaveSystem.save_game.belt)
	tower.texture = load("res://assets/images/tower%d.png" % (SaveSystem.save_game.belt + 1))
	gear_coin.texture = load("res://assets/images/gear_coin%d.png" % (SaveSystem.save_game.belt + 1))
	var gear_coin_string = str(SaveSystem.save_game.gear_coins)
	for i in range(int((len(gear_coin_string) - 1) /3)):
		gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
	gc_amount.text = gear_coin_string
	Global.change_menu.connect(change_menu)

func _on_button_pressed():
	if !SaveSystem.save_game.tutorial:
		get_tree().change_scene_to_file("res://scenes/screens/game.tscn")
	elif SaveSystem.save_game.tutorial:
		get_tree().change_scene_to_file("res://scenes/screens/tutorial.tscn")

func _on_button_2_pressed():
	settings.show()

func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://scenes/screens/tutorial.tscn")

func _on_button_4_pressed():
	get_tree().quit(0)

func _on_button_mouse_entered():
	var sound = randi_range(1, 4)
	var sound_string = "res://assets/audio/sfx/gem_sounds/gem_sound_%d.mp3" % sound
	sfx_player.stream = load(sound_string)
	sfx_player.play()
	surge.texture = load("res://assets/images/shiftstones/surge_stone_activated.png")

func _on_button_mouse_exited():
	surge.texture = load("res://assets/images/shiftstones/surge_stone_deactivated.png")

func _on_button_2_mouse_entered():
	var sound = randi_range(1, 4)
	var sound_string = "res://assets/audio/sfx/gem_sounds/gem_sound_%d.mp3" % sound
	sfx_player.stream = load(sound_string)
	sfx_player.play()
	adamant.texture = load("res://assets/images/shiftstones/adamant_stone_active.png")

func _on_button_2_mouse_exited():
	adamant.texture = load("res://assets/images/shiftstones/adamant_stone_inactive.png")

func _on_button_3_mouse_entered():
	var sound = randi_range(1, 4)
	var sound_string = "res://assets/audio/sfx/gem_sounds/gem_sound_%d.mp3" % sound
	sfx_player.stream = load(sound_string)
	sfx_player.play()
	flow.texture = load("res://assets/images/shiftstones/flow_stone_activated.png")

func _on_button_3_mouse_exited():
	flow.texture = load("res://assets/images/shiftstones/flow_stone_deactivated.png")

func _on_button_4_mouse_entered():
	var sound = randi_range(1, 4)
	var sound_string = "res://assets/audio/sfx/gem_sounds/gem_sound_%d.mp3" % sound
	sfx_player.stream = load(sound_string)
	sfx_player.play()
	volatile.texture = load("res://assets/images/shiftstones/volatile_stone_activated.png")

func _on_button_4_mouse_exited():
	volatile.texture = load("res://assets/images/shiftstones/volatile_stone_deactivated.png")

func change_menu():
	if SaveSystem.settings.main_menu_value == 2 and scene_file_path != "res://scenes/screens/main_menu_alt_2.tscn":
		Global.get_tree().change_scene_to_file("res://scenes/screens/main_menu_alt_2.tscn")
	elif SaveSystem.settings.main_menu_value == 1 and scene_file_path != "res://scenes/screens/main_menu_alt.tscn":
		Global.get_tree().change_scene_to_file("res://scenes/screens/main_menu_alt.tscn")
	elif SaveSystem.settings.main_menu_value == 0 and scene_file_path != "res://scenes/screens/main_menu.tscn":
		Global.get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
