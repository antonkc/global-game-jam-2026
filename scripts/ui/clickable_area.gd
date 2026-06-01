class_name ClickableArea
extends Control

@export var input_bind: StringName = ""
@export var is_hovering: bool = false
@export var disabled: bool = false

var _is_clickable: bool = false

func click_action() -> void:
	pass
func hover_action() -> void: # Remember to call hover_end action if needed
	pass
func hover_end_action() -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if disabled or not _is_clickable:
		return
	if !event.is_action_released(&"click", true):
		return
	if not self.has_focus():
		return
	click_action()
func _input(event: InputEvent) -> void:
	if disabled or input_bind == &"" or not _is_clickable:
		return
	if event.is_action_released(input_bind, true):
		click_action()
func _on_mouse_entered() -> void:
	is_hovering=true
	hover_action()
func _on_mouse_exited() -> void:
	is_hovering=false
	hover_end_action()
func _on_visibility_changed() -> void:
	_is_clickable = is_visible_in_tree()
