extends Area2D

@export var player: Player
@export var color: Global.TileColor

func _ready() -> void:
	$Sprite.modulate = Global.map_tile_color_to_color(color)

func _physics_process(delta: float) -> void:
	if color not in player.all_active_masks:
		hide()
		return
	else:
		show()

	for body in get_overlapping_bodies():
		if body is Player:
			body.die()
		elif body is Box:
			body.queue_free()
