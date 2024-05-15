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
@export var uppercut_button : Button
@export var uppercut_label : Label
@export var uppercut_gear : TextureRect
@export var explode_button : Button
@export var explode_label : Label
var straighting : bool = false
var kicking : bool = false
var uppercutting : bool = false

# Combos Combo Site: https://docs.google.com/spreadsheets/d/1zRu2wWWSNwFwwg9O0M-dsk9ASbUwgPAdSt8UNESvni4/edit#gid=6435056
var struppercut : bool = false
var struick : bool = false
var hop : bool = false
var us : bool = false
var uk : bool = false
var ks : bool = false
var ku : bool = false
var uu : bool = false
var kk : bool = false

var strupper_kick : bool = false
var uks : bool = false
var kus : bool = false
var uku : bool = false
var ukk : bool = false
var ksk : bool = false
var kks : bool = false
var uus : bool = false
var uuk : bool = false

# Masteries
@export_group("Mastery Nodes")
@export var straight_m_button : Button
@export var straight_m_label : Label
@export var straight_m_gear : TextureRect
@export var white_belt_label : Label
@export var white_belt_button : Button
@export var white_belt_gear : TextureRect
@export var kick_m_button : Button
@export var kick_m_label : Label
@export var kick_m_container : HBoxContainer
@export var kick_m_gear : TextureRect
@export var yellow_belt_label : Label
@export var yellow_belt_button : Button
@export var yellow_belt_container : HBoxContainer
@export var yellow_belt_gear : TextureRect
@export var uppercut_m_button : Button
@export var uppercut_m_label : Label
@export var uppercut_m_container : HBoxContainer
@export var uppercut_m_gear : TextureRect
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

# Costs
var kick_cost : int = 250
var uppercut_cost : int = 5000
var explode_cost : int = 500000
var straight_m_cost : int = 500
var kick_m_cost : int = 5000
var uppercut_m_cost : int = 75000

