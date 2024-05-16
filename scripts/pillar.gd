extends CharacterBody2D

var gravity = -575
var structure = "pillar"
@export var death : Area2D
@export var detector : Area2D
@export var collision : CollisionShape2D
@export var sprite : Sprite2D
var damage_value : int = 1
var grounded : bool = true
var stored_velocity_x : float = 0
var increase : bool = true
var structures : Node2D

func _ready():
	death.monitoring = false
	detector.monitoring = false
	velocity.y = -360

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x > 0:
		damage_value = 2
	elif velocity.x <= 0:
		damage_value = 1
	if grounded:
		sprite.texture = load("res://assets/structures/pillar_ungrounded.png")
		if velocity.x <= 0:
			damage_value = 2
		elif velocity.x > 0:
			damage_value = 3
		if increase and position.y > 310:
			velocity.y = -360
		if position.y <= 310:
			position.y = 310
			velocity.y = 0
	elif !grounded:
		sprite.texture = load("res://assets/structures/pillar_grounded.png")
	if !is_on_floor():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 700 * delta
	elif velocity.x < 0:
		velocity.x = 0
	move_and_slide()

func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if body.get_parent().straight:
		if velocity.x > 0:
			return
		velocity.x += 800
	elif body.get_parent().kick:
		grounded = false
		velocity.y -= 300

func _on_timer_timeout():
	death.monitoring = true
	detector.monitoring = true
	increase = false
	velocity.y = 0
	collision.disabled = false

func _on_area_2d_2_area_entered(area):
	if velocity.x > 0:
		stored_velocity_x = velocity.x
	if area.get_parent() == self:
		return
	print("pillar damage value", damage_value)
	print("other object damage value", area.get_parent().damage_value)
	if damage_value <= area.get_parent().damage_value:
		if structures.straight:
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase
		elif structures.kick:
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase * 3
		SaveSystem.saving()
		print("saving")
	if damage_value >= area.get_parent().damage_value:
		area.get_parent().queue_free()
	if damage_value <= area.get_parent().damage_value:
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0
