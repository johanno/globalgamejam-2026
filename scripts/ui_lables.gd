@tool
extends Label

# This script shows the current assigned key for each selected input map string

@export var action_name: String: set = set_action_name

func _ready() -> void:
    _update_text()
    if Engine.is_editor_hint():
        queue_redraw()

func _process(delta: float) -> void:
    _update_text()

func _validate_property(property: Dictionary) -> void:
    if property.name == "action_name" and Engine.is_editor_hint():
        property.hint = PROPERTY_HINT_ENUM
        var all_actions = get_input_actions()
        var actions = all_actions.filter(func(action: String): 
            return not (action.begins_with("ui_") or action.begins_with("spatial_editor")))
        property.hint_string = ",".join(actions)
        property.usage |= PROPERTY_USAGE_EDITOR

func get_input_actions():
    var actions = []
    for prop in ProjectSettings.get_property_list():
        if prop.name.begins_with("input/"):
            var name = prop.name
            actions.append(name.substr("input/".length()))
    return actions

func set_action_name(value: String) -> void:
    action_name = value
    _update_text()
    if Engine.is_editor_hint():
        property_list_changed.emit()

func _update_text() -> void:
    if InputMap.has_action(action_name):
        var events = InputMap.action_get_events(action_name)
        for event in events:
            if event is InputEventKey:
                text = event.as_text_physical_keycode()
                return
    text = "No key"
