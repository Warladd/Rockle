extends CharacterBody2D

var gravity = -690
var structure = "cube"
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
var was_on_floor : bool = false

func _ready():
	detector.monitoring = false
	velocity.y -= 200
	sfx_player.stream = load("res://assets/audio/sfx/pillar_and_cube_spawn.mp3")
	sfx_player.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if velocity.x != 0 or grounded or velocity.y < 0:
		parry_timer.stop()
	elif !parry_timer.is_stopped():
		velocity.y = 0
	if velocity.x > 0:
		damage_value = 3
	elif velocity.x <= 0:
		damage_value = 2
	if grounded:
		sprite.texture = load("res://assets/images/structures/cube_grounded.png")
		if velocity.x <= 0:
			damage_value = 3
		elif velocity.x > 0:
			damage_value = 4
		if increase and position.y > 335:
			velocity.y = -360
		if position.y <= -335:
			position.y = 335
			velocity.y = 0
	elif !grounded:
		if parry_timer.is_stopped():
			sprite.texture = load("res://assets/images/structures/cube_ungrounded.png")
		else:
			sprite.texture = load("res://assets/images/structures/cube_parry.png")
	if !is_on_floor() and parry_timer.is_stopped():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 500 * delta
	elif velocity.x < 0:
		velocity.x += 500 * delta
	if velocity.x < 5 and velocity.x > -5:
		velocity.x = 0
	was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor != is_on_floor():
		if is_on_floor():
			sfx_player.stream = load("res://assets/audio/sfx/bally.mp3")
			sfx_player.play()
		
func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if body.get_parent().straight and straight_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/straight.mp3")
		sfx_player.play()
		parry_timer.stop()
		straight_timer.start()
		velocity.x += 750
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
		velocity.y -= 400
		modifiers.append("kick")
	elif structures.stomp and !grounded:
		sfx_player.stream = load("res://assets/audio/sfx/stomp.mp3")
		sfx_player.play()
		parry_timer.stop()
		grounded = true
		velocity.y += 1000
		velocity.x = 0
	elif structures.uppercut and uppercut_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/ungrounded_upper.mp3")
		sfx_player.play()
		parry_timer.stop()
		uppercut_timer.start()
		grounded = false
		velocity.y = 0
		velocity.y += 300
		velocity.x += 250
		modifiers.append("uppercut")
	elif structures.parry and parry_timer.is_stopped() and parry_start_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/parry.mp3")
		sfx_player.play()
		velocity.y = 0
		parry_start_timer.start()
	elif structures.explode and !modifiers.has("explode"):
		explode_sprite.show()
		modifiers.append("explode")
		
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
		Global.cube_break.emit()
		velocity.x = 0
		velocity.y = 0
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
		if modifiers.has("explode"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			explode_detection.monitoring = true
		Global.popup_number = gear_amount
		Global.popup.emit()
		SaveSystem.saving()
		print("saving")
		explode_detection.monitoring = true
		await get_tree().create_timer(0.05).timeout
		queue_free()
	velocity.x = stored_velocity_x
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
	sprite.texture = load("res://assets/images/structures/cube_ungrounded.png")

func _on_parry_start_timer_timeout():
	print("cube parry started")
	grounded = false
	parry_timer.start()
	velocity.x = 0

func _on_area_2d_4_area_entered(area: Area2D) -> void:
	if area.get_parent() == self or area.get_parent().structure == "big_wall":
		return
	area.get_parent().grounded = false
	if area.get_parent().global_position.x <= global_position.x:
		area.get_parent().velocity.x -= (damage_value * 150) + 200
	elif area.get_parent().global_position.x > global_position.x:
		area.get_parent().velocity.x += damage_value * 150
	if area.get_parent().global_position.y <= global_position.y:
		area.get_parent().velocity.y -= damage_value * 150
	elif area.get_parent().global_position.y > global_position.y:
		area.get_parent().velocity.y += damage_value * 150
