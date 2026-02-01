extends Node

enum TileColor { WHITE, RED, GREEN, BLUE, YELLOW, CYAN, MAGENTA }

var levels: Array[PackedScene] = [
	preload("res://scenes/tile_scene.tscn"),
	preload("res://scenes/level3.tscn")
]

var current_level: int

func load_first_level():
	get_tree().change_scene_to_packed(levels[0])

func add_complementary_colors(colors: Array[TileColor]) -> Array[TileColor]:
	var copy = colors.duplicate()
	if copy.has(TileColor.RED) and copy.has(TileColor.GREEN):
		copy.append(TileColor.YELLOW)

	if copy.has(TileColor.GREEN) and copy.has(TileColor.BLUE):
		copy.append(TileColor.CYAN)

	if copy.has(TileColor.RED) and copy.has(TileColor.BLUE):
		copy.append(TileColor.MAGENTA)

	return copy

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

func try_again():
	get_tree().change_scene_to_packed(levels[current_level])

func next_level():
	current_level += 1
	if current_level >= len(levels):
		# GG
		get_tree().quit()
		return

	get_tree().change_scene_to_packed(levels[current_level])
