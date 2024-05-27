extends Control
@export var settings : CanvasLayer
@export var surge : Sprite2D
@export var adamant : Sprite2D
@export var flow : Sprite2D
@export var volatile : Sprite2D

func _ready():
	SaveSystem.load_game()
	settings.hide()

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
	surge.texture = load("res://assets/images/shiftstones/surge_stone_activated.png")

func _on_button_mouse_exited():
	surge.texture = load("res://assets/images/shiftstones/surge_stone_deactivated.png")

func _on_button_2_mouse_entered():
	adamant.texture = load("res://assets/images/shiftstones/adamant_stone_active.png")

func _on_button_2_mouse_exited():
	adamant.texture = load("res://assets/images/shiftstones/adamant_stone_inactive.png")

func _on_button_3_mouse_entered():
	flow.texture = load("res://assets/images/shiftstones/flow_stone_activated.png")

func _on_button_3_mouse_exited():
	flow.texture = load("res://assets/images/shiftstones/flow_stone_deactivated.png")

func _on_button_4_mouse_entered():
	volatile.texture = load("res://assets/images/shiftstones/volatile_stone_activated.png")

func _on_button_4_mouse_exited():
	volatile.texture = load("res://assets/images/shiftstones/volatile_stone_deactivated.png")
