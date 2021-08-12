extends RigidBody


export var GRAVITY = 28
var vel: Vector3 = Vector3()


func _physics_process(delta):
	vel.y -= GRAVITY * delta
	
	vel = 
