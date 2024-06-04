extends Node2D
@export var anim_player : AnimationPlayer
@export var enter_label : Label
@export var crtv : AnimatedSprite2D
@onready var sprite : AnimatedSprite2D = $Sprite
var progress : String = "Beginning"

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("beginning")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter"):
		match progress:
			"Beginning":
				enter_label.hide()
				anim_player.play("static")
				crtv.play("static")
				await anim_player.animation_finished
				enter_label.show()
				anim_player.play("structures")
				progress = "Structures"
			"Structures":
				enter_label.hide()
				anim_player.play("static")
				crtv.play("static")
				await anim_player.animation_finished
				enter_label.show()
				anim_player.play("moving vs not moving")
				sprite.play("move_v_not_move")
				progress = "Moving"
			"Moving":
				enter_label.hide()
				anim_player.play("static")
				crtv.play("static")
				await anim_player.animation_finished
				enter_label.show()
				anim_player.play("grounded vs ungrounded")
				progress = "Grounded"
			"Grounded":
				enter_label.hide()
				anim_player.play("static")
				crtv.play("static")
				await anim_player.animation_finished
				enter_label.show()
				anim_player.play("big vs small")
				sprite.play("biggest_v_smallest")
				progress = "Big"
			"Big":
				enter_label.hide()
				anim_player.play("static")
				crtv.play("static")
				await anim_player.animation_finished
				enter_label.show()
				anim_player.play("multipliers")
				progress = "Milestones"
			"Milestones":
				enter_label.hide()
				anim_player.play("static")
				crtv.play("static")
				await anim_player.animation_finished
				enter_label.show()
				anim_player.play("combos")
				sprite.play("combos")
				progress = "Combos"
			"Combos":
				enter_label.hide()
				anim_player.play("static")
				crtv.play("static")
				await anim_player.animation_finished
				enter_label.show()
				anim_player.play("ending")
				progress = "Ended"
			"Ended":
				SaveSystem.save_game.tutorial = false
				get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
