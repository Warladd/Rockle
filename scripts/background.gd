extends ParallaxBackground

func _process(delta) -> void:
	scroll_offset.x += 40 * delta
