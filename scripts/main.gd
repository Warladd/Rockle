extends Node2D
var constant_gears : int = 0
@export_group("Nodes")
@export var gear_label : Label
@export var shop_label_1 : Label
@export var shop_label_2 : Label
@export var shop : CanvasLayer
@export var shop_button : Button
@export var straight_label : Label
@export var kick_label : Label
@export var uppercut_label : Label
@export var hold_label : Label
@export var click_button : TextureButton
@export var disk_button : Button
@export var pillar_button : Button
@export var pillar_label : Label
@export var boulder_button : Button
@export var boulder_label : Label
@export var wall_button : Button
@export var wall_label : Label
@export var particle_timer : Timer

var particle_sprite = preload("res://scenes/particle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop.hide()
	SaveSystem.load_game()
	straight_label.text = str(SaveSystem.save_game.straight_cost) + " " + "Coins"
	kick_label.text = str(SaveSystem.save_game.kick_cost) + " " + "Coins"
	uppercut_label.text = str(SaveSystem.save_game.upper_cost) + " " + "Coins"
	hold_label.text = str(SaveSystem.save_game.hold_cost) + " " + "Coins"
	if SaveSystem.save_game.pillar:
		pillar_label.hide()
	if SaveSystem.save_game.boulder:
		boulder_label.hide()
	if SaveSystem.save_game.wall:
		wall_label.hide()
	if SaveSystem.save_game.structure == "disk":
		click_button.texture_normal = load("res://assets/structures/normal/disk.png")
		click_button.texture_hover = load("res://assets/structures/hover/disk_bigger.png")
		click_button.texture_pressed = load("res://assets/structures/click/disk_click.png")
		constant_gears = 0
	elif SaveSystem.save_game.structure == "pillar":
		click_button.texture_normal = load("res://assets/structures/normal/pillar.png")
		click_button.texture_hover = load("res://assets/structures/hover/pillar_bigger.png")
		click_button.texture_pressed = load("res://assets/structures/click/pillar_click.png")
		constant_gears = 1
	elif SaveSystem.save_game.structure == "boulder":
		click_button.texture_normal = load("res://assets/structures/normal/boulder.png")
		click_button.texture_hover = load("res://assets/structures/hover/boulder_bigger.png")
		click_button.texture_pressed = load("res://assets/structures/click/boulder_click.png")
		constant_gears = 5
	elif SaveSystem.save_game.structure == "wall":
		click_button.texture_normal = load("res://assets/structures/normal/wall.png")
		click_button.texture_hover = load("res://assets/structures/hover/wall_bigger.png")
		click_button.texture_pressed = load("res://assets/structures/click/wall_click.png")
		constant_gears = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if SaveSystem.save_game.structure == "disk":
		disk_button.text = "Equipped"
		disk_button.add_theme_color_override("Font Color", Color("2e2e2e"))
		if SaveSystem.save_game.pillar:
			pillar_button.text = "Use"
		if SaveSystem.save_game.boulder:
			boulder_button.text = "Use"
		if SaveSystem.save_game.wall:
			wall_button.text = "Use"
	elif SaveSystem.save_game.structure == "pillar":
		pillar_button.text = "Equipped"
		pillar_button.add_theme_color_override("Font Color", Color("2e2e2e"))
		disk_button.text = "Use"
		if SaveSystem.save_game.boulder:
			boulder_button.text = "Use"
		if SaveSystem.save_game.wall:
			wall_button.text = "Use"
	elif SaveSystem.save_game.structure == "boulder":
		boulder_button.text = "Equipped"
		boulder_button.add_theme_color_override("Font Color", Color("2e2e2e"))
		if SaveSystem.save_game.pillar:
			pillar_button.text = "Use"
		disk_button.text = "Use"
		if SaveSystem.save_game.wall:
			wall_button.text = "Use"
	elif SaveSystem.save_game.structure == "wall":
		wall_button.text = "Equipped"
		wall_button.add_theme_color_override("Font Color", Color("2e2e2e"))
		if SaveSystem.save_game.pillar:
			pillar_button.text = "Use"
		if SaveSystem.save_game.boulder:
			boulder_button.text = "Use"
		disk_button.text = "Use"

func _input(event) -> void:
	if event.is_action_pressed("esc"):
		get_tree().quit(0)

func _on_texture_button_pressed() -> void:
	SaveSystem.save_game.gear_coins += SaveSystem.save_game.gear_amount
	gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
	var particle = randi_range(1, 4)
	particle_sprite.texture = load("res://assets/sparks/spark%d.png" % particle)
	particle_sprite.position = Vector2(randi_range(431, 700), randi_range(156, 405))
	particle_sprite.show()
	particle_timer.start()
	# var ghost: Sprite2D = ghost_scene.instantiate()
	# get_parent().add_child(ghost)
	# ghost.global_position = sprite.global_position
	# ghost.flip_h = sprite.flip_h
	# ghost.texture = ghost_jump_texture
	# ghost.modulate = Color(0.067, 0.4, 0.671)

func _on_button_pressed() -> void:
	shop.show()
	shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
	shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)

