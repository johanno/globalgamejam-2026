extends Node2D

var initial_pos: Vector2

func _process(delta: float) -> void:
	var offset = Vector2(0, sin(Time.get_ticks_msec() / 500.0) * 5)
	$Sprite.transform = Transform2D(0, offset)
