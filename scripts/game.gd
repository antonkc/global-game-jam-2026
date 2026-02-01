extends Node2D
class_name Game

@onready var animated_sprite_2d: AnimatedSprite2D = $Panel/AnimatedSprite2D
@onready var main_menu: Node2D = $Panel/main_menu
@onready var location: Location = $Panel/location

var running_game: GameState = null

func _ready() -> void:
	_fit_window()
	# TODO: load saved data from file

func load_new_game()->void:
	if running_game != null:
		running_game.free()
	running_game = GameState.new()
	_load_game()

func load_running_game()->void:
	_load_game()

func close_game()->void:
	# TODO: save file
	get_tree().quit(0)

func _load_game()->void:
	animated_sprite_2d.visible = false
	animated_sprite_2d.stop()
	animated_sprite_2d.hide()
	main_menu.hide()
	location.load(running_game)
	location.show()

func _fit_window():
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var game_size: Vector2i = DisplayServer.window_get_size()

	if screen_size[0] < game_size[0]:
		game_size[0] = screen_size[0]
	if screen_size[1] < game_size[1]:
		game_size[1] = screen_size[1]

	DisplayServer.window_set_size(game_size)
