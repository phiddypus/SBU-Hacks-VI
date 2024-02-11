extends CharacterBody3D

const WALK_SPEED = 5.0
const DASH_SPEED = WALK_SPEED ** 2
const SLIDE_SPEED = 4.0
const SLIDE_VERT_DIFF = 0.1
const MOVE_DAMP = 0.25
const JUMP_VELOCITY = 8
const WALLFALL_SPEED = 0.2 # how slow you fall when on a wall
const MOUSE_SENS = 0.003

var can_dash = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Get the input direction
	var input_dir = Input.get_vector("game_left", "game_right", "game_front", "game_back")
	var on_floor = is_on_floor()
	var velocity_xz = Vector3(velocity.x, 0, velocity.z)
	var wallrunning = is_on_wall_only()
	
	if wallrunning:
		var wall_normal = get_wall_normal()
		var cross = wall_normal.cross(Vector3.UP).normalized()
		var direction = 1 if cross.angle_to($Camera3D.get_global_transform().basis.z) > PI / 2 else -1
		var wall_normal_xz = Vector3(wall_normal.x, 0, wall_normal.z).normalized()
		
		var move = Vector3(0, 0, input_dir.y).rotated(
			Vector3.UP,
			Vector3.LEFT.signed_angle_to(wall_normal_xz, Vector3.UP)
		) * SLIDE_SPEED * direction
		var target_velocity = Vector3.ZERO
		if move: target_velocity = (move + velocity).limit_length(max(velocity.length(), SLIDE_SPEED))
		
		velocity_xz = velocity_xz.lerp(target_velocity, MOVE_DAMP)
		velocity.x = velocity_xz.x
		velocity.z = velocity_xz.z
		
		velocity.y -= gravity * delta * WALLFALL_SPEED
		
		if Input.is_action_just_pressed("game_jump"):
			if velocity.y < 0: velocity.y = 0
			velocity += (wall_normal + Vector3.UP).normalized() * JUMP_VELOCITY
		elif Input.is_action_just_pressed("game_left" if direction == 1 else "game_right"):
			wallrunning = false
	
	if not wallrunning:
		var move = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, rotation.y) * WALK_SPEED
		var target_velocity = Vector3.ZERO
		if move:
			target_velocity = move
		if not on_floor:
			target_velocity = (target_velocity + velocity_xz).limit_length(max(velocity_xz.length(), WALK_SPEED))
		else:
			can_dash=true

		velocity_xz = velocity_xz.lerp(target_velocity, MOVE_DAMP)
		velocity.x = velocity_xz.x
		velocity.z = velocity_xz.z

		if on_floor:
			if Input.is_action_just_pressed("game_jump"):
				velocity.y = JUMP_VELOCITY
		else:
			velocity.y -= gravity * delta
	
		# Dash
	if can_dash and Input.is_action_just_pressed("game_dash"):
		var dir = $Camera3D.get_global_transform().basis.z
		velocity -= dir * DASH_SPEED
		can_dash = false
	
	# Cap velocity
	velocity.y = clamp(velocity.y,-20,20)
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		var y_rotation = event.relative.x * MOUSE_SENS
		rotation.y -= y_rotation
		$Camera3D.rotation.x -= event.relative.y * MOUSE_SENS
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)

#func _process(delta):
	#pass
