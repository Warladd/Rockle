extends CharacterBody2D

var gravity = -690
var structure = "wall"
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
var damage_value : int = 3
var grounded : bool = true
var stored_velocity_x : float = 3
var increase : bool = true
var structures : Node2D
var modifiers : Array = []
var gear_amount : int = 0
@export var straight_timer : Timer
@export var kick_timer : Timer
@export var uppercut_timer : Timer

func _ready():
	detector.monitoring = false
	velocity.y -= 250

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x > 0:
		damage_value = 4
	elif velocity.x <= 0:
		damage_value = 3
	if grounded:
		sprite.texture = load("res://assets/structures/wall_grounded.png")
		if velocity.x <= 0:
			damage_value = 4
		elif velocity.x > 0:
			damage_value = 5
		if increase and position.y > 306:
			velocity.y = -250
		if position.y <= 306:
			position.y = 306
			velocity.y = 0
	elif !grounded:
		sprite.texture = load("res://assets/structures/wall_ungrounded.png")
	if !is_on_floor():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 850 * delta
	elif velocity.x < 0:
		velocity.x = 0
	move_and_slide()

func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if body.get_parent().straight and straight_timer.is_stopped():
		straight_timer.start()
		velocity.x += 650
		modifiers.append("straight")
	elif body.get_parent().kick and kick_timer.is_stopped():
		kick_timer.start()
		grounded = false
		velocity.y = 0
		velocity.y -= 300
		modifiers.append("kick")
	elif structures.stomp and !grounded:
		grounded = true
		velocity.y += 300
		velocity.x = 0
	elif structures.uppercut and uppercut_timer.is_stopped():
		uppercut_timer.start()
		grounded = false
		velocity.y = 0
		velocity.y -= 200
		velocity.x += 300
		modifiers.append("uppercut")

func _on_timer_timeout():
	detector.monitoring = true
	velocity.y = 0
	collision.disabled = false
	increase = false

func _on_area_2d_2_area_entered(area):
	if velocity.x > 0:
		stored_velocity_x = velocity.x
	if area.get_parent() == self:
		return
	print("cube damage value", damage_value)
	print("other object damage value", area.get_parent().damage_value)
	if damage_value <= area.get_parent().damage_value:
		if modifiers.has("straight"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		if modifiers.has("kick"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 3
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 3
		if modifiers.has("uppercut"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 5
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 5
		Global.popup_number = gear_amount
		SaveSystem.saving()
		print("saving")
	if damage_value >= area.get_parent().damage_value:
		area.get_parent().queue_free()
	if damage_value <= area.get_parent().damage_value:
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0
