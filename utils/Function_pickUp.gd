extends RigidBody

onready var og_parent = get_parent()
onready var og_collision_layer = collision_layer
onready var og_collision_mask = collision_mask

var picked_up_by = null

func pick_up(by):
	picked_up_by = by
	mode = RigidBody.MODE_STATIC
	og_parent.remove_child(self)
	picked_up_by.add_child(self)
	transform = Transform()
	collision_layer = 0
	collision_mask = 0
	return self

func let_go(impulse = Vector3()):
	if picked_up_by:
		var t = global_transform
		picked_up_by.remove_child(self)
		og_parent.add_child(self)
		global_transform = t
		mode = RigidBody.MODE_RIGID
		apply_impulse(Vector3.ZERO, impulse)
		picked_up_by = null
		scale = Vector3(1, 1, 1)
		collision_layer = og_collision_layer
		collision_mask = og_collision_mask
	return self
