extends CharacterBody2D

@export var move_delay: float = 2.0
var tile_size: Vector2i # Size of one tile
var remaining_move_delay: float

@export var playerClass: Player # Player
var active_masks: Array[Global.TileColor] = [Global.TileColor.WHITE]
var all_active_masks: Array[Global.TileColor] = [] # Absolut jank

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var white_map = %World/White
	tile_size = white_map.tile_set.tile_size
	all_active_masks = Global.add_complementary_colors(active_masks)

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if remaining_move_delay > 0:
		remaining_move_delay -= delta
		return
	# TODO change to more random
	var direction: Vector2i = (playerClass.get_current_tile() - get_current_tile()).clampi(-1,1)
	if direction.x != 0 and direction.y != 0:
		if randi_range(0,1) == 0:
			direction.x = 0
		else: 
			direction.y = 0
	var moved = move_in_direction(direction)

	if direction.length() > 0:
		remaining_move_delay = move_delay

		if moved:
			$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "move"
	else:
		$AnimatedSprite2D.animation = "idle"

func get_current_tile() -> Vector2i:
	# Current position is the pixel pos divided by the tile size. -0.5 is added to remove the center offset in the tile of the player
	return Vector2i(int(position.x / tile_size.x - 0.5), int(position.y / tile_size.y - 0.5))


func move_in_direction(direction: Vector2i) -> bool:
	var player_masks = playerClass.all_active_masks
	print(direction)
	var current_tile = get_current_tile()
	var new_tile = current_tile + direction
	var all_layers: Array[TileMapLayer] = get_parent().get_tile_layers(player_masks)
	print(all_layers)
	print(player_masks)
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

	var move = direction * tile_size
	position += Vector2(move.x, move.y)
	position.x -= fposmod(position.x - tile_size.x / 2.0, tile_size.x)
	position.y -= fposmod(position.y - tile_size.y / 2.0, tile_size.y)
	return true
