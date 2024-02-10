extends Node3D

@export var startPos = Vector3.ZERO
@export var endPos = Vector3.ZERO

var started = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	endPos = $End.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started:
		time += delta
