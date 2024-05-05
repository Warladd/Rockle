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
@export var saving_label : Label
@export var save_timer : Timer
@export var pause_menu : CanvasLayer

# Disk
@export var disk_timer : Timer
@export var disk_label : Label
@export var disk_name_label : Label
@export var disk_sprite : Sprite2D
var disk_ready : bool = false
var disk_loading : bool = false
var disk_loaded : bool = false
var disk_tween : Tween 
var disk_time = 0.1

# Pillar
@export var pillar_timer : Timer
@export var pillar_label : Label
@export var pillar_name_label : Label
@export var pillar_sprite : Sprite2D
var pillar_ready : bool = false
var pillar_loading : bool = false
var pillar_loaded : bool = false
var pillar_tween : Tween
var pillar_time = 5

# Boulder
var boulder_time = 30
var boulder_ready : bool = false
var boulder_loading : bool = false
var boulder_loaded : bool = false
var wall_time = 90
var wall_ready : bool = false
var wall_loading : bool = false
var wall_loaded : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_sprite.play("default")
	SaveSystem.load_game()
	shop.hide()
	disk_timer.start()
	pause_menu.hide()
	if SaveSystem.save_game.pillar > 0:
		pillar_timer.start()
	disk_label.text = str(SaveSystem.save_game.disk_cost) + " " + "Coins"
	disk_name_label.text = " Disk" + " (" + str(SaveSystem.save_game.disk) + ")"
	pillar_label.text = str(SaveSystem.save_game.pillar_cost) + " " + "Coins"
	pillar_name_label.text = " Pillar" + " (" + str(SaveSystem.save_game.pillar) + ")"
	boulder_label.text = str(SaveSystem.save_game.boulder_cost) + " " + "Coins"
	wall_label.text = str(SaveSystem.save_game.wall_cost) + " " + "Coins"
	disk_tween = create_tween()
	disk_tween.tween_property(disk_sprite, "position", Vector2(464, 313), 0.1)
	save_timer.start()
	#if SaveSystem.save_game.kick:
		#kick_label.hide()
	#if SaveSystem.save_game.uppercut:
		#uppercut_label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if !pillar_loaded and !boulder_loaded and !wall_loaded and !disk_loaded and !pillar_loading and !disk_loading and !wall_loading and !boulder_loading:
		if pillar_ready:
			print("pillar started")
			pillar_ready = false
			pillar_tween = create_tween()
			pillar_tween.tween_property(pillar_sprite, "position", Vector2(428, 320), 0.3)
			pillar_loading = true
			await pillar_tween.finished
			pillar_loaded = true
			pillar_loading = false
			print("pillar loaded")
		elif disk_ready:
			disk_ready = false
			disk_tween = create_tween()
			disk_tween.tween_property(disk_sprite, "position", Vector2(440, 313), 0.1)
			disk_loading = true
			await disk_tween.finished
			disk_loaded = true
			disk_loading = false
			print("disk loaded")

func _input(event) -> void:
	if event.is_action_pressed("l_click"):
		if pillar_loaded:
			print("pillar hit")
			pillar_loaded = false
			pillar_timer.start()
			pillar_tween = create_tween()
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.pillar * 2
			gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			player_sprite.play("straight")
			pillar_tween.tween_property(pillar_sprite, "position", Vector2(686, 320), 0.4)
			await pillar_tween.finished
			player_sprite.play("default")
			pillar_sprite.position = Vector2(428, 455)
			
		elif disk_loaded:
			print("disk hit")
			disk_loaded = false
			disk_timer.start()
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk
			gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			player_sprite.play("straight")
			disk_tween = create_tween()
			disk_tween.tween_property(disk_sprite, "position", Vector2(800, 313), 0.1)
			await disk_tween.finished
			disk_sprite.position = Vector2(430, 413)

func _on_button_pressed() -> void:
	shop.show()
	shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
	shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)

func _on_disk_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.disk_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.disk_cost
		SaveSystem.save_game.disk_cost = (SaveSystem.save_game.disk_cost + 5) * 1.2
		SaveSystem.save_game.disk_cost = roundi(SaveSystem.save_game.disk_cost)
		disk_label.text = str(SaveSystem.save_game.disk_cost) + " " + "Coins"
		SaveSystem.save_game.disk += 1
		disk_name_label.text = " Disk" + " (" + str(SaveSystem.save_game.disk) + ")"
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_pillar_button_pressed():
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.pillar_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.pillar_cost
		SaveSystem.save_game.pillar_cost = (SaveSystem.save_game.pillar_cost + 20) * 1.15
		SaveSystem.save_game.pillar += 1
		pillar_name_label.text = " Pillar" + " (" + str(SaveSystem.save_game.pillar) + ")"
		if SaveSystem.save_game.pillar == 1:
			pillar_timer.start()
		SaveSystem.save_game.pillar_cost = roundi(SaveSystem.save_game.pillar_cost)
		pillar_label.text = str(SaveSystem.save_game.pillar_cost) + " " + "Coins"
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_boulder_button_pressed() -> void:
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
		print("saving")

func _on_wall_button_pressed() -> void:
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
		print("saving")

func _on_exit_shop_button_pressed():
	shop.visible = false

func _on_save_timer_timeout():
	SaveSystem.saving()
	print("saving")

func _on_disk_timer_timeout():
	print("disk timer finished")
	disk_ready = true
	player_sprite.play("default")

func _on_pillar_timer_timeout():
	print("pillar timer finished")
	pillar_ready = true
