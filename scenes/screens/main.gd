extends Node2D
var gear_coins : int = 0
@export_group("Nodes")
@export var gear_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_texture_button_pressed():
	gear_coins += 1
	gear_label.text = "Gear Coins: " + str(gear_coins)
#oog