var white_belt_cost : int = 1000
var yellow_belt_cost : int = 15000
var green_belt_cost : int = 100000
var blue_belt_cost : int = 1000000
var red_belt_cost : int = 15000000
var black_belt_cost : int = 550000000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_sprite.play("default")
	SaveSystem.load_game()
	shop.hide()
	disk_timer.start()
	pause_menu.hide()
	gear_label.text = str(SaveSystem.save_game.gear_coins)
	shop_label.text = str(SaveSystem.save_game.gear_coins)
	
	# Disk
	disk_label.text = str(SaveSystem.save_game.disk_cost)
	disk_name_label.text = " Disk" + " (" + str(SaveSystem.save_game.disk) + ")"
	disk_tween = create_tween()
	disk_tween.tween_property(disk_bar, "value", 1, 0.3)
	
	# Pillar
	pillar_label.text = str(SaveSystem.save_game.pillar_cost)
	pillar_name_label.text = " Pillar" + " (" + str(SaveSystem.save_game.pillar) + ")"
	if SaveSystem.save_game.pillar > 0:
		pillar_timer.start()
		pillar_container.show()
		pillar_tween = create_tween()
		pillar_tween.tween_property(pillar_bar, "value", 1, 5)
		
	# Ball
	if SaveSystem.save_game.belt < 1:
		ball_label.hide()
		ball_gear.hide()
		ball_name_label.text = " Ball"
		ball_button.disabled = true
		ball_button.text = "Locked"
	elif SaveSystem.save_game.belt >= 1:
		ball_label.text = str(SaveSystem.save_game.ball_cost)
		ball_name_label.text = " Ball" + " (" + str(SaveSystem.save_game.ball) + ")"
		if SaveSystem.save_game.ball > 0:
			ball_timer.start()
			ball_container.show()
			ball_tween = create_tween()
			ball_tween.tween_property(ball_bar, "value", 1, 10)
		
	# Cube
	if SaveSystem.save_game.belt < 3:
		cube_label.hide()
		cube_gear.hide()
		cube_name_label.text = " Cube"
		cube_button.disabled = true
		cube_button.text = "Locked"
	elif SaveSystem.save_game.belt >= 2:
		cube_label.text = str(SaveSystem.save_game.cube_cost)
		cube_name_label.text = " Cube" + " (" + str(SaveSystem.save_game.cube) + ")"
		if SaveSystem.save_game.cube > 0:
			cube_timer.start()
			cube_container.show()
			cube_tween = create_tween()
			cube_tween.tween_property(cube_bar, "value", 1, 20)
		
	# Wall
	if SaveSystem.save_game.belt < 2:
		wall_label.hide()
		wall_gear.hide()
		wall_name_label.text = " Wall"
		wall_button.disabled = true
		wall_button.text = "Locked"
	elif SaveSystem.save_game.belt >= 2:
		wall_label.text = str(SaveSystem.save_game.wall_cost)
		wall_name_label.text = " Wall" + " (" + str(SaveSystem.save_game.wall) + ")"
		if SaveSystem.save_game.wall > 0:
			wall_timer.start()
			wall_container.show()
			wall_tween = create_tween()
			wall_tween.tween_property(wall_bar, "value", 1, 30)
	
	# Modifiers
	if SaveSystem.save_game.kick:
		kick_button.text = "Bought"
		kick_label.hide()
		kick_gear.hide()
	
	if SaveSystem.save_game.uppercut:
		uppercut_button.text = "Bought"
		uppercut_label.hide()
		uppercut_gear.hide()
	
	if SaveSystem.save_game.explode:
		explode_button.text = "Bought"
		explode_label.hide()
	
	# Belt Stuff
	if SaveSystem.save_game.belt == 6:
		black_belt_button.text = "Bought"
		black_belt_button.disabled = true
		black_belt_label.hide()
		black_belt_gear.hide()
	if SaveSystem.save_game.belt >= 5:
		red_belt_button.text = "Bought"
		red_belt_button.disabled = true
		player_sprite.sprite_frames = load("res://resources/black_belt.tres")
		red_belt_label.hide()
		red_belt_gear.hide()
		black_belt_container.show()
	if SaveSystem.save_game.belt >= 4:
		blue_belt_button.text = "Bought"
		blue_belt_button.disabled = true
		if SaveSystem.save_game.belt == 4:
			player_sprite.sprite_frames = load("res://resources/red_belt.tres")
		blue_belt_label.hide()
		blue_belt_gear.hide()
		red_belt_container.show()
	if SaveSystem.save_game.belt >= 3:
		green_belt_button.text = "Bought"
		green_belt_button.disabled = true
		if SaveSystem.save_game.belt == 3:
			player_sprite.sprite_frames = load("res://resources/blue_belt.tres")
		green_belt_label.hide()
		green_belt_gear.hide()
		blue_belt_container.show()
	if SaveSystem.save_game.belt >= 2:
		yellow_belt_button.text = "Bought"
		yellow_belt_button.disabled = true
		if SaveSystem.save_game.belt == 2:
			player_sprite.sprite_frames = load("res://resources/green_belt.tres")
		yellow_belt_label.hide()
		yellow_belt_gear.hide()
		green_belt_container.show()
		uppercut_m_container.show()
		if SaveSystem.save_game.uppercut_mastery:
			uppercut_m_button.text = "Inactive"
			uppercut_m_gear.hide()
			uppercut_m_label.hide()
			uppercut_m_gear.hide()
	if SaveSystem.save_game.belt >= 1:
		white_belt_button.text = "Bought"
		white_belt_button.disabled = true
		white_belt_label.hide()
		white_belt_gear.hide()
		white_belt_gear.hide()
		if SaveSystem.save_game.belt == 1:
			player_sprite.sprite_frames = load("res://resources/yellow_belt.tres")
		yellow_belt_container.show()
		kick_m_container.show()
		if SaveSystem.save_game.kick_mastery:
			kick_m_button.text = "Inactive"
			kick_m_label.hide()
			kick_m_gear.hide()
			
	if SaveSystem.save_game.belt < 1:
		kick_button.text = "Locked"
		kick_button.disabled = true
		kick_label.hide()
		kick_gear.hide()
	if SaveSystem.save_game.belt < 2:
		uppercut_button.text = "Locked"
		uppercut_button.disabled = true
		uppercut_label.hide()
		uppercut_gear.hide()
		
	if SaveSystem.save_game.straight_mastery:
		straight_m_button.text = "Inactive"
		straight_m_label.hide()
		straight_m_gear.hide()
	if SaveSystem.save_game.straight_active:
		straight_m_button.text = "Active"
	elif SaveSystem.save_game.kick_active:
		kick_m_button.text = "Active"
	elif SaveSystem.save_game.uppercut_active:
		uppercut_m_button.text = "Active"
	
	save_timer.start()
	#if SaveSystem.save_game.kick:
		#kick_label.hide()
	#if SaveSystem.save_game.uppercut:
		#uppercut_label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
	
func _on_button_pressed() -> void:
	shop.show()
	shop_label.text = str(SaveSystem.save_game.gear_coins)

