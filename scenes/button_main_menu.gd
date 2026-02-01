extends Button


func _ready() -> void:
	self.pressed.connect(try_again)

func try_again() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
