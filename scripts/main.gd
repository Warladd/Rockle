extends Node2D
@export_group("Nodes")
@export var gear_label : Label
@export var shop_label_1 : Label
@export var shop_label_2 : Label
@export var shop : CanvasLayer
@export var shop_button : Button
@export var boulder_label : Label
@export var wall_label : Label
@export var player_sprite : AnimatedSprite2D

# Disk
@export var disk_timer : Timer
@export var disk_label : Label
@export var disk_sprite : Sprite2D
var disk_ready : bool = true
var disk_tween : Tween 
var disk_time = 0.1

# Pillar
@export var pillar_sprite : Sprite2D
@export var pillar_label : Label
var pillar_tween : Tween 
var pillar_ready : bool = true
var pillar_time = 5

# Boulder
var boulder_time = 30
var boulder_ready : bool = true
var wall_time = 90
var wall_ready : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_sprite.play("default")
	shop.hide()
	SaveSystem.load_game()
	disk_label.text = str(SaveSystem.save_game.disk_cost) + " " + "Coins"
	pillar_label.text = str(SaveSystem.save_game.pillar_cost) + " " + "Coins"
	boulder_label.text = str(SaveSystem.save_game.boulder_cost) + " " + "Coins"
	wall_label.text = str(SaveSystem.save_game.wall_cost) + " " + "Coins"
	disk_tween = create_tween()
	disk_tween.tween_property(disk_sprite, "position", Vector2(464, 313), 0.1)
	#if SaveSystem.save_game.kick:
		#kick_label.hide()
	#if SaveSystem.save_game.uppercut:
		#uppercut_label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if !disk_ready and pillar_ready:
		pillar_tween = create_tween()
		pillar_tween.tween_property(pillar_sprite, "position", Vector2(428, 313), 0.5)
		await pillar_tween.finished

func _input(event) -> void:
	if event.is_action_pressed("l_click"):
		if disk_ready:
			disk_ready = false
			disk_timer.start()
			disk_tween = create_tween()
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk
			gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			player_sprite.play("straight")
			disk_tween.tween_property(disk_sprite, "position", Vector2(800, 313), 0.1)
	if event.is_action_pressed("esc"):
		SaveSystem.saving()
		get_tree().quit(0)

func _on_button_pressed() -> void:
	shop.show()
	shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
	shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)

func _on_straight_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.disk_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.disk_cost
		SaveSystem.save_game.disk_cost = (SaveSystem.save_game.disk_cost + 5) * 1.2
		SaveSystem.save_game.disk_cost = roundi(SaveSystem.save_game.disk_cost)
		disk_label.text = str(SaveSystem.save_game.disk_cost) + " " + "Coins"
		SaveSystem.save_game.disk += 1
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()

func _on_kick_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.pillar_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.pillar_cost
		SaveSystem.save_game.pillar_cost *= 2.5
		SaveSystem.save_game.pillar += 1
		SaveSystem.save_game.pillar_cost = roundi(SaveSystem.save_game.pillar_cost)
		pillar_label.text = str(SaveSystem.save_game.pillar_cost) + " " + "Coins"
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()

func _on_uppercut_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.boulder_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.boulder_cost
		SaveSystem.save_game.boulder_cost *= 2
		SaveSystem.save_game.boulder += 1
		SaveSystem.save_game.boulder_cost = roundi(SaveSystem.save_game.boulder_cost)
		boulder_label.text = str(SaveSystem.save_game.boulder_cost) + " " + "Coins"
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()

func _on_hold_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.wall_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.wall_cost
		SaveSystem.save_game.wall_cost *= 1.5
		SaveSystem.save_game.wall += 1
		SaveSystem.save_game.wall_cost = roundi(SaveSystem.save_game.wall_cost)
		wall_label.text = str(SaveSystem.save_game.wall_cost) + " " + "Coins"
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()

func _on_exit_shop_button_pressed():
	shop.visible = false

func _on_save_timer_timeout():
	SaveSystem.saving()

func _on_disk_timer_timeout():
	player_sprite.play("default")
	disk_ready = true
	disk_sprite.position = Vector2(430, 413)
	if 
	disk_tween = create_tween()
	disk_tween.tween_property(disk_sprite, "position", Vector2(440, 313), 0.1)
	await disk_tween.finished
