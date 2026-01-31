extends Node

@onready var main: CanvasItem = $"../../main"
@onready var credits: CanvasItem = $"../../credits"
@onready var settings: CanvasItem = $"../../settings"

@export var input_names: Array[String] = []
@export var is_input_focused: bool = false
var mouse_on: bool = false

@onready var others = [
	main,
	settings,
]

func action()->void:
	for other in others:
		FocusHelper.set_focused(other, false)
	FocusHelper.set_focused(credits, true)

func _input(event: InputEvent) -> void:
	if !is_input_focused:
		return
	if event is InputEventMouseButton && mouse_on && event.is_action_released("click", true):
		action()
	for input_name in input_names:
		if event.is_action(input_name, true):
			action()

func _on_mouse_entered():
	mouse_on = true

func _on_mouse_exited():
	mouse_on = false
