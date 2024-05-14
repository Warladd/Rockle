extends Node2D

@export var hitbox : CollisionShape2D
@export var player : CharacterBody2D
var disk_scene = preload("res://scenes/disk.tscn")
var pillar_scene = preload("res://scenes/pillar.tscn")
var ball_scene = preload("res://scenes/ball.tscn")
var cube_scene = preload("res://scenes/cube.tscn")
var disky : bool = false
var pillary : bool = false
var bally : bool = false
var cubey : bool = false
var structure_loading : bool = false
var structure_loaded : bool = false
var straight : bool = true
var kick : bool = false
var uppercut : bool = false

func _physics_process(delta) -> void:
	if structure_loading or structure_loaded:
		return
	if cubey:
		print("cube started")
		structure_loading = true
		cubey = false
		var cube = cube_scene.instantiate()
		add_child(cube)
		cube.global_position = Vector2(-161, -58)
		await get_tree().create_timer(0.4).timeout
		$CubeTimer.start()
		print("cube timer")
		structure_loading = false
		structure_loaded = true
	
	elif bally:
		print("ball started")
		structure_loading = true
		bally = false
		var ball = ball_scene.instantiate()
		add_child(ball)
		ball.global_position = Vector2(-183, -69)
		await get_tree().create_timer(0.2).timeout
		$BallTimer.start()
		print("ball timer")
		structure_loading = false
		structure_loaded = true
		
	elif pillary:
		print("pillar started")
		structure_loading = true
		pillary = false
		var pillar = pillar_scene.instantiate()
		add_child(pillar)
		pillar.global_position = Vector2(-183, -69)
		await get_tree().create_timer(0.3).timeout
		$PillarTimer.start()
		print("pillar timer")
		structure_loading = false
		structure_loaded = true
		
	elif disky:
		print("disk started")
		structure_loading = true
		disky = false
		var disk = disk_scene.instantiate()
		add_child(disk)
		disk.global_position = Vector2(-161, -14)
		await get_tree().create_timer(0.1).timeout
		$DiskTimer.start()
		print("disk timer")
		structure_loading = false
		structure_loaded = true

func _input(event) -> void:
	if !structure_loaded or !$StructureCooldown.is_stopped():
		return
	if event.is_action_pressed("straight"):
		print("straighting")
		hitbox.disabled = false
		straight = true
		$ModifierCooldown.start()

func _on_disk_timer_timeout() -> void:
	print("disk timer finished")
	disky = true

func _on_pillar_timer_timeout() -> void:
	print("pillar timer finished")
	pillary = true

func _on_structure_cooldown_timeout():
	structure_loaded = false
	print("structure unloaded")
	print(structure_loaded)

func _on_modifier_cooldown_timeout():
	$StructureCooldown.start()
	print("structure timer")
	hitbox.disabled = true
	straight = false

func _on_ball_timer_timeout():
	print("ball timer finished")
	bally = true

func _on_cube_timer_timeout():
	print("cube timer finished")
	cubey = true
