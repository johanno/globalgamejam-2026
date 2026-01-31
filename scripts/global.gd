extends Node

enum TileColor { WHITE, RED, GREEN, BLUE, YELLOW, CYAN, MAGENTA }

func add_complementary_colors(colors: Array[TileColor]):
	if colors.has(TileColor.RED) and colors.has(TileColor.GREEN):
		colors.append(TileColor.YELLOW)

	if colors.has(TileColor.GREEN) and colors.has(TileColor.BLUE):
		colors.append(TileColor.CYAN)

	if colors.has(TileColor.RED) and colors.has(TileColor.BLUE):
		colors.append(TileColor.MAGENTA)