func _on_disk_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.disk_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.disk_cost
		SaveSystem.save_game.disk += 1
		if SaveSystem.save_game.disk == 10 or SaveSystem.save_game.disk == 25 or SaveSystem.save_game.disk == 50 or SaveSystem.save_game.disk == 75 or SaveSystem.save_game.disk == 100:
			SaveSystem.save_game.disk_increase *= 10
			SaveSystem.save_game.disk_cost *= 5
		SaveSystem.save_game.disk_cost = (SaveSystem.save_game.disk_cost + 5) * 1.2
		SaveSystem.save_game.disk_cost = roundi(SaveSystem.save_game.disk_cost)
		disk_name_label.text = " Disk" + " (" + str(SaveSystem.save_game.disk) + ")"
		disk_label.text = str(SaveSystem.save_game.disk_cost)
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		
		SaveSystem.saving()
		print("saving")

func _on_pillar_button_pressed():
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.pillar_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.pillar_cost
		SaveSystem.save_game.pillar_cost = (SaveSystem.save_game.pillar_cost + 25) * 1.3
		SaveSystem.save_game.pillar += 1
		pillar_name_label.text = " Pillar" + " (" + str(SaveSystem.save_game.pillar) + ")"
		if SaveSystem.save_game.pillar == 1:
			pillar_container.show()
			pillar_ready = true
		if SaveSystem.save_game.pillar == 10 or SaveSystem.save_game.pillar == 25 or SaveSystem.save_game.pillar == 50 or SaveSystem.save_game.pillar == 75 or SaveSystem.save_game.pillar == 100:
			SaveSystem.save_game.pillar_increase *= 10
			SaveSystem.save_game.pillar_cost *= 5
		SaveSystem.save_game.pillar_cost = roundi(SaveSystem.save_game.pillar_cost)
		pillar_label.text = str(SaveSystem.save_game.pillar_cost)
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		
		SaveSystem.saving()
		print("saving")

func _on_ball_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.ball_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.ball_cost
		SaveSystem.save_game.ball_cost = (SaveSystem.save_game.ball_cost + 200) * 1.4
		SaveSystem.save_game.ball += 1
		if SaveSystem.save_game.ball == 1:
			ball_container.show()
			ball_ready = true
		if SaveSystem.save_game.ball == 10 or SaveSystem.save_game.ball == 25 or SaveSystem.save_game.ball == 50 or SaveSystem.save_game.ball == 75 or SaveSystem.save_game.ball == 100:
			SaveSystem.save_game.ball_increase *= 10
			SaveSystem.save_game.ball_cost *= 5
		ball_name_label.text = " Ball" + " (" + str(SaveSystem.save_game.ball) + ")"
		SaveSystem.save_game.ball_cost = roundi(SaveSystem.save_game.ball_cost)
		ball_label.text = str(SaveSystem.save_game.ball_cost)
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		
		SaveSystem.saving()
		print("saving")

func _on_cube_button_pressed():
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.cube_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.cube_cost
		SaveSystem.save_game.cube_cost = (SaveSystem.save_game.cube_cost + 10000) * 1.75
		SaveSystem.save_game.cube += 1
		if SaveSystem.save_game.cube == 1:
			cube_container.show()
			cube_ready = true
			cube_label.show()
			cube_gear.show()
		if SaveSystem.save_game.cube == 10 or SaveSystem.save_game.cube == 25 or SaveSystem.save_game.cube == 50 or SaveSystem.save_game.cube == 75 or SaveSystem.save_game.cube == 100:
			SaveSystem.save_game.cube_increase *= 10
			SaveSystem.save_game.cube_cost *= 5
		cube_name_label.text = " Cube" + " (" + str(SaveSystem.save_game.cube) + ")"
		SaveSystem.save_game.cube_cost = roundi(SaveSystem.save_game.cube_cost)
		cube_label.text = str(SaveSystem.save_game.cube_cost)
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_wall_button_pressed() -> void:
	if SaveSystem.save_game.gear_coins >= SaveSystem.save_game.wall_cost:
		SaveSystem.save_game.gear_coins -= SaveSystem.save_game.wall_cost
		SaveSystem.save_game.wall_cost = (SaveSystem.save_game.wall_cost + 1000) * 1.5
		SaveSystem.save_game.wall += 1
		if SaveSystem.save_game.wall == 1:
			wall_container.show()
			wall_ready = true
		if SaveSystem.save_game.wall == 10 or SaveSystem.save_game.wall == 25 or SaveSystem.save_game.wall == 50 or SaveSystem.save_game.wall == 75 or SaveSystem.save_game.wall == 100:
			SaveSystem.save_game.wall_increase *= 10
			SaveSystem.save_game.wall_cost *= 5
		wall_name_label.text = " Wall" + " (" + str(SaveSystem.save_game.wall) + ")"
		SaveSystem.save_game.wall_cost = roundi(SaveSystem.save_game.wall_cost)
		wall_label.text = str(SaveSystem.save_game.wall_cost)
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
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

