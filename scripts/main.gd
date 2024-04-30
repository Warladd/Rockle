extends Node2D
@export var gear_coins : int = 0
var gear_amount : int = 1
@export_group("Nodes")
@export var gear_label : Label
@export var shop : Popup
@export var shop_button : Button
@export var straight_label : Label
@export var kick_label : Label
@export var uppercut_label : Label
@export var hold_label : Label

# Modifiers
var straight : int = 0
var kick : int = 0
var upper : int = 0
var hold : int = 0

# Cost
var straight_cost : int = 5
var kick_cost : int = 100
var upper_cost : int = 1000
var hold_cost : int = 25000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gear_amount = 1
	if straight > 0:
		gear_amount += straight
	if kick > 0:
		gear_amount += kick * 2
	if upper > 0:
		gear_amount += upper * 5
	if hold > 0:
		gear_amount += hold * 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _on_texture_button_pressed() -> void:
	gear_coins += gear_amount
	gear_label.text = "Gear Coins: " + str(gear_coins)

func _on_button_pressed() -> void:
	shop.show()

func _on_straight_button_pressed():
	if gear_coins >= straight_cost:
		gear_coins -= straight_cost
		straight_cost *= 2
		straight_cost = roundi(straight_cost)
		straight_label.text = str(straight_cost) + " " + "Coins"
		gear_amount += 1
		straight += 1
		gear_label.text = "Gear Coins: " + str(gear_coins)

func _on_kick_button_pressed():
	if gear_coins >= kick_cost:
		gear_coins -= kick_cost
		kick_cost *= 2.5
		kick_cost = roundi(kick_cost)
		kick_label.text = str(kick_cost) + " " + "Coins"
		gear_amount += 5
		kick += 1
		gear_label.text = "Gear Coins: " + str(gear_coins)

func _on_uppercut_button_pressed():
	if gear_coins >= upper_cost:
		gear_coins -= upper_cost
		upper_cost *= 2
		upper_cost = roundi(upper_cost)
		uppercut_label.text = str(upper_cost) + " " + "Coins"
		gear_amount += 50
		upper += 1
		gear_label.text = "Gear Coins: " + str(gear_coins)

func _on_hold_button_pressed():
	if gear_coins >= hold_cost:
		gear_coins -= hold_cost
		hold_cost *= 1.5
		hold_cost = roundi(hold_cost)
		hold_label.text = str(hold_cost) + " " + "Coins"
		gear_amount += 1200
		hold += 1
		gear_label.text = "Gear Coins: " + str(gear_coins)

func _on_exit_shop_button_pressed():
	shop.visible = false
