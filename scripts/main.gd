extends Node2D
# Disk
@export_group("Disk Nodes")
@export var disk_timer : Timer
@export var disk_label : Label
@export var disk_name_label : Label
@export var disk_sprite : Sprite2D
var disk_ready : bool = false
var disk_loading : bool = false
var disk_loaded : bool = false
var disk_tween : Tween 

# Pillar
@export_group("Pillar Nodes")
@export var pillar_timer : Timer
@export var pillar_label : Label
@export var pillar_name_label : Label
@export var pillar_sprite : Sprite2D
var pillar_ready : bool = false
var pillar_loading : bool = false
var pillar_loaded : bool = false
var pillar_tween : Tween

# Ball
@export_group("Ball Nodes")
@export var ball_timer : Timer
@export var ball_label : Label
@export var ball_name_label : Label
@export var ball_sprite : Sprite2D
var ball_ready : bool = false
var ball_loading : bool = false
var ball_loaded : bool = false
var ball_tween : Tween

# Cube
@export_group("Cube Nodes")
@export var cube_timer : Timer
@export var cube_label : Label
@export var cube_name_label : Label
@export var cube_sprite : Sprite2D
var cube_ready : bool = false
var cube_loading : bool = false
var cube_loaded : bool = false
var cube_tween : Tween

# Wall
@export_group("Wall Nodes")
@export var wall_timer : Timer
@export var wall_label : Label
@export var wall_name_label : Label
@export var wall_sprite : Sprite2D
var wall_ready : bool = false
var wall_loading : bool = false
var wall_loaded : bool = false
var wall_tween : Tween

@export_group("Misc")
@export var gear_label : Label
@export var shop_label_1 : Label
@export var shop_label_2 : Label
@export var shop : CanvasLayer
@export var shop_button : Button
@export var player_sprite : AnimatedSprite2D
@export var saving_label : Label
@export var save_timer : Timer
@export var pause_menu : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_sprite.play("default")
	SaveSystem.load_game()
	shop.hide()
	disk_timer.start()
	pause_menu.hide()
	gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
	shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
	shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
	
	# Disk
	disk_label.text = str(SaveSystem.save_game.disk_cost) + " " + "Coins"
	disk_name_label.text = " Disk" + " (" + str(SaveSystem.save_game.disk) + ")"
	
	# Pillar
	pillar_label.text = str(SaveSystem.save_game.pillar_cost) + " " + "Coins"
	pillar_name_label.text = " Pillar" + " (" + str(SaveSystem.save_game.pillar) + ")"
	if SaveSystem.save_game.pillar > 0:
		pillar_timer.start()
		
	# ball
	ball_label.text = str(SaveSystem.save_game.ball_cost) + " " + "Coins"
	ball_name_label.text = " Ball" + " (" + str(SaveSystem.save_game.ball) + ")"
	if SaveSystem.save_game.ball > 0:
		ball_timer.start()
		
	# Cube
	cube_label.text = str(SaveSystem.save_game.cube_cost) + " " + "Coins"
	cube_name_label.text = " Cube" + " (" + str(SaveSystem.save_game.cube) + ")"
	if SaveSystem.save_game.cube > 0:
		cube_timer.start()
		
	# Wall
	wall_label.text = str(SaveSystem.save_game.wall_cost) + " " + "Coins"
	wall_name_label.text = " Wall" + " (" + str(SaveSystem.save_game.wall) + ")"
	if SaveSystem.save_game.wall > 0:
		wall_timer.start()
		
	save_timer.start()
	#if SaveSystem.save_game.kick:
		#kick_label.hide()
	#if SaveSystem.save_game.uppercut:
		#uppercut_label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if !disk_loaded and !pillar_loaded and !ball_loaded and !cube_loaded and !wall_loaded and !disk_loading and !pillar_loading and !ball_loading and !cube_loading and !wall_loading:
		if wall_ready:
			print("wall started")
			wall_ready = false
			wall_tween = create_tween()
			wall_tween.tween_property(wall_sprite, "position", Vector2(428, 318), 0.2)
			wall_loading = true
			await wall_tween.finished
			wall_loaded = true
			wall_loading = false
			print("wall loaded")
		elif cube_ready:
			print("cube started")
			cube_ready = false
			cube_tween = create_tween()
			cube_tween.tween_property(cube_sprite, "position", Vector2(444, 332), 0.2)
			cube_loading = true
			await cube_tween.finished
			cube_loaded = true
			cube_loading = false
			print("cube loaded")
		elif ball_ready:
			print("ball started")
			ball_ready = false
			ball_tween = create_tween()
			ball_tween.tween_property(ball_sprite, "position", Vector2(434, 294), 0.2)
			ball_loading = true
			await ball_tween.finished
			ball_loaded = true
			ball_loading = false
			print("ball loaded")
		elif pillar_ready:
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
		if wall_loaded:
			print("wall hit")
			wall_loaded = false
			wall_timer.start()
			wall_tween = create_tween()
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.wall * 150000
			gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			player_sprite.play("straight")
			wall_tween.tween_property(wall_sprite, "position", Vector2(695, 318), 0.4)
			await wall_tween.finished
			player_sprite.play("default")
			wall_sprite.position = Vector2(428, 443)
			
		elif cube_loaded:
			print("cube hit")
			cube_loaded = false
			cube_timer.start()
			cube_tween = create_tween()
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.cube * 500
			gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			player_sprite.play("straight")
			cube_tween.tween_property(cube_sprite, "position", Vector2(695, 332), 0.5)
			await cube_tween.finished
			player_sprite.play("default")
			cube_sprite.position = Vector2(444, 431)
			
		elif ball_loaded:
			print("ball hit")
			ball_loaded = false
			ball_timer.start()
			ball_tween = create_tween()
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.ball * 100
			gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			player_sprite.play("straight")
			ball_tween.tween_property(ball_sprite, "position", Vector2(695, 294), 0.3)
			await ball_tween.finished
			player_sprite.play("default")
			ball_sprite.position = Vector2(434, 414)
		
		elif pillar_loaded:
			print("pillar hit")
			pillar_loaded = false
			pillar_timer.start()
			pillar_tween = create_tween()
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.pillar * 3
			gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
			player_sprite.play("straight")
			pillar_tween.tween_property(pillar_sprite, "position", Vector2(695, 320), 0.4)
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
			disk_tween.tween_property(disk_sprite, "position", Vector2(695, 313), 0.1)
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

