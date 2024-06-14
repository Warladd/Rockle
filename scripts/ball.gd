extends CharacterBody2D

var gravity = -400
var structure = "ball"
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
@export var sfx_player : AudioStreamPlayer2D
var grounded : bool = false
var damage_value : int = 1
var stored_velocity_x : float = 0
var structures : Node2D
var modifiers : Array = []
var gear_amount : int = 0
@export var straight_timer : Timer
@export var kick_timer : Timer
@export var uppercut_timer : Timer
@export var parry_timer : Timer
@export var parry_start_timer : Timer
var was_on_floor : bool = false
var area_left : bool = true

func _ready():
	detector.monitoring = false
	velocity.y -= 650
	sfx_player.stream = load("res://assets/audio/sfx/disk_and_ball_spawn.mp3")
	sfx_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !parry_timer.is_stopped():
		print("timer running")
	if velocity.x != 0 or grounded or velocity.y < 0:
		#if velocity.y < 0:
			#print("movin")
		#if velocity.x != 0:
			#print("forward")
		#if grounded:
			#print("grounded")
		parry_timer.stop()
	if velocity.x > 0:
		damage_value = 2
	elif velocity.x <= 0:
		damage_value = 1
	if grounded:
		sprite.texture = load("res://assets/images/structures/ball_grounded.png")
		if velocity.x <= 0:
			damage_value = 2
		elif velocity.x > 0:
			damage_value = 3
		if position.y <= -28:
			position.y = -28
			velocity.y = 0
	elif !grounded:
		if !parry_timer.is_stopped():
			sprite.texture = load("res://assets/images/structures/ball_parry.png")
		else:
			sprite.texture = load("res://assets/images/structures/ball_ungrounded.png")
	if !is_on_floor() and parry_timer.is_stopped():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 650 * delta
	elif velocity.x < 0:
		velocity.x = 0
	was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor != is_on_floor():
		if is_on_floor():
			sfx_player.stream = load("res://assets/audio/sfx/bally.mp3")
			sfx_player.play()

func _on_area_2d_body_entered(body):
	area_left = false
	structures = body.get_parent()
	if body.get_parent().straight and straight_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/straight.mp3")
		sfx_player.play()
		straight_timer.start()
		velocity.x += 800
		modifiers.append("straight")
	elif body.get_parent().kick and kick_timer.is_stopped():
		kick_timer.start()
		if grounded:
			sfx_player.stream = load("res://assets/audio/sfx/grounded_kick.mp3")
			sfx_player.play()
			grounded = false
		elif !grounded:
			sfx_player.stream = load("res://assets/audio/sfx/ungrounded_kick.mp3")
			sfx_player.play()
		grounded = false
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
		velocity.x += 300
		modifiers.append("uppercut")
	elif structures.parry and parry_timer.is_stopped() and parry_start_timer.is_stopped():
		parry_start_timer.start()
		print("parry recognized")
		sfx_player.stream = load("res://assets/audio/sfx/parry.mp3")
		sfx_player.play()
		velocity.y = 0
		
func _on_timer_timeout():
	detector.monitoring = true
	velocity.y = 0
	collision.disabled = false

func _on_area_2d_2_area_entered(area):
	if velocity.x > 0:
		stored_velocity_x = velocity.x
	if area.get_parent() == self:
		return
	print("ball damage value", damage_value)
	print("other object damage value", area.get_parent().damage_value)
	if damage_value <= area.get_parent().damage_value:
		Global.ball_break.emit()
		if modifiers.has("straight"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase
		if modifiers.has("kick"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase * 2
			gear_amount += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase * 2
		if modifiers.has("uppercut"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase * 3
			gear_amount += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase * 3
		if grounded:
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.ball * SaveSystem.save_game.ball_increase * SaveSystem.save_game.general_increase
		Global.popup_number = gear_amount
		Global.popup.emit()
		SaveSystem.saving()
		print("saving")
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0

func _on_parry_start_timer_timeout():
	if area_left:
		print("Not in area")
		return
	print("ball parry started")
	parry_timer.start()
	sprite.texture = load("res://assets/images/structures/ball_parry.png")
	grounded = false
	velocity.x = 0

func _on_area_2d_body_exited(body):
	area_left = true

func _on_parry_timer_timeout():
	print("ball parry done")
