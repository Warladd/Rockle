extends Node2D
var gear_coins : int = 0
var gear_amount : int = 0
@export_group("Nodes")
@export var gear_label : Label
@export var shop : Popup

# Modifiers
var straight : int = 0
var kick : int = 0
var upper : int = 0
var hold : int = 0

# Cost
var straight_cost : int = 1
var kick_cost : int = 10
var upper_cost : int = 100
var hold_cost : int = 2500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _on_texture_button_pressed() -> void:
	gear_coin_count()
	gear_coins += gear_amount
	gear_label.text = "Gear Coins: " + str(gear_coins)
	
func gear_coin_count():
	gear_amount = 1
	if straight > 0:
		gear_amount += straight
	if kick > 0:
		gear_amount += kick * 2
	if upper > 0:
		gear_amount += upper * 5
	if hold > 0:
		gear_amount += hold * 20

func _on_button_pressed() -> void:
	shop.popup()
