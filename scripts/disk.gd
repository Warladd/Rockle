extends CharacterBody2D

var gravity = -300
var structure = "disk"
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
var grounded : bool = false
var damage_value : int = 0
var stored_velocity_x : float = 0
var structures : Node2D

func _ready():
	detector.monitoring = false
	velocity.y -= 800

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x > 0:
		damage_value = 1
	elif velocity.x <= 0:
		damage_value = 0
	if grounded:
		sprite.texture = load("res://assets/structures/disk_grounded.png")
		if velocity.x <= 0:
			damage_value = 1
		elif velocity.x > 0:
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
	structures = body.get_parent()
	if structures.straight:
		if velocity.x > 0:
			return
		velocity.x += 1000
	elif structures.kick:
		grounded = false
		velocity.y -= 300
		
func _on_timer_timeout():
	detector.monitoring = true
	velocity.y = 0
	collision.disabled = false

func _on_area_2d_2_area_entered(area):
	if velocity.x > 0:
		stored_velocity_x = velocity.x
	if area.get_parent() == self:
		return
	print("disk damage value", damage_value)
	print("other object damage value", area.get_parent().damage_value)
	if damage_value <= area.get_parent().damage_value:
		if structures.straight:
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		elif structures.kick:
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 3
		SaveSystem.saving()
		print("saving")
	if damage_value >= area.get_parent().damage_value:
		area.get_parent().queue_free()
	if damage_value <= area.get_parent().damage_value:
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0
