extends Node2D
# Disk
@export_group("Disk Nodes")
@export var disk_timer : Timer
@export var disk_label : Label
@export var disk_name_label : Label
@export var disk_sprite : Sprite2D
@export var disk_container : HBoxContainer
@export var disk_bar : ProgressBar
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
@export var pillar_container : HBoxContainer
@export var pillar_bar : ProgressBar
var pillar_ready : bool = false
var pillar_loading : bool = false
var pillar_loaded : bool = false
var pillar_tween : Tween

# Ball
@export_group("Ball Nodes")
@export var ball_timer : Timer
@export var ball_label : Label
@export var ball_gear : TextureRect
@export var ball_name_label : Label
@export var ball_sprite : Sprite2D
@export var ball_container : HBoxContainer
@export var ball_bar : ProgressBar
@export var ball_button : Button
var ball_ready : bool = false
var ball_loading : bool = false
var ball_loaded : bool = false
var ball_tween : Tween

# Cube
@export_group("Cube Nodes")
@export var cube_timer : Timer
@export var cube_label : Label
@export var cube_gear : TextureRect
@export var cube_name_label : Label
@export var cube_sprite : Sprite2D
@export var cube_container : HBoxContainer
@export var cube_bar : ProgressBar
@export var cube_button : Button
var cube_ready : bool = false
var cube_loading : bool = false
var cube_loaded : bool = false
var cube_tween : Tween

# Wall
@export_group("Wall Nodes")
@export var wall_timer : Timer
@export var wall_label : Label
@export var wall_gear : TextureRect
@export var wall_name_label : Label
@export var wall_sprite : Sprite2D
@export var wall_container : HBoxContainer
@export var wall_bar : ProgressBar
@export var wall_button : Button
var wall_ready : bool = false
var wall_loading : bool = false
var wall_loaded : bool = false
var wall_tween : Tween

# Modifiers
@export_group("Modifier Nodes")
@export var kick_button : Button
@export var kick_label : Label
@export var kick_gear : TextureRect
@export var stomp_button : Button
@export var stomp_label : Label
@export var stomp_gear : TextureRect
@export var uppercut_button : Button
@export var uppercut_label : Label
@export var uppercut_gear : TextureRect
@export var parry_button : Button
@export var parry_label : Label
@export var parry_gear : TextureRect
@export var hold_button : Button
@export var hold_label : Label
@export var hold_gear : TextureRect
@export var explode_button : Button
@export var explode_label : Label
@export var explode_gear : TextureRect
var straighting : bool = false

# Combos Combo Site: https://docs.google.com/spreadsheets/d/1zRu2wWWSNwFwwg9O0M-dsk9ASbUwgPAdSt8UNESvni4/edit#gid=6435056

# Masteries
@export_group("Mastery Nodes")
@export var straight_m_button : Button
@export var straight_m_label : Label
@export var straight_m_gear : TextureRect
@export var white_belt_label : Label
@export var white_belt_button : Button
@export var white_belt_gear : TextureRect
@export var yellow_belt_label : Label
@export var yellow_belt_button : Button
@export var yellow_belt_container : HBoxContainer
@export var yellow_belt_gear : TextureRect
@export var green_belt_label : Label
@export var green_belt_button : Button
@export var green_belt_container : HBoxContainer
@export var green_belt_gear : TextureRect
@export var blue_belt_label : Label
@export var blue_belt_button : Button
@export var blue_belt_container : HBoxContainer
@export var blue_belt_gear : TextureRect
@export var red_belt_label : Label
@export var red_belt_button : Button
@export var red_belt_container : HBoxContainer
@export var red_belt_gear : TextureRect
@export var black_belt_label : Label
@export var black_belt_button : Button
@export var black_belt_container : HBoxContainer
@export var black_belt_gear : TextureRect

@export_group("Misc")
@export var gear_label : Label
@export var shop_label : Label
@export var shop : CanvasLayer
@export var shop_button : Button
@export var player_sprite : AnimatedSprite2D
@export var saving_label : Label
@export var save_timer : Timer
@export var pause_menu : CanvasLayer
@export var hitbox : CollisionShape2D
@export var settings : CanvasLayer

# Costs
var kick_cost : int = 5000
var uppercut_cost : int = 20000
var stomp_cost : int = 1000
var parry_cost : int = 2000000
var hold_cost : int = 5000000
var explode_cost : int = 40000000
var straight_m_cost : int = 500

