extends StaticBody3D

# Called when the node enters the scene tree for the first time.
@export var period = 5
@export var initialPosition = Vector3(-5,0,6)
@export var finalPosition = Vector3(5,0,6)
var direction = Vector3(0,0,0)
var time = 0
func _ready():        
	time = 0;
	direction = finalPosition - initialPosition


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if time >= period:
		time = 0
	time+=delta
	position = initialPosition+direction*sin(time/period*PI)*sin(time/period*PI);
	