func _on_kick_button_pressed():
	if SaveSystem.save_game.kick:
		return
	if SaveSystem.save_game.gear_coins >= kick_cost:
		SaveSystem.save_game.gear_coins -= kick_cost
		SaveSystem.save_game.kick = true
		kick_button.text = "Bought"
		kick_label.hide()
		kick_gear.hide()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_uppercut_button_pressed():
	if SaveSystem.save_game.uppercut:
		return
	if SaveSystem.save_game.gear_coins >= uppercut_cost:
		SaveSystem.save_game.gear_coins -= uppercut_cost
		SaveSystem.save_game.uppercut = true
		uppercut_button.text = "Bought"
		uppercut_label.hide()
		uppercut_gear.hide()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_explode_button_pressed():
	if SaveSystem.save_game.explode:
		return
	if SaveSystem.save_game.gear_coins >= explode_cost:
		SaveSystem.save_game.gear_coins -= explode_cost
		SaveSystem.save_game.explode = true
		explode_button.text = "Bought"
		explode_label.hide()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_straight_m_button_pressed():
	if SaveSystem.save_game.straight_active:
		straight_m_button.text = "Inactive"
		SaveSystem.save_game.straight_active = false
		SaveSystem.saving()
		print("saving")
		return
	elif SaveSystem.save_game.straight_mastery and !SaveSystem.save_game.straight_active:
		straight_m_button.text = "Active"
		SaveSystem.save_game.straight_active = true
		if SaveSystem.save_game.kick_active:
			kick_m_button.text = "Inactive"
			SaveSystem.save_game.kick_active = false
		if SaveSystem.save_game.uppercut_active:
			uppercut_m_button.text = "Inactive"
			SaveSystem.save_game.uppercut_active = false
		SaveSystem.saving()
		print("saving")
		return
	if straight_m_cost <= SaveSystem.save_game.gear_coins:
		SaveSystem.save_game.gear_coins -= straight_m_cost
		SaveSystem.save_game.straight_mastery = true
		SaveSystem.save_game.straight_active = true
		straight_m_button.text = "Active"
		if SaveSystem.save_game.kick_active:
			kick_m_button.text = "Inactive"
			SaveSystem.save_game.kick_active = false
		if SaveSystem.save_game.uppercut_active:
			uppercut_m_button.text = "Inactive"
			SaveSystem.save_game.uppercut_active = false
		straight_m_label.hide()
		straight_m_gear.hide()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_white_belt_button_pressed():
	if white_belt_cost <= SaveSystem.save_game.gear_coins:
		SaveSystem.save_game.gear_coins -= white_belt_cost
		SaveSystem.save_game.belt = 1
		white_belt_button.text = "Bought"
		white_belt_button.disabled = true
		white_belt_label.hide()
		white_belt_gear.hide()
		yellow_belt_container.show()
		kick_m_container.show()
		player_sprite.sprite_frames = load("res://resources/yellow_belt.tres")
		ball_button.disabled = false
		ball_button.text = "Buy"
		ball_label.show()
		ball_gear.show()
		kick_button.text = "Buy"
		kick_button.disabled = false
		kick_label.show()
		kick_gear.show()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_kick_m_button_pressed():
	if SaveSystem.save_game.kick_active:
		kick_m_button.text = "Inactive"
		SaveSystem.save_game.kick_active = false
		SaveSystem.saving()
		print("saving")
		return
	elif SaveSystem.save_game.kick_mastery and !SaveSystem.save_game.kick_active:
		kick_m_button.text = "Active"
		SaveSystem.save_game.kick_active = true
		if SaveSystem.save_game.straight_active:
			straight_m_button.text = "Inactive"
			SaveSystem.save_game.straight_active = false
		if SaveSystem.save_game.uppercut_active:
			uppercut_m_button.text = "Inactive"
			SaveSystem.save_game.uppercut_active = false
		SaveSystem.saving()
		print("saving")
		return
	if kick_m_cost <= SaveSystem.save_game.gear_coins:
		SaveSystem.save_game.gear_coins -= kick_m_cost
		SaveSystem.save_game.kick_mastery = true
		SaveSystem.save_game.kick_active = true
		kick_m_button.text = "Active"
		kick_m_label.hide()
		kick_m_gear.hide()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		if SaveSystem.save_game.straight_active:
			straight_m_button.text = "Inactive"
			SaveSystem.save_game.straight_active = false
		if SaveSystem.save_game.uppercut_active:
			uppercut_m_button.text = "Inactive"
			SaveSystem.save_game.uppercut_active = false
		SaveSystem.saving()
		print("saving")

