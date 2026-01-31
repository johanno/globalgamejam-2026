extends Area2D

@export var mask_type: Global.TileColor

func _ready() -> void:
	self.body_entered.connect(check_player)

func _process(delta: float) -> void:
	var offset = Vector2(0, sin(Time.get_ticks_msec() / 500.0) * 5)
	$Sprite.transform = Transform2D(0, offset)

func check_player(body):
	if body is Player:
		body.collected_masks.append(mask_type)
		queue_free()
