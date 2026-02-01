extends Node
class_name Location

@onready var target: Node = $target
var current_location: PackedScene = null

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

func load_location(loc_name: String)->void:
	if game_state == null:
		printerr("tried to load location without GameState")
		return
	_load_location(loc_name)

func add_effect(effect_name: String)->void:
	if game_state == null:
		printerr("tried to add effect without GameState")
		return

	match effect_name:
		"caso_or":
			game_state.effects.append("caso_1_or_caso2")

	game_state.effects.append(effect_name)

func _load_location(loc_name: String):
	if !_is_valid_location(game_state.location):
		printerr("tried to load invalid location \"{name}\"".format({"name": loc_name}))
		return

	game_state.location = name
	for n in target.get_children(): n.queue_free()

	var scene = load("res://scenes/locations/{name}.tscn".format({"name": loc_name}))
	target.add_child(scene)
	current_location = scene

func _is_valid_location(loc: String)->bool:
	for l in locations:
		if loc == l:
			return true
	return false
