extends LocationBase

@onready var start_theatre: Control = $"."

@onready var coordinator: Location = $".".find_parent("location")
@onready var animator: AnimationPlayer = $animations

var input_ready = true
var current_step: int = 0
var happenings: Array[Callable] = [
	_shufling_out,
	_load_dialog.bind("1-comienzo"),
	_set_exploring_1,
	_load_dialog.bind("2-calle_familiar"),
	_set_exploring_2,
	_load_runover,
	_load_dialog.bind("3-atropello"),
	_set_exploring_3,
	_load_dialog.bind("4-caen_mascaras"),
	_set_exploring_4,
	_load_dialog.bind("5-post_atropello"),
	_load_next_location,
]

func start()->void:
	next()
func next()->void:
	if input_ready:
		input_ready = false
		_reset_overlay(func done():
			input_ready = true
			if current_step < len(happenings):
				happenings[current_step].call()
			else:
				printerr("tried to continue in an exhausted location")
				_load_next_location()
	)

const turn_off_duration = 0.5
@onready var stars = ($location_overlay/stars).get_children()
func _reset_overlay(callback: Callable)->void:
	var is_first_tween = true
	for star_i in range(len(stars)):
		var star = stars[star_i]
		if star.visible:
			var tweener = create_tween()
			var prop: PropertyTweener = tweener.tween_property(star, "modulate", Color(1, 1, 1, 0), turn_off_duration).from(Color(1, 1, 1, 1))
			if is_first_tween:
				is_first_tween = false
				prop.finished.connect(callback)
	if is_first_tween:
		callback.call()

func _shufling_out()->void:
	animator.play(&"shufle_out")
	animator.animation_finished.connect(next, Object.CONNECT_ONE_SHOT)

func _set_exploring_1()->void:
	_show_star_thought_pair("my_thoughts", "my_thoughts")
	_show_star_thought_pair("huge_guy", "huge_guy")

func _set_exploring_2()->void:
	_show_star_thought_pair("grandma", "grandma")
	_show_star_thought_pair("familiar_street", "familiar_street")

func _load_runover() -> void:
	animator.play("run_over")
	animator.animation_finished.connect(next, Object.CONNECT_ONE_SHOT)

func _set_exploring_3()->void:
	pass

func _set_exploring_4()->void:
	pass

func _load_dialog(dialog_name: String)->void:
	if coordinator == null:
		printerr("tried to load dialog without coordinator")
		return
	current_step+=1
	var dial: DialogData = DataLoader.load_dialog(dialog_name)
	coordinator.load_dialog(dial)

func _load_next_location()->void:
	if coordinator == null:
		printerr("tried to load next location without coordinator")
		return
	current_step+=1

	coordinator._load_location("puente")

func _show_star_thought_pair(star_name: StringName, thought_name: StringName)->void:
	var star = ($location_overlay/stars).find_child(star_name, false)
	var thought = ($location_overlay/thoughts).find_child(thought_name, false)
	star.visible = true
	star.action = func():
		thought.visible = true
