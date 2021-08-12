extends KinematicBody


export var GRAVITY: float = 12.5
export var SPEED: float = 5
export var JUMP: float = 10
export var SENSITIVITY = 10
var mouseDelta: Vector2 = Vector2()
var vel: Vector3 = Vector3()

var pickable_object = null

var in_hand = null

onready var camera: Camera = $Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotation_degrees.x  -= mouseDelta.y * SENSITIVITY * delta
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
		camera.rotation_degrees.y -= mouseDelta.x * SENSITIVITY * delta
		mouseDelta = Vector2()
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("pick_up"): 
		if !in_hand and pickable_object:
			print('pick up')
			in_hand = pickable_object.pick_up($Camera/hand)
		elif in_hand:
			in_hand.let_go()
			in_hand = null

func _physics_process(delta):
	vel.x = 0
	vel.z = 0
	var cam_xform = camera.get_global_transform()
	var input: Vector2 = Vector2()

	SPEED = 5

	
	if Input.is_action_pressed("move_forward"):
		input.y += 1
	if Input.is_action_pressed("move_backward"):
		input.y -= 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	input = input.normalized()
	
	var dir = Vector3();

	if Input.is_action_pressed("run") and Input.is_action_pressed("move_forward"):
		SPEED *= 3

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input.y
	dir += cam_xform.basis.x * input.x
	
	vel.x = dir.x * SPEED
	vel.z = dir.z * SPEED
	
	vel.y -= GRAVITY * delta
	
	vel = move_and_slide(vel, Vector3.UP)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = JUMP
	
	if Input.is_action_pressed("fly"):
		vel.y += 1

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative


func _on_Area_body_entered(body):
	print(body.name)
	if body.has_method("pick_up"):
		pickable_object = body


func _on_Area_body_exited(body):
	if body.has_method("pick_up"):
		pickable_object = null
