extends Label
var tween : Tween = create_tween()

func _ready() -> void:
	text = "+" + str(Global.popup_number)

func _on_timer_timeout():
	tween = create_tween()
	tween.tween_property(self, "modulate", Color("ffffff00"), 0.5)
	await tween.finished
	queue_free()
