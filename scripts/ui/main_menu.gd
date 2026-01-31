extends Node

@onready var main: CanvasItem = $main
@onready var credits: CanvasItem = $credits
@onready var settings: CanvasItem = $settings

@onready var others = [
	credits,
	settings,
]

func _on_draw() -> void:
	for other in others:
		FocusHelper.set_focused(other, false)
	FocusHelper.set_focused(main, true)

func _on_hidden() -> void:
	pass # Replace with function body.
