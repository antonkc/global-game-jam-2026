extends Control

@onready var root: CanvasItem = $"."
@onready var main: CanvasItem = $main
@onready var credits: CanvasItem = $credits
@onready var settings: CanvasItem = $settings

@onready var menus = [
	main,
	credits,
	settings,
]

func _ready() -> void:
	var butt_play: CustomButton = $main/margin/rows/butt_play
	butt_play.action = _play
	var butt_settings: CustomButton = $main/margin/rows/butt_settings
	butt_settings.action = _settings
	var butt_credits: CustomButton = $main/margin/rows/butt_credits
	butt_credits.action = _credits
	var butt_quit: CustomButton = $main/margin/rows/butt_quit
	butt_quit.action = _quit

	var butt_c_back: CustomButton = $credits/butt_c_back
	butt_c_back.action = _back_to_main
	var butt_s_back: CustomButton = $settings/butt_s_back
	butt_s_back.action = _back_to_main

func _play() -> void:
	var parent: Game = root.find_parent("Game")
	if parent == null:
		printerr("tried to create game without Game root node")
		return
	parent.load_new_game()
func _settings() -> void:
	main.hide()
	settings.show()
func _credits() -> void:
	main.hide()
	credits.show()
func _quit() -> void:
	var parent: Game = root.find_parent("Game")
	if parent == null:
		get_tree().quit(0)
		return
	parent.close_game()

func _back_to_main() -> void:
	credits.hide()
	settings.hide()
	main.show()