func _on_straight_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.straight_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.straight_cost
		SaveSystem.save_game.straight_cost *= 2
		SaveSystem.save_game.straight_cost = roundi(SaveSystem.save_game.straight_cost)
		straight_label.text = str(SaveSystem.save_game.straight_cost) + " " + "Coins"
		SaveSystem.save_game.gear_amount += 1
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()

func _on_kick_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.kick_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.kick_cost
		SaveSystem.save_game.kick_cost *= 2.5
		SaveSystem.save_game.kick_cost = roundi(SaveSystem.save_game.kick_cost)
		kick_label.text = str(SaveSystem.save_game.kick_cost) + " " + "Coins"
		SaveSystem.save_game.gear_amount += 5
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()

func _on_uppercut_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.upper_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.upper_cost
		SaveSystem.save_game.upper_cost *= 2
		SaveSystem.save_game.upper_cost = roundi(SaveSystem.save_game.upper_cost)
		uppercut_label.text = str(SaveSystem.save_game.upper_cost) + " " + "Coins"
		SaveSystem.save_game.gear_amount += 50
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()

func _on_hold_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.hold_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.hold_cost
		SaveSystem.save_game.hold_cost *= 1.5
		SaveSystem.save_game.hold_cost = roundi(SaveSystem.save_game.hold_cost)
		hold_label.text = str(SaveSystem.save_game.hold_cost) + " " + "Coins"
		SaveSystem.save_game.gear_amount += 1200
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()

func _on_exit_shop_button_pressed():
	shop.visible = false

func _on_pillart_button_pressed():
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.pillar_cost or SaveSystem.save_game.pillar:
		if !SaveSystem.save_game.pillar:
			SaveSystem.save_game.gear_coins -= SaveSystem.save_game.pillar_cost
			SaveSystem.save_game.pillar = true
			shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			pillar_label.hide()
		click_button.texture_normal = load("res://assets/structures/normal/pillar.png")
		click_button.texture_hover = load("res://assets/structures/hover/pillar_bigger.png")
		click_button.texture_pressed = load("res://assets/structures/click/pillar_click.png")
		constant_gears = 1
		SaveSystem.save_game.structure = "pillar"
		SaveSystem.saving()

func _on_boulder_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.boulder_cost or SaveSystem.save_game.boulder:
		if !SaveSystem.save_game.boulder:
			SaveSystem.save_game.gear_coins -= SaveSystem.save_game.boulder_cost
			SaveSystem.save_game.boulder = true
			shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			boulder_label.hide()
		click_button.texture_normal = load("res://assets/structures/normal/boulder.png")
		click_button.texture_hover = load("res://assets/structures/hover/boulder_bigger.png")
		click_button.texture_pressed = load("res://assets/structures/click/boulder_click.png")
		constant_gears = 5
		SaveSystem.save_game.structure = "boulder"
		SaveSystem.saving()

func _on_wall_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.wall_cost or SaveSystem.save_game.wall:
		if !SaveSystem.save_game.wall:
			SaveSystem.save_game.gear_coins -= SaveSystem.save_game.wall_cost
			SaveSystem.save_game.wall = true
			shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			wall_label.hide()
			SaveSystem.saving()
		click_button.texture_normal = load("res://assets/structures/normal/wall.png")
		click_button.texture_hover = load("res://assets/structures/hover/wall_bigger.png")
		click_button.texture_pressed = load("res://assets/structures/click/wall_click.png")
		constant_gears = 100
		SaveSystem.save_game.structure = "wall"
		SaveSystem.saving()

func _on_diskartonline_button_pressed() -> void:
	click_button.texture_normal = load("res://assets/structures/normal/disk.png")
	click_button.texture_hover = load("res://assets/structures/hover/disk_bigger.png")
	click_button.texture_pressed = load("res://assets/structures/click/disk_click.png")
	constant_gears = 0
	SaveSystem.save_game.structure = "disk"

func _on_structure_timer_timeout():
	SaveSystem.save_game.gear_coins += constant_gears
	gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
	shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
	shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)

func _on_save_timer_timeout():
	SaveSystem.saving()

func _on_particle_timer_timeout():
	particle_sprite.hide()
