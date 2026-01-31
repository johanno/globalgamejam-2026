extends Node

enum TileColor { WHITE, RED, GREEN, BLUE, YELLOW, CYAN, MAGENTA }

func add_complementary_colors(colors: Array[TileColor]) -> Array[TileColor]:
	var copy = colors.duplicate()
	if copy.has(TileColor.RED) and copy.has(TileColor.GREEN):
		copy.append(TileColor.YELLOW)

	if copy.has(TileColor.GREEN) and copy.has(TileColor.BLUE):
		copy.append(TileColor.CYAN)

	if copy.has(TileColor.RED) and copy.has(TileColor.BLUE):
		copy.append(TileColor.MAGENTA)

	return copy
