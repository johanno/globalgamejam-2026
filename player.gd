extends CharacterBody2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var tile_size: Vector2i # Size of one tile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile_map = get_tree().root.get_node("TileScene/TileMapLayer") as TileMapLayer
	tile_size = tile_map.tile_set.tile_size
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("quit_game"):
		get_tree().quit()
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		pass
		$AnimatedSprite2D.stop()
		
	#position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	var collision = move_and_slide()
	if velocity.x != 0:
		pass
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		pass
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
