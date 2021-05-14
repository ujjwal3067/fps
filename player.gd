extends KinematicBody

################################################
#----Class variables

var vel = Vector3()
var dir = Vector3()

const GRAVITY = -94.8
const MAX_SPEED = 40
const JUMP_SPEED = 68
const ACCEL = 8.5
const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40
var camera
var rotation_helper
var MOUSE_SENSITIVITY = 0.09

const MAX_SPRINT_SPEED = 80
const SPRINT_ACCEL = 13
var is_sprinting = false
var flashlight #(variable holds the player flashlight node)

################################################

func _ready():
	# get nodes
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # more crosshair locking
	# grab the flashlight node
	flashlight = $Rotation_Helper/Flashlight

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized() # Normalized the vector so that only it's within unit scale

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			vel.y = JUMP_SPEED
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------
	# Sprinting
	if Input.is_action_pressed("movement_sprint"):
		is_sprinting = true
	else:
		is_sprinting = false

	# ----------------------------------
	# Turning flashlight on/off ( just pressed checks for toggle behavoir rather than long press )
	if Input.is_action_just_pressed("flashlight"):
		if flashlight.is_visible_in_tree(): # if flashlight is active
			flashlight.hide() # turn off the flashlight
		else:
			flashlight.show() # turn on the flashlight


func process_movement(delta):
	dir.y = 0 # reset ( to prevent previous input to effect this input call : reset the player dir variable )
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0 # hvel ::  reference to player velocity

	var target = dir
	if is_sprinting :
		target  *= MAX_SPRINT_SPEED # max sprinting speed lock
	else:
		target  *= MAX_SPEED  # max awlking speed lock

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL # deaccelaret the player accelaration
		# accel = ACCEL
	if is_sprinting :
		accel = SPRINT_ACCEL
	else:
		accel = ACCEL


	hvel = hvel.linear_interpolate(target, accel * delta) # interpolation of horizontal velocity
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	# check for the event if it's inputevent mouse motion or not
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		# rotating the model via rotation_helper
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
