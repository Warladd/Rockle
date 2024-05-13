extends CharacterBody2D

var gravity = -490
@export var death : Area2D
@export var detector : Area2D
var grounded : bool = false

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
		velocity.x -= 500 * delta
	elif velocity.x < 0:
		velocity.x = 0
	move_and_slide()

func _on_area_2d_body_entered(body):
	velocity.x += 1000

func _on_area_2d_2_body_entered(body):
	if body == self:
		return
	body.queue_free()

func _on_timer_timeout():
	death.monitoring = true
	detector.monitoring = true
	velocity.y = 0
