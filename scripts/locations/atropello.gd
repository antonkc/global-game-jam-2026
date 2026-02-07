extends LocationBase

@onready var coordinator: Location = $".".find_parent("location")
@onready var animator: AnimationPlayer = $AnimationPlayer

func start()->void:
	animator.play("run_over")
	
	animator.animation_finished.connect(_load_dialog_1, Object.CONNECT_ONE_SHOT)

func next()->void:
	#animator.play(next animation?)
	#coordinator.load_location(next location?)
	pass

func _load_dialog_1(_ev)->void:
	if coordinator != null:
		var dial: DialogData = DataLoader.load_dialog("2-atropello")
		coordinator.load_dialog(dial)
