extends CharacterBody2D

var gravity = -300
var structure = "disk"
@export var structure_detector : Area2D
@export var world_detector : Area2D
@export var explode_detection : Area2D
@export var sprite : AnimatedSprite2D
@export var explode_sprite : Sprite2D
@export var collision : CollisionShape2D
@export var sfx_player : AudioStreamPlayer2D
@export var straight_timer : Timer
@export var kick_timer : Timer
@export var uppercut_timer : Timer
@export var parry_timer : Timer
@export var parry_start_timer : Timer
var grounded : bool = false
var damage_value : int = 0
var stored_velocity_x : float = 0
var structures : Node2D
var modifiers : Array = []
var uppercutted : bool = false
var gear_amount : int = 0
var dead : bool = false
var touching_floor : bool = false
var was_on_floor : bool = false

func _ready():
	sprite.animation = "ungrounded"
	world_detector.monitoring = false
	explode_detection.monitoring = false
	collision.disabled = true
	velocity.y -= 800

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x != 0 or grounded or velocity.y < 0:
		parry_timer.stop()
	elif !parry_timer.is_stopped():
		velocity.y = 0
	if dead:
		await sfx_player.finished
		queue_free()
	if velocity.x > 0:
		damage_value = 1
	elif velocity.x <= 0:
		damage_value = 0
	if grounded:
		sprite.animation = "grounded"
		if velocity.x <= 0:
			damage_value = 1
		elif velocity.x > 0:
			damage_value = 2
		if position.y <= -18:
			position.y = -18
			velocity.y = 0
	elif !grounded:
		sprite.animation = "ungrounded"
		if !parry_timer.is_stopped():
			sprite.animation = "parry"
	if !is_on_floor() and parry_timer.is_stopped():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 550 * delta
	elif velocity.x < 0:
		velocity.x = 0
	was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor != is_on_floor():
		if is_on_floor():
			sfx_player.stream = load("res://assets/audio/sfx/disky.mp3")
			sfx_player.play()

func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if structures.straight and straight_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/straight.mp3")
		sfx_player.play()
		straight_timer.start()
		velocity.x += 1500
		modifiers.append("straight")
	elif structures.kick and kick_timer.is_stopped():
		kick_timer.start()
		if grounded:
			sfx_player.stream = load("res://assets/audio/sfx/grounded_kick.mp3")
			sfx_player.play()
			grounded = false
		elif !grounded:
			sfx_player.stream = load("res://assets/audio/sfx/ungrounded_kick.mp3")
			sfx_player.play()
		velocity.y = 0
		velocity.y -= 300
		modifiers.append("kick")
	elif structures.stomp and !grounded:
		sfx_player.stream = load("res://assets/audio/sfx/stomp.mp3")
		sfx_player.play()
		grounded = true
		velocity.y += 1000
		velocity.x = 0
	elif structures.uppercut and uppercut_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/ungrounded_upper.mp3")
		sfx_player.play()
		uppercut_timer.start()
		grounded = false
		velocity.y = 0
		velocity.y -= 200
		velocity.x += 220
		modifiers.append("uppercut")
	elif structures.parry and parry_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/parry.mp3")
		sfx_player.play()
		velocity.y = 0
		parry_start_timer.start()
	elif structures.explode and !modifiers.has("explode"):
		explode_sprite.show()
		modifiers.append("explode")
		
func _on_timer_timeout():
	sfx_player.stream = load("res://assets/audio/sfx/disk_and_ball_spawn.mp3")
	sfx_player.play()
	world_detector.monitoring = true
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
		velocity.x = 0
		velocity.y = 0
		gravity = 0
		sprite.hide()
		Global.disk_break.emit()
		if modifiers.has("straight"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		if modifiers.has("kick"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		if modifiers.has("uppercut"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		if grounded:
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		if modifiers.has("explode"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			explode_detection.monitoring = true
		Global.popup_number = gear_amount
		Global.popup.emit()
		SaveSystem.saving()
		print("saving")
		await get_tree().create_timer(0.1).timeout
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0

func _on_area_2d_3_body_entered(body) -> void:
	if grounded or !body.name == "Floor" or touching_floor or !world_detector.monitoring:
		return
	touching_floor = true
	sfx_player.stream = load("res://assets/audio/sfx/disky.mp3")
	sfx_player.play()

func _on_area_2d_3_body_exited(body) -> void:
	if !body.name == "Floor":
		return
	touching_floor = false

func _on_parry_timer_timeout() -> void:
	sprite.animation = "ungrounded"

func _on_parry_start_timer_timeout() -> void:
	grounded = false
	parry_timer.start()
	velocity.x = 0

func _on_explode_area_entered(area : Area2D) -> void:
	if area.get_parent() == self or area.get_parent().structure == "big_wall":
		return
	area.get_parent().grounded = false
