class_name TileScene
extends Node

var all_tile_layers: Dictionary[Global.TileColor, TileMapLayer]

func _ready() -> void:
	all_tile_layers = {
		Global.TileColor.WHITE: %World/White,
		Global.TileColor.RED: %World/Red,
		Global.TileColor.BLUE: %World/Blue,
		Global.TileColor.GREEN: %World/Green,
		Global.TileColor.YELLOW: %World/Yellow,
		Global.TileColor.CYAN: %World/Cyan,
		Global.TileColor.MAGENTA: %World/Magenta,
	}

func update_tile_layers(active_masks: Array[Global.TileColor]) -> void:
	for layer in all_tile_layers.values():
		layer.enabled = false

	for mask in active_masks:
		all_tile_layers[mask].enabled = true

func get_tile_layers(active_masks: Array[Global.TileColor]) -> Array[TileMapLayer]:
	var tile_layers: Array[TileMapLayer] = []
	for mask in active_masks:
		tile_layers.append(all_tile_layers[mask])
	return tile_layers
