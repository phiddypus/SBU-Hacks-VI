extends Node3D

@export var startPos = Vector3.ZERO
@export var endPos = Vector3.ZERO

var started = false
var stopped = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	endPos = $End.position
	started = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started and not stopped:
		time += delta

func _on_end_body_entered(body):
	if body is CharacterBody3D:
		stopped = true
		print(time)
