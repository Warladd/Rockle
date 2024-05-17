extends CharacterBody2D

var gravity = -400
var structure = "ball"
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
var grounded : bool = false
var damage_value : int = 1
var stored_velocity_x : float = 0
var structures : Node2D
var modifiers : Array = []

func _ready():
	detector.monitoring = false
	velocity.y -= 650

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x > 0:
		damage_value = 2
	elif velocity.x <= 0:
		damage_value = 1
	if grounded:
		sprite.texture = load("res://assets/structures/ball_grounded.png")
		if velocity.x <= 0:
			damage_value = 2
		elif velocity.x > 0:
			damage_value = 3
		if position.y <= -30:
			position.y = -30
			velocity.y = 0
	elif !grounded:
		sprite.texture = load("res://assets/structures/ball_ungrounded.png")
	if !is_on_floor():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 650 * delta
	elif velocity.x < 0:
		velocity.x = 0
	move_and_slide()

func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if body.get_parent().straight:
		if velocity.x > 0:
			return
		velocity.x += 800
		modifiers.append("straight")
	elif body.get_parent().kick:
		grounded = false
		velocity.y = 0
		velocity.y -= 300
		modifiers.append("kick")
	elif structures.uppercut:
		grounded = false
		velocity.y = 0
		velocity.y -= 200
		velocity.x += 300
		modifiers.append("uppercut")
		
func _on_timer_timeout():
	detector.monitoring = true
	velocity.y = 0
	collision.disabled = false

func _on_area_2d_2_area_entered(area):
	if velocity.x > 0:
		stored_velocity_x = velocity.x
	if area.get_parent() == self:
		return
	print("ball damage value", damage_value)
	print("other object damage value", area.get_parent().damage_value)
	if damage_value <= area.get_parent().damage_value:
		if modifiers.has("straight"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase
		if modifiers.has("kick"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase * 3
		if modifiers.has("uppercut"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase * 5
		SaveSystem.saving()
		print("saving")
	if damage_value >= area.get_parent().damage_value:
		area.get_parent().queue_free()
	if damage_value <= area.get_parent().damage_value:
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0