func _on_ball_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.ball_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.ball_cost
		SaveSystem.save_game.ball_cost = (SaveSystem.save_game.ball_cost + 100) * 1.3
		SaveSystem.save_game.ball += 1
		ball_name_label.text = " Ball" + " (" + str(SaveSystem.save_game.ball) + ")"
		SaveSystem.save_game.ball_cost = roundi(SaveSystem.save_game.ball_cost)
		ball_label.text = str(SaveSystem.save_game.ball_cost) + " " + "Coins"
		gear_label.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_1.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		shop_label_2.text = "Gear Coins: " + str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_cube_button_pressed():
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.cube_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.cube_cost
		SaveSystem.save_game.cube_cost = (SaveSystem.save_game.cube_cost + 1000) * 1.5
		SaveSystem.save_game.cube += 1
		cube_name_label.text = " Cube" + " (" + str(SaveSystem.save_game.cube) + ")"
		SaveSystem.save_game.cube_cost = roundi(SaveSystem.save_game.cube_cost)
		cube_label.text = str(SaveSystem.save_game.cube_cost) + " " + "Coins"
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
		wall_name_label.text = " Wall" + " (" + str(SaveSystem.save_game.wall) + ")"
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
	disk_ready = true
	player_sprite.play("default")

func _on_pillar_timer_timeout():
	pillar_ready = true

func _on_ball_timer_timeout():
	print("ball timer finished")
	ball_ready = true

func _on_cube_timer_timeout():
	print("cube timer finished")
	cube_ready = true

func _on_wall_timer_timeout():
	print("wall timer finished")
	wall_ready = true
