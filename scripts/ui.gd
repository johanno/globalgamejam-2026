extends Control

@export var player: Player
const ALPHA_ON = 1.0
const ALPHA_OFF = 0.25

func _process(delta: float) -> void:
	%RedContainer.visible = player.collected_masks.has(Global.TileColor.RED)
	%GreenContainer.visible = player.collected_masks.has(Global.TileColor.GREEN)
	%BlueContainer.visible = player.collected_masks.has(Global.TileColor.BLUE)

	%RedMask.modulate.a = ALPHA_ON if player.active_masks.has(Global.TileColor.RED) else ALPHA_OFF
	%GreenMask.modulate.a = ALPHA_ON if player.active_masks.has(Global.TileColor.GREEN) else ALPHA_OFF
	%BlueMask.modulate.a = ALPHA_ON if player.active_masks.has(Global.TileColor.BLUE) else ALPHA_OFF