var white_belt_cost : int = 1000
var yellow_belt_cost : int = 15000
var green_belt_cost : int = 100000
var blue_belt_cost : int = 1000000
var red_belt_cost : int = 15000000
var black_belt_cost : int = 550000000

# Normally SaveSystem stuff
@export var gear_coins : int = 0
@export var belt = 0
@export var tutorial : bool = true
@export var safe_opened : bool = false

# Structures
@export var disk : int = 1
@export var pillar : int = 0
@export var ball : int = 0
@export var cube : int = 0
@export var wall : int = 0

@export var disk_increase : int = 1
@export var pillar_increase : int = 10
@export var ball_increase : int = 200
@export var cube_increase : int = 10000
@export var wall_increase : int = 5000
@export var general_increase : int = 1

# Modifiers
@export var straight : bool = true
@export var kick : bool = false
@export var uppercut : bool = false
@export var stomp : bool = false
@export var parry : bool = false
@export var hold : bool = false
@export var explode : bool = false

# Masteries
@export var straight_mastery : bool = false
@export var straight_active : bool = false
# Black Belt
@export var black_belt_mastery : bool = false

# Cost
@export var disk_cost : int = 50
@export var pillar_cost : int = 150
@export var ball_cost : int = 1000
@export var wall_cost : int = 20000
@export var cube_cost : int = 150000

# Popup
var popup_label = preload("res://scenes/popup_label.tscn")
@export var popup_container : VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings.hide()
	player_sprite.play("default")
	shop.hide()
	pause_menu.hide()
	Global.popup.connect(popup)
	var gear_coin_string = str(gear_coins)
	for i in range(int((len(gear_coin_string) - 1) /3)):
		gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
	gear_label.text = gear_coin_string
	shop_label.text = gear_coin_string
	
	# Disk
	gear_coin_string = str(disk_cost)
	for i in range(int((len(gear_coin_string) - 1) /3)):
		gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
	disk_label.text = gear_coin_string
	
	# Pillar
	gear_coin_string = str(pillar_cost)
	for i in range(int((len(gear_coin_string) - 1) /3)):
		gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
	pillar_label.text = gear_coin_string
		
	# Ball
	if belt < 1:
		ball_label.hide()
		ball_gear.hide()
		ball_name_label.text = " Ball"
		ball_button.disabled = true
		ball_button.text = "Locked"
	elif belt >= 1:
		gear_coin_string = str(ball_cost)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		ball_label.text = gear_coin_string
		
	# Cube
	if belt < 3:
		cube_label.hide()
		cube_gear.hide()
		cube_name_label.text = " Cube"
		cube_button.disabled = true
		cube_button.text = "Locked"
	elif belt >= 2:
		gear_coin_string = str(cube_cost)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		cube_label.text = gear_coin_string
		cube_name_label.text = " Cube" + " (" + str(cube) + ")"
		
	# Wall
	if belt < 2:
		wall_label.hide()
		wall_gear.hide()
		wall_name_label.text = " Wall"
		wall_button.disabled = true
		wall_button.text = "Locked"
	elif belt >= 2:
		wall_button.disabled = false
		gear_coin_string = str(wall_cost)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		wall_label.text = gear_coin_string
		wall_name_label.text = " Wall" + " (" + str(wall) + ")"
	
	# Modifiers
	if kick:
		kick_button.text = "Owned"
		kick_label.hide()
		kick_gear.hide()
	
	if stomp:
		stomp_button.text = "Owned"
		stomp_label.hide()
		stomp_gear.hide()
	
	if uppercut:
		uppercut_button.text = "Owned"
		uppercut_label.hide()
		uppercut_gear.hide()
	
	# Belt Stuff
	if belt == 6:
		black_belt_button.text = "Owned"
		black_belt_button.disabled = true
		black_belt_label.hide()
		black_belt_gear.hide()
	if belt >= 5:
		red_belt_button.text = "Owned"
		red_belt_button.disabled = true
		player_sprite.sprite_frames = load("res://resources/black_belt.tres")
		if !explode:
			explode_button.disabled = false
			explode_button.text = "Buy"
			explode_label.show()
			explode_gear.show()
		if explode:
			explode_button.text = "Owned"
		red_belt_label.hide()
		red_belt_gear.hide()
		black_belt_container.show()
	if belt >= 4:
		blue_belt_button.text = "Owned"
		blue_belt_button.disabled = true
		if !parry:
			parry_button.disabled = false
			parry_button.text = "Buy"
			parry_label.show()
			parry_gear.show()
		if parry:
			parry_button.text = "Owned"
		if !hold:
			hold_button.disabled = false
			hold_button.text = "Buy"
			hold_label.show()
			hold_gear.show()
		if hold:
			hold_button.text = "Owned"
		if belt == 4:
			player_sprite.sprite_frames = load("res://resources/red_belt.tres")
		blue_belt_label.hide()
		blue_belt_gear.hide()
		red_belt_container.show()
	if belt >= 3:
		green_belt_button.text = "Owned"
		green_belt_button.disabled = true
		if belt == 3:
			player_sprite.sprite_frames = load("res://resources/blue_belt.tres")
		green_belt_label.hide()
		green_belt_gear.hide()
		blue_belt_container.show()
	if belt >= 2:
		yellow_belt_button.text = "Owned"
		yellow_belt_button.disabled = true
		if belt == 2:
			player_sprite.sprite_frames = load("res://resources/green_belt.tres")
		yellow_belt_label.hide()
		yellow_belt_gear.hide()
		green_belt_container.show()
	if belt >= 1:
		white_belt_button.text = "Owned"
		white_belt_button.disabled = true
		white_belt_label.hide()
		white_belt_gear.hide()
		white_belt_gear.hide()
		if belt == 1:
			player_sprite.sprite_frames = load("res://resources/yellow_belt.tres")
		yellow_belt_container.show()
			
	if belt < 1:
		kick_button.text = "Locked"
		kick_button.disabled = true
		kick_label.hide()
		kick_gear.hide()
		stomp_button.text = "Locked"
		stomp_button.disabled = true
		stomp_label.hide()
		stomp_gear.hide()
	if belt < 2:
		uppercut_button.text = "Locked"
		uppercut_button.disabled = true
		uppercut_label.hide()
		uppercut_gear.hide()
		
	if straight_mastery:
		straight_m_button.text = "Inactive"
		straight_m_label.hide()
		straight_m_gear.hide()
	if straight_active:
		straight_m_button.text = "Active"
	
	save_timer.start()
	#if kick:
		#kick_label.hide()
	#if uppercut:
		#uppercut_label.hide()

