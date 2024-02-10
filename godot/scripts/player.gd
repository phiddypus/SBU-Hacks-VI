extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.003
var target_velocity = Vector3(0,0,0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if(is_on_floor()):
		target_velocity = Vector3(0,0,0)
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		
		# If Jumping on Moving Platform
		var collision = move_and_collide(Vector3(0,-1,0)*delta)
		if collision:
			if collision.get_collider().get_class() == "AnimatableBody3D":
				velocity += collision.get_collider().velocity
				target_velocity = collision.get_collider().velocity
		velocity.y = JUMP_VELOCITY
		
		

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("game_left", "game_right", "game_front", "game_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, rotation.y)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, target_velocity.x, SPEED)
		velocity.z = move_toward(velocity.z, target_velocity.z, SPEED)
	
	move_and_slide()
		

func _input(event):
	if event is InputEventMouseMotion:
		var y_rotation = event.relative.x * MOUSE_SENS
		rotation.y -= y_rotation
		$Camera3D.rotation.y -= y_rotation
		$Camera3D.rotation.x -= event.relative.y * MOUSE_SENS
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)

func _process(delta):
	pass
