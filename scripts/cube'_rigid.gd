extends RigidBody2D

var gravity = -690
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
@export var sfx_player : AudioStreamPlayer2D
var damage_value : int = 2
var grounded : bool = true
var stored_velocity_x : float = 3
var increase : bool = true
var structures : Node2D
var modifiers : Array = []
var rotation_velocity: float = 0
@export var straight_timer : Timer
@export var kick_timer : Timer
@export var uppercut_timer : Timer
var gear_amount : int = 0
var touching_floor : bool = false

func _ready():
	detector.monitoring = false
	linear_velocity.y -= 200
	sfx_player.stream = load("res://assets/audio/sfx/pillar_and_cube_spawn.mp3")
	sfx_player.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if linear_velocity.x > 0:
		damage_value = 3
	elif linear_velocity.x <= 0:
		damage_value = 2
	if grounded:
		sprite.texture = load("res://assets/images/structures/cube_grounded.png")
		if linear_velocity.x <= 0:
			damage_value = 3
		elif linear_velocity.x > 0:
			damage_value = 4
		if increase and position.y > 335:
			linear_velocity.y = -360
		if position.y <= -335:
			position.y = 335
			linear_velocity.y = 0
	elif !grounded:
		sprite.texture = load("res://assets/images/structures/cube_ungrounded.png")
		
func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if body.get_parent().straight and straight_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/straight.mp3")
		sfx_player.play()
		straight_timer.start()
		linear_velocity.x += 750
		modifiers.append("straight")
	elif body.get_parent().kick and kick_timer.is_stopped():
		if grounded:
			sfx_player.stream = load("res://assets/audio/sfx/grounded_kick.mp3")
			sfx_player.play()
			grounded = false
		elif !grounded:
			sfx_player.stream = load("res://assets/audio/sfx/ungrounded_kick.mp3")
			sfx_player.play()
		kick_timer.start()
		linear_velocity.y -= 400
		modifiers.append("kick")
	elif structures.stomp and !grounded:
		sfx_player.stream = load("res://assets/audio/sfx/stomp.mp3")
		sfx_player.play()
		grounded = true
		linear_velocity.y += 1000
		linear_velocity.x = 0
	elif structures.uppercut and uppercut_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/ungrounded_upper.mp3")
		sfx_player.play()
		uppercut_timer.start()
		lock_rotation = false
		grounded = false
		linear_velocity.y = 0
		apply_impulse(Vector2(100,-300), Vector2(-50, 0))
		modifiers.append("uppercut")

func _on_timer_timeout():
	detector.monitoring = true
	linear_velocity.y = 0
	collision.disabled = false
	increase = false

func _on_area_2d_2_area_entered(area):
	if linear_velocity.x > 0:
		stored_velocity_x = linear_velocity.x
	if area.get_parent() == self:
		return
	print("cube damage value", damage_value)
	print("other object damage value", area.get_parent().damage_value)
	if damage_value <= area.get_parent().damage_value:
		Global.cube_break.emit()
		if modifiers.has("straight"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.cube * SaveSystem.save_game.cube_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.cube * SaveSystem.save_game.cube_increase * SaveSystem.save_game.general_increase
		if modifiers.has("kick"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.cube * SaveSystem.save_game.cube_increase * SaveSystem.save_game.general_increase * 3
			gear_amount += SaveSystem.save_game.cube * SaveSystem.save_game.cube_increase * SaveSystem.save_game.general_increase * 3
		if modifiers.has("uppercut"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.cube * SaveSystem.save_game.cube_increase * SaveSystem.save_game.general_increase * 5
			gear_amount += SaveSystem.save_game.cube * SaveSystem.save_game.cube_increase * SaveSystem.save_game.general_increase * 5
		if grounded:
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.cube * SaveSystem.save_game.cube_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.cube * SaveSystem.save_game.cube_increase * SaveSystem.save_game.general_increase	
		Global.popup_number = gear_amount
		SaveSystem.saving()
		print("saving")
		queue_free()
	linear_velocity.x = stored_velocity_x
	stored_velocity_x = 0

func _on_area_2d_3_body_entered(body):
	if grounded or !body.name == "Floor" or touching_floor or !detector.monitoring:
		print("grounded:", grounded, "Body Name:", body.name, "Touching Floor:", touching_floor, "Detector Monitoring:", detector.monitoring)
		return
	touching_floor = true
	sfx_player.stream = load("res://assets/audio/sfx/cubey.mp3")
	sfx_player.play()
	print("cubey")

func _on_area_2d_3_body_exited(body):
	if !body.name == "Floor":
		print("Body Name:", body.name)
		return
	touching_floor = false
	print("no cubey")

func _on_area_2d_3_area_entered(area):
	if grounded or !area.name == "Floor" or touching_floor or !detector.monitoring:
		print("grounded:", grounded, "Area Name:", area.name, "Touching Floor:", touching_floor, "Detector Monitoring:", detector.monitoring)
		return
	touching_floor = true
	sfx_player.stream = load("res://assets/audio/sfx/cubey.mp3")
	sfx_player.play()
	print("cubey")

func _on_area_2d_3_area_exited(area):
	if !area.name == "Floor":
		print("Area Name:", area.name)
		return
	touching_floor = false
	print("no cubey")
