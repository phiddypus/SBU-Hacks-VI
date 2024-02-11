extends Area3D

@export var jump_pad_strength = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is CharacterBody3D:
		body.velocity.y = jump_pad_strength
		body.can_dash=true
