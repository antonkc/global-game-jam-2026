extends LocationBase

@onready var coordinator: Location = $".".find_parent("location")
@onready var animator: AnimationPlayer = $AnimationPlayer

var current_step: int = 0

func start()->void:
	next()

func next()->void:
	match current_step:
		0: _load_dialog("4-post_atropello")
		10: _opening()
		1: _load_dialog("2-atropello")
		2: _load_dialog("3-caen_mascaras")
		3: _load_dialog("4-post_atropello")
		4: _load_next_location()
		_:
			printerr("tried to continue in an exhausted location")

func _next_ev(_ev)->void:
	next()

func _opening()->void:
	animator.play("run_over")

	animator.animation_finished.connect(_next_ev, Object.CONNECT_ONE_SHOT)
	current_step+=1

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
