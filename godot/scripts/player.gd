extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.003
const DASH_COOLDOWN = 1.5
var dash_timer = 0
var dashing = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity.y -= gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("game_left", "game_right", "game_front", "game_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, rotation.y)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
			
	
	# Dash
	if dash_timer <= DASH_COOLDOWN:
		dash_timer += delta
		
	if dashing:
		var camera = $Camera3D
		var camera_dir = $Camera3D.basis.z
		var dir = Basis(Vector3(1,0,0),camera.rotation.x*2)*Basis(Vector3(0,1,0), camera.rotation.y*2)*Vector3(0,0,1)
		print(camera.basis.z.y)
		velocity.x = -dir.x * SPEED * SPEED
		velocity.y = -camera.basis.z.y * SPEED * SPEED
		velocity.z = -dir.z * SPEED * SPEED
		dash_timer=0
		dashing=false
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		var y_rotation = event.relative.x * MOUSE_SENS
		rotation.y -= y_rotation
		$Camera3D.rotation.y -= y_rotation
		$Camera3D.rotation.x -= event.relative.y * MOUSE_SENS
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)
		
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SHIFT and dash_timer>DASH_COOLDOWN:
			dashing=true
			

func _process(delta):
	pass
