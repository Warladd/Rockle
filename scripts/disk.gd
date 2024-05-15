extends CharacterBody2D

var gravity = -490
var structure = "disk"
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
var grounded : bool = false
var damage_value : int = 0
var stored_velocity_x : float = 0

func _ready():
	death.monitoring = false
	detector.monitoring = false
	velocity.y -= 800

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x > 30:
		damage_value = 1
	elif velocity.x < 30:
		damage_value = 0
	if grounded:
		sprite.texture = load("res://assets/structures/disk_grounded.png")
		if velocity.x < 30:
			damage_value = 1
		elif velocity.x >= 30:
			damage_value = 2
		if position.y <= -18:
			position.y = -18
			velocity.y = 0
	elif !grounded:
		sprite.texture = load("res://assets/structures/disk_ungrounded.png")
	if !is_on_floor():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 500 * delta
	elif velocity.x < 0:
		velocity.x = 0
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.get_parent().straight:
		if velocity.x > 0:
			return
		velocity.x += 1000

func _on_area_2d_2_body_entered(body):
	if velocity.x > 0:
		stored_velocity_x = velocity.x
	if body == self:
		return
	print("disk damage value", damage_value)
	print("other object damage value", body.damage_value)
	if damage_value >= body.damage_value:
		if body.structure == "pillar":
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase
		elif body.structure == "cube":
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.cube * SaveSystem.save_game.cube_increase * SaveSystem.save_game.general_increase	
		elif body.structure == "ball":
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase
		elif body.structure == "wall":
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.wall * SaveSystem.save_game.wall_increase * SaveSystem.save_game.general_increase
		SaveSystem.saving()
		print("saving")
		body.queue_free()
	if damage_value <= body.damage_value:
		SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		SaveSystem.saving()
		print("saving")
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0
		
func _on_timer_timeout():
	death.monitoring = true
	detector.monitoring = true
	velocity.y = 0
	collision.disabled = false
