extends CharacterBody2D

@export var move_delay = 0.25
var tile_size: Vector2i # Size of one tile
var remaining_move_delay: float

@export var active_masks: Array[Global.TileColor] = [Global.TileColor.WHITE]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.add_complementary_colors(active_masks)

	var white_map = %World/White
	print(white_map)
	tile_size = white_map.tile_set.tile_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_parent().update_tile_layers(active_masks)

	velocity = Vector2.ZERO

	if Input.is_action_pressed("quit_game"):
		get_tree().quit()

	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down"):
		remaining_move_delay = 0

	if remaining_move_delay > 0:
		remaining_move_delay -= delta
		return

	var direction = Vector2i.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	elif Input.is_action_pressed("move_left"):
		direction.x -= 1
	elif Input.is_action_pressed("move_down"):
		direction.y += 1
	elif Input.is_action_pressed("move_up"):
		direction.y -= 1

	var moved = move_in_direction(direction)

	if direction.length() > 0:
		remaining_move_delay = move_delay

		if moved:
			$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()


	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func get_current_tile() -> Vector2i:
	# Current position is the pixel pos divided by the tile size. -0.5 is added to remove the center offset in the tile of the player
	return Vector2i(int(position.x / tile_size.x - 0.5), int(position.y / tile_size.y - 0.5))

func move_in_direction(direction: Vector2i) -> bool:
	var current_tile = get_current_tile()
	var new_tile = current_tile + direction

	var has_tile = false
	for layer in get_parent().get_tile_layers(active_masks):
		var new_tile_data = layer.get_cell_tile_data(new_tile) as TileData
		if new_tile_data != null:
			has_tile = true
			if new_tile_data.get_collision_polygons_count(0) > 0:
				return false

	if not has_tile:
		get_tree().quit()

	var move = direction * tile_size
	position += Vector2(move.x, move.y)
	position.x -= fposmod(position.x - tile_size.x / 2.0, tile_size.x)
	position.y -= fposmod(position.y - tile_size.y / 2.0, tile_size.y)
	return true
