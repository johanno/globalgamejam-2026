extends Control

@onready var option_menu: TabContainer = $"../Settings"

func _ready():
	$VBoxContainer/Start.grab_focus()

func reset_focus():
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed():
	AudioManager.play_music_sound()
	Global.load_first_level()

func _on_option_pressed():
	option_menu.show()
	option_menu.reset_focus()
	AudioManager.play_button_sound()
	
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_quit_pressed():
	get_tree().quit()
