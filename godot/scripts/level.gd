extends Node3D

var startPos = Vector3.ZERO
var endPos = Vector3.ZERO
enum COMPLETION {
	NOT_STARTED,
	IN_PROGRESS,
	FINISHED,
}
var completion = COMPLETION.NOT_STARTED
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	startPos = $Player.position
	endPos = $End.position
	completion = COMPLETION.NOT_STARTED
	completion = COMPLETION.IN_PROGRESS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if completion == COMPLETION.IN_PROGRESS:
		time += delta

func _on_end_body_entered(body):
	if body is CharacterBody3D:
		completion = COMPLETION.FINISHED
		print("Your time: " + str(time))

func _input(event):
	if event.is_action("game_reset"):
		time = 0
		completion = COMPLETION.IN_PROGRESS
		$Player.position = startPos
		$Player.velocity = Vector3.ZERO
