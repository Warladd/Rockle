extends CharacterBody2D

var gravity = -490
@export var death : Area2D
@export var detector : Area2D
var grounded : bool = true

func _ready():
	death.monitoring = false
	detector.monitoring = false
	velocity.y -= 620

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grounded:
		velocity.y = 0
	if !is_on_floor():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 700 * delta
	elif velocity.x < 0:
		velocity.x = 0
	move_and_slide()

func _on_area_2d_body_entered(body):
	if velocity.x > 0:
		return
	velocity.x += 600

func _on_area_2d_2_body_entered(body):
	if body == self:
		return
	queue_free()

func _on_timer_timeout():
	death.monitoring = true
	detector.monitoring = true
	velocity.y = 0
