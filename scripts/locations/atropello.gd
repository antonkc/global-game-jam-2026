extends Node2D

@onready var coche_crash: AnimatedSprite2D = $coche_crash
@onready var abuela: AnimatedSprite2D = $abuela
@onready var abuela_falling: AnimatedSprite2D = $abuela_falling
@onready var abuela_crash: AnimatedSprite2D = $abuela_crash
@onready var policia_2: AnimatedSprite2D = $policia2

var timer := 0.0
var en_escena := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Mueve el sprite en el eje x
	coche_crash.position.x += coche_crash.speed		# avanzar en el eje x
	coche_crash.position.y = 750		# posición en el eje y
	abuela.position.x = 890
	abuela.position.y = 780
	if coche_crash.position.x == 560:
		coche_crash.speed = 0.0
		timer += delta
		if timer >= 0.3:
			abuela.visible = false
		if timer >= 0.8 && timer < 1.3:
			abuela_falling.visible = true
		if timer >= 1.3 && timer < 1.8:
			abuela_falling.visible = false
			abuela_crash.visible = true
		if timer >= 2.0:
			coche_crash.speed = 15.0
	
