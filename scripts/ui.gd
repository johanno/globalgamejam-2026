extends Control

@export var player: Player
const ALPHA_ON = 1.0
const ALPHA_OFF = 0.25

var should_glow = 0
var tween: Tween

func _ready() -> void:
    pass
func _process(delta: float) -> void:
    %RedContainer.visible = player.collected_masks.has(Global.TileColor.RED)
    %GreenContainer.visible = player.collected_masks.has(Global.TileColor.GREEN)
    %BlueContainer.visible = player.collected_masks.has(Global.TileColor.BLUE)

    %RedMask.modulate.a = ALPHA_ON if player.active_masks.has(Global.TileColor.RED) else ALPHA_OFF
    %GreenMask.modulate.a = ALPHA_ON if player.active_masks.has(Global.TileColor.GREEN) else ALPHA_OFF
    %BlueMask.modulate.a = ALPHA_ON if player.active_masks.has(Global.TileColor.BLUE) else ALPHA_OFF
    
    if get_tree().current_scene.scene_file_path == "res://scenes/level1.tscn" and should_glow == 0 and player.collected_masks.has(Global.TileColor.BLUE):
        should_glow = 1
            
    if should_glow == 1:
        should_glow = 2
        glow_on()
    if should_glow == 2 and player.active_masks.has(Global.TileColor.BLUE):
        should_glow = 3
        glow_off()
            
func glow_on() -> void:
    tween = create_tween()
    tween.set_loops()
    tween.tween_property(self, "modulate:a", 0.1, 0.5)
    tween.tween_property(self, "modulate:a", 2.0, 0.5)
    
func glow_off() -> void:
    if tween:
        tween.kill()
    tween = create_tween()
    tween.tween_property(self, "modulate:a", 1.0, 0.5)
