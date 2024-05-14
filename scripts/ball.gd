extends CharacterBody2D

var gravity = -400
@export var death : Area2D
@export var detector : Area2D
var grounded : bool = false
var damage_value : int = 1
var stored_velocity_x : float = 0

func _ready():
	death.monitoring = false
	detector.monitoring = false
	velocity.y -= 650

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x > 50:
		damage_value = 2
	if grounded:
		if velocity.x < 50:
			damage_value = 2
		elif velocity.x > 50:
			damage_value = 3
		velocity.y = 0
	if !is_on_floor():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 600 * delta
	elif velocity.x < 0:
		velocity.x = 0
	move_and_slide()

func _on_area_2d_body_entered(body):
	velocity.x += 800

func _on_area_2d_2_body_entered(body):
	if velocity.x > 0:
		stored_velocity_x = velocity.x
	if body == self:
		return
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
