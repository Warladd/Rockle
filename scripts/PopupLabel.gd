extends Label
var tween : Tween

func _ready() -> void:
	var gear_coin_string = str(Global.popup_number)
	for i in range(int((len(gear_coin_string) - 1) /3)):
		gear_coin_string = gear_coin_string.insert(len(gear_coin_string) - 4 * (i) - 3, ",")
	text = "+" + gear_coin_string

func _on_timer_timeout():
	tween = create_tween()
	tween.tween_property(self, "modulate", Color("ffffff00"), 0.5)
	await tween.finished
	queue_free()