func popup():
	if Global.popup_number != 0:
		var label = popup_label.instantiate()
		popup_container.add_child(label)
		Global.popup_number = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if int(gear_label.text) != gear_coins:
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
	
func _on_button_pressed() -> void:
	shop.show()
	Global.shop = true
	shop_label.text = str(gear_coins)

func _on_disk_button_pressed() -> void:
	if gear_coins >= disk_cost:
		gear_coins -= disk_cost
		disk += 1
		if disk == 9 or disk == 24 or disk == 49 or disk == 74 or disk == 99:
			disk_cost *= 5
		if disk == 10 or disk == 25 or disk == 50 or disk == 75 or disk == 100:
			disk_increase *= 10
		disk_cost = (disk_cost + 5) * 1.2
		disk_cost = roundi(disk_cost)
		disk_name_label.text = " Disk" + " (" + str(disk) + ")"
		var wall_string = str(disk_cost)
		for i in range(int((len(wall_string) - 1) /3)):
			wall_string = wall_string.insert(len(wall_string) - 4 * (i) - 3, ",")
		disk_label.text = wall_string
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		print("saving")

func _on_pillar_button_pressed():
	if gear_coins >= pillar_cost:
		gear_coins -= pillar_cost
		pillar_cost = (pillar_cost + 25) * 1.3
		pillar += 1
		pillar_name_label.text = " Pillar" + " (" + str(pillar) + ")"
		if pillar == 1:
			pillar_container.show()
			pillar_ready = true
			pillar_timer.start()
			pillar_tween = create_tween()
			pillar_tween.tween_property(pillar_bar, "value", 1, 5)
		if pillar == 9 or pillar == 24 or pillar == 49 or pillar == 74 or pillar == 99:
			pillar_cost *= 5
		if pillar == 10 or pillar == 25 or pillar == 50 or pillar == 75 or pillar == 100:
			pillar_increase *= 10
		pillar_cost = roundi(pillar_cost)
		pillar_label.text = str(pillar_cost)
		var wall_string = str(pillar_cost)
		for i in range(int((len(wall_string) - 1) /3)):
			wall_string = wall_string.insert(len(wall_string) - 4 * (i) - 3, ",")
		pillar_label.text = wall_string
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_ball_button_pressed() -> void:
	if gear_coins >= ball_cost:
		gear_coins -= ball_cost
		ball_cost = (ball_cost + 200) * 1.4
		ball += 1
		if ball == 1:
			ball_container.show()
			ball_ready = true
			ball_timer.start()
			ball_tween = create_tween()
			ball_tween.tween_property(ball_bar, "value", 1, 10)
		if ball == 9 or ball == 24 or ball == 49 or ball == 74 or ball == 99:
			ball_cost *= 5
		if ball == 10 or ball == 25 or ball == 50 or ball == 75 or ball == 100:
			ball_increase *= 10
		ball_name_label.text = " Ball" + " (" + str(ball) + ")"
		ball_cost = roundi(ball_cost)
		var wall_string = str(ball_cost)
		for i in range(int((len(wall_string) - 1) /3)):
			wall_string = wall_string.insert(len(wall_string) - 4 * (i) - 3, ",")
		ball_label.text = wall_string
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		
		print("saving")

