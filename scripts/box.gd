class_name Box
extends Area2D

@export var player: Player
@export var color: Global.TileColor
var tile_size: Vector2 # Size of one tile

func _ready() -> void:
	var white_map = %World/White
	tile_size = Vector2(white_map.tile_set.tile_size) * white_map.scale

	$Sprite.modulate = Global.map_tile_color_to_color(color)

func _physics_process(delta: float) -> void:
	if color not in player.all_active_masks:
		hide()
		return
	else:
		show()

	for body in get_overlapping_bodies():
		if body is Player:
			# Push box
			if not move_in_direction(body.last_move_direction):
				# Absoluter jank-Code, das sollte gleich beim Player Move abgefangen werden
				player.move_in_direction(-player.last_move_direction)
				player.last_move_direction = Vector2i.ZERO

func get_current_tile() -> Vector2i:
	# Current position is the pixel pos divided by the tile size. -0.5 is added to remove the center offset in the tile of the player
	return Vector2i(int(position.x / tile_size.x - 0.5), int(position.y / tile_size.y - 0.5))

func move_in_direction(direction: Vector2i) -> bool:
	var player_masks = player.all_active_masks
	var current_tile = get_current_tile()
	var new_tile = current_tile + direction
	var all_layers: Array[TileMapLayer] = %World.get_parent().get_tile_layers(player_masks)
	if all_layers.is_empty():
		return false
	var has_tile = false
	for layer in all_layers:
		var new_tile_data = layer.get_cell_tile_data(new_tile) as TileData
		if new_tile_data != null:
			has_tile = true
			if new_tile_data.get_collision_polygons_count(0) > 0:
				return false

	if not has_tile:
		return false

	var move = Vector2(direction) * tile_size
	position += Vector2(move.x, move.y)
	position.x -= fposmod(position.x - tile_size.x / 2.0, tile_size.x)
	position.y -= fposmod(position.y - tile_size.y / 2.0, tile_size.y)
	return true
