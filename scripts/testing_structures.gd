extends Node2D

@export_group("Player")
var sfx_player = preload("res://scenes/sfx_player.tscn")
@export var hitbox : CollisionShape2D
@export var player : CharacterBody2D
@export var player_sprite : AnimatedSprite2D
@export_group("Timers")
@export var disk_timer : Timer
@export var pillar_timer : Timer
@export var ball_timer : Timer
@export var wall_timer : Timer
@export var cube_timer : Timer
@export var animation_timer : Timer
@export_group("Structures")
var disk_tween : Tween
@export var disk_bar : ProgressBar

@export var pillar_container : HBoxContainer
var pillar_tween : Tween
@export var pillar_bar : ProgressBar

@export var ball_container : HBoxContainer
var ball_tween : Tween
@export var ball_bar : ProgressBar

@export var cube_container : HBoxContainer
var cube_tween : Tween
@export var cube_bar : ProgressBar

@export var wall_container: HBoxContainer
var wall_tween : Tween
@export var wall_bar : ProgressBar

var disk_scene = preload("res://scenes/disk.tscn")
var pillar_scene = preload("res://scenes/pillar.tscn")
var ball_scene = preload("res://scenes/ball.tscn")
var wall_scene = preload("res://scenes/wall.tscn")
var cube_scene = preload("res://scenes/cube.tscn")
var disky : bool = false
var pillary : bool = false
var bally : bool = false
var wally : bool = false
var cubey : bool = false
var structure_loading : bool = false
var structure_loaded : bool = false
var straight : bool = false
var kick : bool = false
var uppercut : bool = false
var stomp : bool = false
var parry : bool = false
var hold : bool = false 
var explode : bool = false

func _ready():
	SaveSystem.load_game()
	Global.disk_break.connect(_disk_break)
	Global.pillar_break.connect(_pillar_break)
	Global.ball_break.connect(_ball_break)
	Global.wall_break.connect(_wall_break)
	Global.cube_break.connect(_cube_break)
	disk_tween = create_tween()
	disk_tween.tween_property(disk_bar, "value", 1, 1)
	# Pillar
	if SaveSystem.save_game.pillar > 0:
		print("pillar unlocked")
		pillar_timer.start()
		pillar_container.show()
		pillar_tween = create_tween()
		pillar_tween.tween_property(pillar_bar, "value", 1, 5)
		
	# Ball
	if SaveSystem.save_game.ball >= 1:
		print("ball unlocked")
		ball_timer.start() 
		ball_container.show()
		ball_tween = create_tween()
		ball_tween.tween_property(ball_bar, "value", 1, 10)
		
	# Cube
	if SaveSystem.save_game.cube > 0:
		print("cube unlocked")
		cube_timer.start()
		cube_container.show()
		cube_tween = create_tween()
		cube_tween.tween_property(cube_bar, "value", 1, 15)
	
	# Wall
	if SaveSystem.save_game.wall > 0:
		print("wall unlocked")
		wall_timer.start()
		wall_container.show()
		wall_tween = create_tween()
		wall_tween.tween_property(wall_bar, "value", 1, 20)

func _physics_process(delta) -> void:
	if structure_loading:
		print("structure loading")
		return
	if structure_loaded:
		if SaveSystem.save_game.straight_active and animation_timer.is_stopped():
			print("auto straighting")
			player_sprite.play("straight")
			hitbox.disabled = false
			straight = true
			modifier_cooldown()
		return
	if cubey:
		cube_bar.value = 0
		print("cube started")
		structure_loading = true
		cubey = false
		var cube = cube_scene.instantiate()
		add_child(cube)
		cube.global_position = Vector2(226, 417)
		await get_tree().create_timer(1).timeout
		cube_timer.start()
		cube_tween = create_tween()
		cube_tween.tween_property(cube_bar, "value", 1, 15)
		print("cube timer")
		structure_loading = false
		structure_loaded = true
		
	elif wally:
		wall_bar.value = 0
		print("wall started")
		structure_loading = true
		wally = false
		var wall = wall_scene.instantiate()
		add_child(wall)
		wall.global_position = Vector2(226, 446)
		await get_tree().create_timer(1).timeout
		wall_timer.start()
		wall_tween = create_tween()
		wall_tween.tween_property(wall_bar, "value", 1, 20)
		print("wall timer")
		structure_loading = false
		structure_loaded = true
	
	elif bally:
		ball_bar.value = 0
		print("ball started")
		structure_loading = true
		bally = false
		var ball = ball_scene.instantiate()
		add_child(ball)
		ball.global_position = Vector2(211, 404)
		await get_tree().create_timer(0.2).timeout
		ball_timer.start()
		ball_tween = create_tween()
		ball_tween.tween_property(ball_bar, "value", 1, 10)
		print("ball timer")
		structure_loading = false
		structure_loaded = true
		
	elif pillary:
		pillar_bar.value = 0
		print("pillar started")
		structure_loading = true
		pillary = false
		var pillar = pillar_scene.instantiate()
		add_child(pillar)
		pillar.global_position = Vector2(216, 448)
		await get_tree().create_timer(0.3).timeout
		pillar_timer.start()
		pillar_tween = create_tween()
		pillar_tween.tween_property(pillar_bar, "value", 1, 5)
		print("pillar timer")
		structure_loading = false
		structure_loaded = true
		
	elif disky:
		disk_bar.value = 0
		print("disk started")
		structure_loading = true
		disky = false
		var disk = disk_scene.instantiate()
		add_child(disk)
		disk.global_position = Vector2(216, 391)
		await get_tree().create_timer(0.1).timeout
		disk_timer.start()
		disk_tween = create_tween()
		disk_tween.tween_property(disk_bar, "value", 1, 1)
		print("disk timer")
		structure_loading = false
		structure_loaded = true