func _on_yellow_belt_button_pressed():
	if yellow_belt_cost <= SaveSystem.save_game.gear_coins:
		SaveSystem.save_game.gear_coins -= yellow_belt_cost
		SaveSystem.save_game.belt = 2
		yellow_belt_button.text = "Bought"
		yellow_belt_button.disabled = true
		yellow_belt_label.hide()
		yellow_belt_gear.hide()
		green_belt_container.show()
		uppercut_m_container.show()
		player_sprite.sprite_frames = load("res://resources/green_belt.tres")
		wall_button.disabled = false
		wall_button.text = "Buy"
		wall_label.show()
		wall_gear.show()
		uppercut_button.disabled = false
		uppercut_button.text = "Buy"
		uppercut_label.show()
		uppercut_gear.show()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_uppercut_m_button_pressed():
	if SaveSystem.save_game.uppercut_active:
		uppercut_m_button.text = "Inactive"
		SaveSystem.save_game.uppercut_active = false
		SaveSystem.saving()
		print("saving")
		return
	if SaveSystem.save_game.uppercut_mastery and !SaveSystem.save_game.uppercut_active:
		uppercut_m_button.text = "Active"
		SaveSystem.save_game.uppercut_active = true
		if SaveSystem.save_game.straight_active:
			straight_m_button.text = "Inactive"
			SaveSystem.save_game.straight_active = false
		if SaveSystem.save_game.kick_active:
			kick_m_button.text = "Inactive"
			SaveSystem.save_game.kick_active = false
		SaveSystem.saving()
		print("saving")
		return
	if uppercut_m_cost <= SaveSystem.save_game.gear_coins:
		SaveSystem.save_game.gear_coins -= uppercut_m_cost
		SaveSystem.save_game.uppercut_mastery = true
		SaveSystem.save_game.uppercut_active = true
		uppercut_m_button.text = "Active"
		uppercut_m_label.hide()
		uppercut_m_gear.hide()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		if SaveSystem.save_game.straight_active:
			straight_m_button.text = "Inactive"
			SaveSystem.save_game.straight_active = false
		if SaveSystem.save_game.kick_active:
			kick_m_button.text = "Inactive"
			SaveSystem.save_game.kick_active = false
		SaveSystem.saving()
		print("saving")

func _on_green_belt_button_pressed():
	if green_belt_cost <= SaveSystem.save_game.gear_coins:
		SaveSystem.save_game.gear_coins -= green_belt_cost
		SaveSystem.save_game.belt = 3
		green_belt_button.text = "Bought"
		green_belt_button.disabled = true
		green_belt_label.hide()
		green_belt_gear.hide()
		blue_belt_container.show()
		player_sprite.sprite_frames = load("res://resources/blue_belt.tres")
		cube_button.disabled = false
		cube_button.text = "Buy"
		cube_label.show()
		cube_gear.show()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_blue_belt_button_pressed():
	if blue_belt_cost <= SaveSystem.save_game.gear_coins:
		SaveSystem.save_game.gear_coins -= blue_belt_cost
		SaveSystem.save_game.belt = 4
		blue_belt_button.text = "Bought"
		blue_belt_button.disabled = true
		blue_belt_label.hide()
		blue_belt_gear.hide()
		red_belt_container.show()
		player_sprite.sprite_frames = load("res://resources/red_belt.tres")
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_red_belt_button_pressed():
	if red_belt_cost <= SaveSystem.save_game.gear_coins:
		SaveSystem.save_game.gear_coins -= red_belt_cost
		SaveSystem.save_game.belt = 5
		red_belt_button.text = "Bought"
		red_belt_button.disabled = true
		red_belt_label.hide()
		red_belt_gear.hide()
		black_belt_container.show()
		player_sprite.sprite_frames = load("res://resources/black_belt.tres")
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")

func _on_black_belt_button_pressed():
	if black_belt_cost <= SaveSystem.save_game.gear_coins:
		SaveSystem.save_game.gear_coins -= black_belt_cost
		SaveSystem.save_game.belt = 6
		black_belt_button.text = "Bought"
		black_belt_button.disabled = true
		black_belt_label.hide()
		black_belt_gear.hide()
		gear_label.text = str(SaveSystem.save_game.gear_coins)
		shop_label.text = str(SaveSystem.save_game.gear_coins)
		SaveSystem.saving()
		print("saving")
