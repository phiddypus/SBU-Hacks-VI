extends CharacterBody3D

const WALK_SPEED = 5.0
const DASH_SPEED = WALK_SPEED ** 2
const WALK_DAMP = 0.25
const JUMP_VELOCITY = 4.5
const WALLRUN_EFFC = 0.2 # how slow you fall when on a wall
const MOUSE_SENS = 0.003

var can_dash = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#func get_ground_velocity ():
	#for i in range(get_slide_collision_count()):
		#var coll = get_slide_collision(i)
		#if coll.get_angle() == get_floor_angle():
			#var collColl = coll.get_collider()
			#if "velocity" in collColl:
				#return collColl.velocity
	#return Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Get the input direction
	var input_dir = Input.get_vector("game_left", "game_right", "game_front", "game_back")
	var on_floor = is_on_floor()
	var velXZ = Vector3(velocity.x, 0, velocity.z)
	var wallrunning = is_on_wall_only()
	
	if wallrunning:
		
		velocity.y -= gravity * delta * WALLRUN_EFFC
	
	else:
		var move = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, rotation.y) * WALK_SPEED
		var target_velocity = Vector3.ZERO
		if move:
			target_velocity = move
		if not on_floor:
			target_velocity = (target_velocity + velXZ).limit_length(max(velXZ.length(), WALK_SPEED))
		else:
			can_dash=true

		velXZ = velXZ.lerp(target_velocity, WALK_DAMP)
		velocity.x = velXZ.x
		velocity.z = velXZ.z

		if on_floor:
			if Input.is_action_just_pressed("game_jump"):
				velocity.y = JUMP_VELOCITY
		else:
			velocity.y -= gravity * delta
	
		# Dash
	if can_dash and Input.is_action_just_pressed("game_dash"):
		var camera = $Camera3D
		#var camera_dir = $Camera3D.basis.z
		var dir = Basis(Vector3(1,0,0),camera.rotation.x*2)*Basis(Vector3(0,1,0), camera.rotation.y*2)*Vector3(0,0,1)
		#print(camera.basis.z.y)
		velocity.x = -dir.x 
		velocity.y = -camera.basis.z.y 
		velocity.z = -dir.z 
		velocity = DASH_SPEED*velocity.normalized()
		can_dash = false
	
	# Cap velocity
	velocity.y = clamp(velocity.y,-20,20)
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
