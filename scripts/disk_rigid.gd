extends RigidBody2D

var structure = "disk"
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
@export var straight_timer : Timer
@export var kick_timer : Timer
@export var uppercut_timer : Timer
var grounded : bool = false
var damage_value : int = 0
var stored_velocity_x : float = 0
var structures : Node2D
var modifiers : Array = []
var uppercutted : bool = false
var gear_amount : int = 0

func _ready():
	detector.monitoring = false
	linear_velocity.y -= 700

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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

func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if structures.straight and straight_timer.is_stopped():
		straight_timer.start()
		linear_velocity.x += 1500
		modifiers.append("straight")
	elif structures.kick and kick_timer.is_stopped():
		kick_timer.start()
		grounded = false
		linear_velocity.y = 0
		linear_velocity.y -= 300
		modifiers.append("kick")
	elif structures.stomp and !grounded:
		grounded = true
		linear_velocity.y += 1000
		linear_velocity.x = 0
	elif structures.uppercut and uppercut_timer.is_stopped():
		uppercut_timer.start()
		lock_rotation = false
		grounded = false
		linear_velocity.y = 0
		apply_impulse(Vector2(15, -30), Vector2(10, 10))
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
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		if modifiers.has("kick"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		if modifiers.has("uppercut"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		Global.popup_number = gear_amount
		SaveSystem.saving()
		print("saving")
	if damage_value >= area.get_parent().damage_value:
		area.get_parent().queue_free()
	if damage_value <= area.get_parent().damage_value:
		queue_free()
	linear_velocity.x = stored_velocity_x
	stored_velocity_x = 0
