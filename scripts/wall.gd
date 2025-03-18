extends CharacterBody2D

var gravity = -690
var structure = "wall"
@export var death : Area2D
@export var detector : Area2D
@export var sprite : Sprite2D
@export var collision : CollisionShape2D
@export var sfx_player : AudioStreamPlayer2D
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
@export var parry_timer : Timer
@export var parry_start_timer : Timer
@export var explode_detector : Area2D

func _ready():
	detector.monitoring = false
	velocity.y -= 250
	sfx_player.stream = load("res://assets/audio/sfx/wall_spawn.mp3")
	sfx_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x != 0 or grounded or velocity.y < 0:
		#if velocity.y < 0:
			#print("movin")
		#if velocity.x != 0:
			#print("forward")
		#if grounded:
			#print("grounded")
		parry_timer.stop()
	if velocity.x > 0:
		damage_value = 4
	elif velocity.x <= 0:
		damage_value = 3
	if grounded:
		sprite.texture = load("res://assets/images/structures/wall_grounded.png")
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
		if parry_timer.is_stopped():
			sprite.texture = load("res://assets/images/structures/wall_ungrounded.png")
		else:
			sprite.texture = load("res://assets/images/structures/wall_parry.png")
	if !is_on_floor() and parry_timer.is_stopped():
		velocity.y -= gravity * delta
	if velocity.x > 0:
		velocity.x -= 850 * delta
	elif velocity.x < 0:
		velocity.x = 0
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor != is_on_floor():
		if is_on_floor():
			sfx_player.stream = load("res://assets/audio/sfx/wally.mp3")
			sfx_player.play()

func _on_area_2d_body_entered(body):
	structures = body.get_parent()
	if body.get_parent().straight and straight_timer.is_stopped():
		straight_timer.start()
		sfx_player.stream = load("res://assets/audio/sfx/straight.mp3")
		sfx_player.play()
		parry_timer.stop()
		velocity.x += 650
		modifiers.append("straight")
	elif body.get_parent().kick and kick_timer.is_stopped():
		kick_timer.start()
		parry_timer.stop()
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
		parry_timer.stop()
		velocity.y += 1000
		velocity.x = 0
	elif structures.uppercut and uppercut_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/ungrounded_upper.mp3")
		sfx_player.play()
		uppercut_timer.start()
		grounded = false
		parry_timer.stop()
		velocity.y = 0
		velocity.y -= 200
		velocity.x += 300
		modifiers.append("uppercut")
	elif structures.parry and parry_timer.is_stopped() and parry_start_timer.is_stopped():
		sfx_player.stream = load("res://assets/audio/sfx/parry.mp3")
		sfx_player.play()
		parry_start_timer.start()
		velocity.y = 0
	elif structures.explode and !modifiers.has("explode"):
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
		if modifiers.has("straight"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase
		if modifiers.has("kick"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 3
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 3
		if modifiers.has("uppercut"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 5
			gear_amount += SaveSystem.save_game.disk * SaveSystem.save_game.disk_increase * SaveSystem.save_game.general_increase * 5
		if grounded:
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.wall * SaveSystem.save_game.wall_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.wall * SaveSystem.save_game.wall_increase * SaveSystem.save_game.general_increase
		if modifiers.has("explode"):
			SaveSystem.save_game.gear_coins += SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase
			gear_amount += SaveSystem.save_game.pillar * SaveSystem.save_game.pillar_increase * SaveSystem.save_game.general_increase
			explode_detector.monitoring = true
		Global.popup_number = gear_amount
		Global.popup.emit()
		SaveSystem.saving()
		print("saving")
		queue_free()
	velocity.x = stored_velocity_x
	stored_velocity_x = 0

func _on_parry_start_timer_timeout():
	grounded = false
	sprite.texture = load("res://assets/images/structures/wall_parry.png")
	velocity.x = 0
	velocity.y = 0
	parry_timer.start()

func _on_explode_detector_area_entered(area: Area2D) -> void:
	if area.get_parent() == self or area.get_parent().structure == "big_wall":
		return
	area.get_parent().grounded = false
	area.get_parent().velocity.y -= damage_value * 100
	area.get_parent().velocity.x += damage_value * 120
