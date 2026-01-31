extends Node2D

var initial_pos: Vector2

func _process(delta: float) -> void:
	var offset = Vector2(0, sin(Time.get_ticks_msec()) * 20)
	$Sprite.transform.position = offset