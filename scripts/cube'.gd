extends CharacterBody2D

var gravity = -690
var structure = "cube"
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
var damage_value : int = 2
var grounded : bool = true
var stored_velocity_x : float = 3
var increase : bool = true

func _ready():
	death.monitoring = false
	detector.monitoring = false
	velocity.y -= 300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x > 30:
		damage_value = 3
	elif velocity.x < 30:
		damage_value = 2
	if grounded:
		sprite.texture = load("res://assets/structures/cube_grounded.png")
		if velocity.x < 30:
			damage_value = 3
		elif velocity.x >= 30:
			damage_value = 4
		if increase and position.y > -43:
			velocity.y = -360
		if position.y <= -43:
			position.y = -43
			velocity.y = 0
	elif !grounded:
		sprite.texture = load("res://assets/structures/cube_ungrounded.png")
	if !is_on_floor():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 750 * delta
	elif velocity.x < 0:
		velocity.x = 0
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.get_parent().straight:
		if velocity.x > 0:
			return
		velocity.x += 650

func _on_area_2d_2_body_entered(body):
	if velocity.x > 0:
		stored_velocity_x = velocity.x
	if body == self:
		return
	print("cube damage value", damage_value)
	print("other object damage value", body.damage_value)
	if damage_value >= body.damage_value:
		body.queue_free()
	if damage_value <= body.damage_value:
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0

func _on_timer_timeout():
	death.monitoring = true
	detector.monitoring = true
	velocity.y = 0
	collision.disabled = false
	increase = false
