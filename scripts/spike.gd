extends Area2D

func _ready() -> void:
	self.body_entered.connect(check_player)

func check_player(body):
	if body is Player:
		get_tree().quit()
