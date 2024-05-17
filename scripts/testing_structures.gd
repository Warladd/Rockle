extends Node2D

@export var hitbox : CollisionShape2D
@export var player : CharacterBody2D
@export var player_sprite : AnimatedSprite2D
@export var disk_timer : Timer
@export var pillar_timer : Timer
@export var ball_timer : Timer
@export var wall_timer : Timer
@export var cube_timer : Timer
@export var animation_timer : Timer
@export var structure_cooldown : Timer
@export var modifier_cooldown : Timer
var disk_scene = preload("res://scenes/disk_rigid.tscn")
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
var straight : bool = true
var kick : bool = false
var uppercut : bool = false

func _ready():
	if SaveSystem.save_game.pillar > 0:
		pillar_timer.start()
	if SaveSystem.save_game.ball > 0:
		ball_timer.start() 
	if SaveSystem.save_game.wall > 0:
		wall_timer.start()
	if SaveSystem.save_game.cube > 0:
		cube_timer.start()

func _physics_process(delta) -> void:
	if structure_loading:
		print("structure loading")
		return
	if structure_loaded:
		if SaveSystem.save_game.straight_active and modifier_cooldown.is_stopped():
			modifier_cooldown.start()
			print("auto straighting")
			player_sprite.play("straight")
			hitbox.disabled = false
			straight = true
			kick = false
			uppercut = false
		return
	if cubey:
		print("cube started")
		structure_loading = true
		cubey = false
		var cube = cube_scene.instantiate()
		add_child(cube)
		cube.global_position = Vector2(426, 417)
		await get_tree().create_timer(1).timeout
		cube_timer.start()
		print("cube timer")
		structure_loading = false
		structure_loaded = true
		
	elif wally:
		print("wall started")
		structure_loading = true
		wally = false
		var wall = wall_scene.instantiate()
		add_child(wall)
		wall.global_position = Vector2(426, 446)
		await get_tree().create_timer(1).timeout
		wall_timer.start()
		print("wall timer")
		structure_loading = false
		structure_loaded = true
	
	elif bally:
		print("ball started")
		structure_loading = true
		bally = false
		var ball = ball_scene.instantiate()
		add_child(ball)
		ball.global_position = Vector2(411, 404)
		await get_tree().create_timer(0.2).timeout
		ball_timer.start()
		print("ball timer")
		structure_loading = false
		structure_loaded = true
		
	elif pillary:
		print("pillar started")
		structure_loading = true
		pillary = false
		var pillar = pillar_scene.instantiate()
		add_child(pillar)
		pillar.global_position = Vector2(416, 448)
		await get_tree().create_timer(0.3).timeout
		pillar_timer.start()
		print("pillar timer")
		structure_loading = false
		structure_loaded = true
		
	elif disky:
		print("disk started")
		structure_loading = true
		disky = false
		var disk = disk_scene.instantiate()
		add_child(disk)
		disk.global_position = Vector2(416, 391)
		await get_tree().create_timer(0.1).timeout
		disk_timer.start()
		print("disk timer")
		structure_loading = false
		structure_loaded = true

func _input(event) -> void:
	if !structure_loaded:
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
		kick = false
		uppercut = false
		modifier_cooldown.start()
	elif event.is_action_pressed("kick") and SaveSystem.save_game.kick:
		print("kicking")
		player_sprite.play("kick")
		hitbox.disabled = false
		kick = true
		straight = false
		uppercut = false
		modifier_cooldown.start()
	elif event.is_action_pressed("uppercut") and SaveSystem.save_game.uppercut:
		print("uppercutting")
		player_sprite.play("uppercut")
		hitbox.disabled = false
		kick = false
		straight = false
		uppercut = true
		modifier_cooldown.start()

func _on_disk_timer_timeout() -> void:
	print("disk timer finished")
	disky = true

func _on_pillar_timer_timeout() -> void:
	print("pillar timer finished")
	pillary = true

func _on_modifier_cooldown_timeout():
	hitbox.disabled = true

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
	player_sprite.play("default")
