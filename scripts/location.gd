extends Node
class_name Location

@onready var target: Node = $target

const locations: Array[String] = [
	"tutorial",
	"atropello",
	"caen_mascaras",
	"post_atropello",
	"policia",
	"puente",
	"casa_uno",
	"habitacion",
	"supermercado",
	"restaurante",
	"casa_final",
	"hospital",
]

var game_state: GameState = null

func load(in_game_state: GameState)-> void:
	game_state = in_game_state
	_load_location(game_state.location)

func load_location(name: String)->void:
	if game_state == null:
		printerr("tried to load location without GameState")
		return
	_load_location(name)

func add_effect(name: String)->void:
	if game_state == null:
		printerr("tried to add effect without GameState")
		return

	match name:
		"caso_or":
			game_state.effects.append("caso_1_or_caso2")

	game_state.effects.append(name)

func _load_location(name: String):
	if !_is_valid_location(game_state.location):
		printerr("tried to load invalid location \"{name}\"")
		return

	game_state.location = name
	for n in target.get_children(): n.queue_free()

	# TODO: load location scene

func _is_valid_location(loc: String)->bool:
	for l in locations:
		if loc == l:
			return true
	return false
