extends Node

@onready var h_slider: HSlider = $HSlider

@export var bus_name: String = ""

func _ready() -> void:
	var idx: int = AudioServer.get_bus_index(bus_name)
	if idx == -1:
		printerr("tried to get bus with name \"${bus_name}\"".format({"bus_name": bus_name}))
		return

	var vol: float = AudioServer.get_bus_volume_linear(idx) * 100
	h_slider.set_value_no_signal(vol)

func _on_h_slider_value_changed(value: float) -> void:
	var idx: int = AudioServer.get_bus_index(bus_name)
	if idx == -1:
		printerr("tried to get bus with name \"${bus_name}\"".format({"bus_name": bus_name}))
		return

	AudioServer.set_bus_volume_linear(idx, value / 100)
