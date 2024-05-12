extends Node2D

@export var hitbox : CollisionShape2D
var disk_scene = preload("res://scenes/disk.tscn")
var pillar_scene = preload("res://scenes/pillar.tscn")
var disky
var pillary

func _process(delta):
	if disky:
		disky = false
		var disk = disk_scene.instantiate()
		add_child(disk)
		disk.global_position = Vector2(-161, -14)
		await get_tree().create_timer(1).timeout
		$DiskTimer.start()
	if pillary:
		pillary = false
		var pillar = pillar_scene.instantiate()
		add_child(pillar)
		pillar.global_position = Vector2(-183, -69)
		await get_tree().create_timer(1).timeout
		$PillarTimer.start()

func _input(event):
	if event.is_action_pressed("straight"):
		hitbox.disabled = false
		await get_tree().create_timer(0.1).timeout
		hitbox.disabled = true

func _on_disk_timer_timeout():
	disky = true

func _on_pillar_timer_timeout():
	pillary = true
