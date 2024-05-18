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
var modifiers : Array = []
var gear_amount : int = 0
@export var straight_timer : Timer
@export var kick_timer : Timer
@export var uppercut_timer : Timer

func _ready():
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
	if body.get_parent().straight and straight_timer.is_stopped():
		straight_timer.start()
		velocity.x += 800
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
	elif body.get_parent().uppercut and uppercut_timer.is_stopped():
		uppercut_timer.start()
		grounded = false
		velocity.y = 0
		velocity.y -= 200
		velocity.x += 300
		modifiers.append("uppercut")

func _on_timer_timeout():
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
		if modifiers.has("straight"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase
		if modifiers.has("kick"):
			SaveSystem.save_game.gear_coins += roundi(SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase * 1.5)
			gear_amount += roundi(SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase * 1.5)
		if modifiers.has("uppercut"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase * 2
			gear_amount += SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase * 2
		Global.popup_number = gear_amount
		SaveSystem.saving()
		print("saving")
	if damage_value >= area.get_parent().damage_value:
		area.get_parent().queue_free()
	if damage_value <= area.get_parent().damage_value:
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0
