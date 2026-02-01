extends Button

func _ready() -> void:
	self.pressed.connect(try_again)

func try_again() -> void:
	Global.try_again()
