extends Area2D

func _ready() -> void:
	self.body_entered.connect(check_player)

func check_player(body):
	if body is Player:
		body.die()
	elif body is Box:
		body.queue_free()