func _on_cube_button_pressed():
	if gear_coins >= cube_cost:
		gear_coins -= cube_cost
		cube_cost = (cube_cost + 10000) * 1.75
		cube += 1
		if cube == 1:
			cube_container.show()
			cube_ready = true
			cube_timer.start()
			cube_tween = create_tween()
			cube_tween.tween_property(cube_bar, "value", 1, 15)
		if cube == 9 or cube == 24 or cube == 49 or cube == 74 or cube == 99:
			cube_cost *= 5
		if cube == 10 or cube == 25 or cube == 50 or cube == 75 or cube == 100:
			cube_increase *= 10
		cube_name_label.text = " Cube" + " (" + str(cube) + ")"
		cube_cost = roundi(cube_cost)
		var wall_string = str(cube_cost)
		for i in range(int((len(wall_string) - 1) /3)):
			wall_string = wall_string.insert(len(wall_string) - 4 * (i) - 3, ",")
		cube_label.text = wall_string
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_wall_button_pressed() -> void:
	if gear_coins >= wall_cost:
		gear_coins -= wall_cost
		wall_cost = (wall_cost + 1000) * 1.5
		wall += 1
		if wall == 1:
			wall_container.show()
			wall_timer.start()
			wall_tween = create_tween()
			wall_tween.tween_property(wall_bar, "value", 1, 30)
		if wall == 9 or wall == 24 or wall == 49 or wall == 74 or wall == 99:
			wall_cost *= 5
		if wall == 10 or wall == 25 or wall == 50 or wall == 75 or wall == 100:
			wall_increase *= 10
		wall_name_label.text = " Wall" + " (" + str(wall) + ")"
		wall_cost = roundi(wall_cost)
		var wall_string = str(wall_cost)
		for i in range(int((len(wall_string) - 1) /3)):
			wall_string = wall_string.insert(len(wall_string) - 4 * (i) - 3, ",")
		wall_label.text = wall_string
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_exit_shop_button_pressed():
	shop.visible = false
	Global.shop = false

func _on_save_timer_timeout():
	
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

func _on_stomp_button_pressed():
	if stomp:
		return
	if gear_coins >= stomp_cost:
		gear_coins -= stomp_cost
		stomp = true
		stomp_button.text = "Owned"
		stomp_label.hide()
		stomp_gear.hide()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")
	
