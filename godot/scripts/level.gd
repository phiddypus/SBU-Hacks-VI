extends Node3D

var startPos = Vector3.ZERO
var endPos = Vector3.ZERO
enum cplt_statuses {
	NOT_STARTED,
	IN_PROGRESS,
	FINISHED,
}
var completion = cplt_statuses.NOT_STARTED
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	endPos = $End.position
	completion = cplt_statuses.NOT_STARTED
	completion = cplt_statuses.IN_PROGRESS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if completion == cplt_statuses.IN_PROGRESS:
		time += delta

func _on_end_body_entered(body):
	if body is CharacterBody3D:
		completion = cplt_statuses.FINISHED
		print("Your time: " + time)
