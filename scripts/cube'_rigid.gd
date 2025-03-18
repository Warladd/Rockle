extends RigidBody2D

var gravity = -690
@export var death : Area2D
@export var detector : Area2D
@export var explode_detection : Area2D
@export var sprite : Sprite2D
@export var explode_sprite : Sprite2D
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
@export var parry_timer : Timer
@export var parry_start_timer : Timer
var gear_amount : int = 0
var touching_floor : bool = false

func _ready():
	detector.monitoring = false
	linear_velocity.y -= 200
	sfx_player.stream = load("res://assets/audio/sfx/pillar_and_cube_spawn.mp3")
	sfx_player.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if linear_velocity.x != 0 or grounded or linear_velocity.y < 0:
		parry_timer.stop()
		gravity_scale = 1
	elif !parry_timer.is_stopped():
		linear_velocity.y = 0
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
		if parry_timer.is_stopped():
			sprite.texture = load("res://assets/images/structures/cube_ungrounded.png")
		else:
			sprite.texture = load("res://assets/images/structures/cube_parry.png")
		
func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if body.get_parent().straight and straight_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/straight.mp3")
		sfx_player.play()
		parry_timer.stop()
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
		parry_timer.stop()
		linear_velocity.y -= 400
		modifiers.append("kick")
	elif structures.stomp and !grounded:
		sfx_player.stream = load("res://assets/audio/sfx/stomp.mp3")
		sfx_player.play()
		parry_timer.stop()
		grounded = true
		linear_velocity.y += 1000
		linear_velocity.x = 0
	elif structures.uppercut and uppercut_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/ungrounded_upper.mp3")
		sfx_player.play()
		parry_timer.stop()
		uppercut_timer.start()
		lock_rotation = false
		grounded = false
		linear_velocity.y = 0
		apply_impulse(Vector2(100,-300), Vector2(-50, 0))
		modifiers.append("uppercut")
	elif structures.parry and parry_timer.is_stopped() and parry_start_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/parry.mp3")
		sfx_player.play()
		linear_velocity.y = 0
		parry_start_timer.start()
	elif structures.explode:
		explode_sprite.show()
		modifiers.append("explode")
		
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
		linear_velocity.x = 0
		linear_velocity.y = 0
		gravity_scale = 0
		sprite.hide()
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
		Global.popup.emit()
		SaveSystem.saving()
		print("saving")
		explode_detection.monitoring = true
		await get_tree().create_timer(0.1).timeout
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
	#print("cubey")

func _on_area_2d_3_body_exited(body):
	if !body.name == "Floor":
		print("Body Name:", body.name)
		return
	touching_floor = false
	#print("no cubey")

func _on_area_2d_3_area_entered(area):
	if grounded or !area.name == "Floor" or touching_floor or !detector.monitoring:
		print("grounded:", grounded, "Area Name:", area.name, "Touching Floor:", touching_floor, "Detector Monitoring:", detector.monitoring)
		return
	touching_floor = true
	sfx_player.stream = load("res://assets/audio/sfx/cubey.mp3")
	sfx_player.play()
	#print("cubey")

func _on_area_2d_3_area_exited(area):
	if !area.name == "Floor":
		print("Area Name:", area.name)
		return
	touching_floor = false
	#print("no cubey")

func _on_parry_timer_timeout():
	print("cube parry done")
	gravity_scale = 1
	sprite.texture = load("res://assets/images/structures/cube_ungrounded.png")

func _on_parry_start_timer_timeout():
	print("cube parry started")
	grounded = false
	parry_timer.start()
	linear_velocity.x = 0
	gravity_scale = 0

func _on_area_2d_4_area_entered(area: Area2D) -> void:
	if area.get_parent() == self or area.get_parent().structure == "big_wall":
		return
	area.get_parent().grounded = false
