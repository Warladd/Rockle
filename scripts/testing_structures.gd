extends Node2D

@export var hitbox : CollisionShape2D
@export var player : CharacterBody2D
var disk_scene = preload("res://scenes/disk.tscn")
var pillar_scene = preload("res://scenes/pillar.tscn")
var disky : bool = false
var disky_loading : bool = false
var pillary : bool = false
var pillary_loading : bool = false

func _process(delta):
	if disky_loading or pillary_loading:
		return
	if disky:
		disky_loading = true
		disky = false
		var disk = disk_scene.instantiate()
		add_child(disk)
		disk.global_position = Vector2(-161, -14)
		await get_tree().create_timer(1).timeout
		$DiskTimer.start()
		disky_loading = false
	if pillary:
		pillary_loading = true
		pillary = false
		var pillar = pillar_scene.instantiate()
		add_child(pillar)
		pillar.global_position = Vector2(-183, -69)
		await get_tree().create_timer(1.2).timeout
		$PillarTimer.start()
		pillary_loading = false

func _input(event):
	if event.is_action_pressed("straight"):
		hitbox.disabled = false
		await get_tree().create_timer(0.1).timeout
		hitbox.disabled = true

func _on_disk_timer_timeout():
	disky = true

func _on_pillar_timer_timeout():
	pillary = true
