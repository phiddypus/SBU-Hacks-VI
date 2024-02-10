extends CharacterBody3D

const WALK_SPEED = 5.0
const WALK_DAMP = 0.25
const JUMP_VELOCITY = 5.0
const MOUSE_SENS = 0.003

var player_velocity = Vector3.ZERO
var base_velocity = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_ground_velocity ():
	for i in range(get_slide_collision_count()):
		var coll = get_slide_collision(i)
		if coll.get_angle() == get_floor_angle():
			var collColl = coll.get_collider()
			if "velocity" in collColl:
				return collColl.velocity
	return Vector3.ZERO

func _physics_process(delta):
	var on_floor = is_on_floor()
	var velXZ = Vector3(velocity.x, 0, velocity.z)
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("game_left", "game_right", "game_front", "game_back")
	var move = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, rotation.y) * WALK_SPEED
	var target_velocity = Vector3.ZERO
	if move:
		target_velocity = move
	if not on_floor:
		target_velocity = (target_velocity + velXZ).limit_length(max(velXZ.length(), WALK_SPEED))
		print(target_velocity)

	velXZ = velXZ.lerp(target_velocity, WALK_DAMP)
	velocity.x = velXZ.x
	velocity.z = velXZ.z

	if on_floor:
		base_velocity = get_ground_velocity()
		if Input.is_action_just_pressed("game_jump"):
			velocity.y = JUMP_VELOCITY
	else:
		velocity.y -= gravity * delta
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		var y_rotation = event.relative.x * MOUSE_SENS
		rotation.y -= y_rotation
		$Camera3D.rotation.y -= y_rotation
		$Camera3D.rotation.x -= event.relative.y * MOUSE_SENS
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)

#func _process(delta):
	#pass