func _on_kick_button_pressed():
	if kick:
		return
	if gear_coins >= kick_cost:
		gear_coins -= kick_cost
		kick = true
		kick_button.text = "Owned"
		kick_label.hide()
		kick_gear.hide()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_uppercut_button_pressed():
	if uppercut:
		return
	if gear_coins >= uppercut_cost:
		gear_coins -= uppercut_cost
		uppercut = true
		uppercut_button.text = "Owned"
		uppercut_label.hide()
		uppercut_gear.hide()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_explode_button_pressed():
	if explode:
		return
	if gear_coins >= explode_cost:
		gear_coins -= explode_cost
		explode = true
		explode_button.text = "Owned"
		explode_button.disabled = true
		explode_label.hide()
		explode_gear.hide()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_straight_m_button_pressed():
	if straight_active:
		straight_m_button.text = "Inactive"
		straight_active = false
		
		print("saving")
		return
	elif straight_mastery and !straight_active:
		straight_m_button.text = "Active"
		straight_active = true
		
		print("saving")
		return
	if straight_m_cost <= gear_coins:
		gear_coins -= straight_m_cost
		straight_mastery = true
		straight_active = true
		straight_m_button.text = "Active"
		straight_m_label.hide()
		straight_m_gear.hide()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_white_belt_button_pressed():
	if white_belt_cost <= gear_coins:
		gear_coins -= white_belt_cost
		belt = 1
		white_belt_button.text = "Owned"
		white_belt_button.disabled = true
		white_belt_label.hide()
		white_belt_gear.hide()
		yellow_belt_container.show()
		player_sprite.sprite_frames = load("res://resources/yellow_belt.tres")
		ball_button.disabled = false
		ball_button.text = "Buy"
		ball_label.show()
		ball_gear.show()
		kick_button.text = "Buy"
		kick_button.disabled = false
		kick_label.show()
		kick_gear.show()
		stomp_button.text = "Buy"
		stomp_button.disabled = false
		stomp_label.show()
		stomp_gear.show()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_yellow_belt_button_pressed():
	if yellow_belt_cost <= gear_coins:
		gear_coins -= yellow_belt_cost
		belt = 2
		yellow_belt_button.text = "Owned"
		yellow_belt_button.disabled = true
		yellow_belt_label.hide()
		yellow_belt_gear.hide()
		green_belt_container.show()
		player_sprite.sprite_frames = load("res://resources/green_belt.tres")
		wall_button.disabled = false
		wall_button.text = "Buy"
		wall_label.show()
		wall_gear.show()
		uppercut_button.disabled = false
		uppercut_button.text = "Buy"
		uppercut_label.show()
		uppercut_gear.show()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_green_belt_button_pressed():
	if green_belt_cost <= gear_coins:
		gear_coins -= green_belt_cost
		belt = 3
		green_belt_button.text = "Owned"
		green_belt_button.disabled = true
		green_belt_label.hide()
		green_belt_gear.hide()
		blue_belt_container.show()
		player_sprite.sprite_frames = load("res://resources/blue_belt.tres")
		cube_button.disabled = false
		cube_button.text = "Buy"
		cube_label.show()
		cube_gear.show()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_blue_belt_button_pressed():
	if blue_belt_cost <= gear_coins:
		gear_coins -= blue_belt_cost
		belt = 4
		blue_belt_button.text = "Owned"
		blue_belt_button.disabled = true
		blue_belt_label.hide()
		blue_belt_gear.hide()
		red_belt_container.show()
		parry_button.disabled = false
		parry_button.text = "Buy"
		parry_label.show()
		parry_gear.show()
		player_sprite.sprite_frames = load("res://resources/red_belt.tres")
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_red_belt_button_pressed():
	if red_belt_cost <= gear_coins:
		gear_coins -= red_belt_cost
		belt = 5
		red_belt_button.text = "Owned"
		red_belt_button.disabled = true
		red_belt_label.hide()
		red_belt_gear.hide()
		black_belt_container.show()
		player_sprite.sprite_frames = load("res://resources/black_belt.tres")
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_black_belt_button_pressed():
	if black_belt_cost <= gear_coins:
		gear_coins -= black_belt_cost
		belt = 6
		black_belt_button.text = "Owned"
		black_belt_button.disabled = true
		black_belt_label.hide()
		black_belt_gear.hide()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_parry_button_pressed():
	if parry:
		return
	if gear_coins >= parry_cost:
		gear_coins -= parry_cost
		parry = true
		parry_button.text = "Owned"
		parry_label.hide()
		parry_gear.hide()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")

func _on_hold_button_pressed():
	if hold:
		return
	if gear_coins >= hold_cost:
		gear_coins -= hold_cost
		hold = true
		hold_button.text = "Owned"
		hold_label.hide()
		hold_gear.hide()
		var gear_coin_string = str(gear_coins)
		for i in range(int((len(gear_coin_string) - 1) /3)):
			gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
		gear_label.text = gear_coin_string
		shop_label.text = gear_coin_string
		
		print("saving")
