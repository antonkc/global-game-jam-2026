extends Node2D
class_name Location

@onready var target: CanvasItem = $target
@onready var dialog: Dialog = $Dialog

var current_location: Node2D = null

const locations: Dictionary[String, PackedScene] = {
	"tutorial": preload("res://scenes/locations/tutorial.tscn"),
	"atropello": preload("res://scenes/locations/atropello.tscn"),
	"caen_mascaras": preload("res://scenes/locations/caen_mascaras.tscn"),
	"post_atropello": preload("res://scenes/locations/post_atropello.tscn"),
	"policia": preload("res://scenes/locations/policia.tscn"),
	"puente": preload("res://scenes/locations/puente.tscn"),
	"casa_uno": preload("res://scenes/locations/casa_uno.tscn"),
	"habitacion": preload("res://scenes/locations/habitacion.tscn"),
	"supermercado": preload("res://scenes/locations/supermercado.tscn"),
	"restaurante": preload("res://scenes/locations/restaurante.tscn"),
	"casa_final": preload("res://scenes/locations/casa_final.tscn"),
	"hospital": preload("res://scenes/locations/hospital.tscn"),
}

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

func load_dialog(data: DialogData)->void:
	if game_state == null:
		printerr("tried to load dialog without game_state")
		return

	dialog.load_dialog(data, game_state.effects)

	target.hide()
	for n in target.get_children(): n.hide()
	dialog.show()

func end_dialog()->void:
	for n in target.get_children(): n.show()

func _load_location(loc_name: String):
	if !_is_valid_location(game_state.location):
		printerr("tried to load invalid location \"{name}\"".format({"name": loc_name}))
		return

	game_state.location = loc_name
	for n in target.get_children(): n.queue_free()
	
	var scene: PackedScene = locations[loc_name]
	if scene.can_instantiate():
		var instance: Node2D = scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		target.add_child(instance)
		current_location = instance
		instance.show()
		
		target.show()
		for n in target.get_children(): n.show()
		dialog.hide()
	else:
		printerr("could not instantiate scene for location")

func _is_valid_location(loc: String)->bool:
	for l in locations.keys():
		if loc == l:
			return true
	return false