func _input(event) -> void:
	if !structure_loaded or Global.shop:
		#if event.is_action_pressed("straight"):
			#player_sprite.play("straight")
			#animation_timer.start()
		#elif event.is_action_pressed("kick") and SaveSystem.save_game.kick:
			#player_sprite.play("kick")
			#animation_timer.start()
		return
	if event.is_action_pressed("straight"):
		print("straighting")
		player_sprite.play("straight")
		hitbox.disabled = false
		straight = true
		modifier_cooldown()
	elif event.is_action_pressed("stomp") and SaveSystem.save_game.stomp:
		print("stomping")
		player_sprite.play("stomp")
		hitbox.disabled = false
		stomp = true
		modifier_cooldown()
	elif event.is_action_pressed("kick") and SaveSystem.save_game.kick:
		print("kicking")
		player_sprite.play("kick")
		hitbox.disabled = false
		kick = true
		modifier_cooldown()
	elif event.is_action_pressed("uppercut") and SaveSystem.save_game.uppercut:
		print("uppercutting")
		player_sprite.play("uppercut")
		hitbox.disabled = false
		uppercut = true
		modifier_cooldown()
	elif event.is_action_pressed("parry") and SaveSystem.save_game.parry:
		print("parrying")
		player_sprite.play("parry")
		hitbox.disabled = false
		parry = true
		modifier_cooldown()
	elif event.is_action_pressed("hold") and SaveSystem.save_game.hold:
		print("holding")
		player_sprite.play("hold")
		hitbox.disabled = false
		hold = true
		modifier_cooldown()
	elif event.is_action_pressed("explode") and SaveSystem.save_game.explode:
		print("exploding")
		player_sprite.play("explode")
		hitbox.disabled = false
		explode = true
		modifier_cooldown()

func _on_disk_timer_timeout() -> void:
	print("disk timer finished")
	disky = true

func _on_pillar_timer_timeout() -> void:
	print("pillar timer finished")
	pillary = true

func modifier_cooldown():
	await get_tree().create_timer(0.05).timeout
	hitbox.disabled = true
	straight = false
	uppercut = false
	stomp = false
	kick = false
	parry = false
	hold = false
	explode = false
	animation_timer.start()

func _on_ball_timer_timeout():
	print("ball timer finished")
	bally = true

func _on_cube_timer_timeout():
	print("cube timer finished")
	cubey = true

func _on_wall_timer_timeout():
	print("wall timer finished")
	wally = true

func _on_animation_timer_timeout():
	player_sprite.play("default")

func _on_structure_detector_area_entered(area):
	print("structure detected")

func _on_structure_detector_area_exited(area):
	print("structure leaving")
	structure_loaded = false

func _disk_break():
	var player = sfx_player.instantiate()
	add_child(player)
	player.stream = load("res://assets/audio/sfx/disk_break.mp3")
	player.play()
func _pillar_break():
	var player = sfx_player.instantiate()
	add_child(player)
	player.stream = load("res://assets/audio/sfx/pillar_break.mp3")
	player.play()
func _ball_break():
	var player = sfx_player.instantiate()
	add_child(player)
	player.stream = load("res://assets/audio/sfx/ball_break.mp3")
	player.play()
func _wall_break():
	var player = sfx_player.instantiate()
	add_child(player)
	player.stream = load("res://assets/audio/sfx/wall_break.mp3")
	player.play()
func _cube_break():
	var player = sfx_player.instantiate()
	add_child(player)
	player.stream = load("res://assets/audio/sfx/cube_break.mp3")
	player.play()
