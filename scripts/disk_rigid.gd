extends RigidBody2D

var structure = "disk"
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
var grounded : bool = false
var damage_value : int = 0
var stored_velocity_x : float = 0
var structures : Node2D
var modifiers : Array = []
var uppercutted : bool = false
var rotation_velocity: float = 0

func add_rotation_impulse(impulse: float):
	rotation_velocity += impulse

func _ready():
	detector.monitoring = false
	linear_velocity.y -= 700

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.rotate(rotation_velocity)
	
	var constant = 1
	var rotation_drag = rotation_velocity * rotation_velocity * constant
	rotation_velocity -= rotation_drag
	if linear_velocity.x > 0:
		damage_value = 1
	elif linear_velocity.x <= 0:
		damage_value = 0
	if grounded:
		sprite.texture = load("res://assets/structures/disk_grounded.png")
		if linear_velocity.x <= 0:
			damage_value = 1
		elif linear_velocity.x > 0:
			damage_value = 2
		if position.y <= -18:
			position.y = -18
			linear_velocity.y = 0
	elif !grounded:
		sprite.texture = load("res://assets/structures/disk_ungrounded.png")
	if linear_velocity.x > 0:
		linear_velocity.x -= 500 * delta
	elif linear_velocity.x < 0:
		linear_velocity.x = 0

func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if structures.straight:
		if linear_velocity.x > 0:
			return
		linear_velocity.x += 1400
		modifiers.append("straight")
	if structures.kick:
		grounded = false
		linear_velocity.y = 0
		linear_velocity.y -= 300
		modifiers.append("kick")
	if structures.uppercut:
		lock_rotation = false
		add_rotation_impulse(0.1)
		grounded = false
		linear_velocity.y = 0
		linear_velocity.y -= 200
		linear_velocity.x += 500
		modifiers.append("uppercut")
		
func _on_timer_timeout():
	detector.monitoring = true
	linear_velocity.y = 0
	collision.disabled = false

func _on_area_2d_2_area_entered(area):
	if linear_velocity.x > 0:
		stored_velocity_x = linear_velocity.x
	if area.get_parent() == self:
		return
	print("disk damage value", damage_value)
	print("other object damage value", area.get_parent().damage_value)
	if damage_value <= area.get_parent().damage_value:
		if modifiers.has("straight"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		if modifiers.has("kick"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 3
		if modifiers.has("uppercut"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 5
		SaveSystem.saving()
		print("saving")
	if damage_value >= area.get_parent().damage_value:
		area.get_parent().queue_free()
	if damage_value <= area.get_parent().damage_value:
		queue_free()
	linear_velocity.x = stored_velocity_x
	stored_velocity_x = 0
