extends CharacterBody2D

@export var move_delay: float = 2.0
@export var color: Global.TileColor
var modulate_color: Color = Color("red")
var tile_size: Vector2i # Size of one tile
var remaining_move_delay: float

@export var player: Player # Player

func map_tile_color_to_color(tileColor: Global.TileColor) -> Color:
	match tileColor:
		Global.TileColor.RED:
			return Color("red")
		Global.TileColor.GREEN:
			return Color("green")
		Global.TileColor.BLUE:
			return Color("blue")
		Global.TileColor.YELLOW:
			return Color("yellow")
		Global.TileColor.CYAN:
			return Color("cyan")
		Global.TileColor.MAGENTA:
			return Color("magenta")
		Global.TileColor.WHITE:
			return Color("lightGray")
	return Color("lightGray")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var white_map = %World/White
	tile_size = white_map.tile_set.tile_size
	$AnimatedSprite2D.modulate = map_tile_color_to_color(color)
	$AnimatedSprite2D.animation = "idle"

func _physics_process(delta: float) -> void:
	# TODO geht nicht
	#var collision = get_last_slide_collision()
	#if collision and collision.get_collider() == player:
	#	player.die()
	if color not in player.all_active_masks:
		hide()
		return
	else:
		show()
	
	# TODO change to more random
	var direction: Vector2i = (player.get_current_tile() - get_current_tile()).clampi(-1,1)
	if direction == Vector2i(0,0):
		player.die()

	velocity = Vector2.ZERO
	if remaining_move_delay > 0:
		remaining_move_delay -= delta
		return
	if player == null:
		return

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
	var player_masks = player.all_active_masks
	var current_tile = get_current_tile()
	var new_tile = current_tile + direction
	var all_layers: Array[TileMapLayer] = get_parent().get_tile_layers(player_masks)
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
