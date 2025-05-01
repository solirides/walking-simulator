class_name Rearranger
extends Wieldable


var held_object:PhysicsObject = null
var object_parent:Node = null
var distance = 1
var release_queued = false
var object_mask = 0
var object_layer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if release_queued:
		if held_object != null and object_parent != null:
			#print(held_object.get_colliding_bodies())
			#if held_object.get_contact_count() == 0:
			release_object()
	#if held_object != null:
		#held_object.global_position = player.hold_position.global_position

func primary_activate():
	var collider = player.raycast.get_collider()
	if collider != null and held_object == null:
		if collider is PhysicsObject:
			held_object = collider
			object_parent = held_object.get_parent()
			var rot = held_object.global_rotation
			distance = (held_object.global_position - player.raycast.global_position).length()
			
			object_parent.remove_child(held_object)
			player.camera.add_child(held_object)
			held_object.global_rotation = rot
			#held_object.global_position = player.hold_position.global_position
			#held_object.global_position = player.raycast.global_position + player.raycast.target_position.normalized() * distance
			held_object.global_position = player.raycast.global_transform * (player.raycast.target_position.normalized() * distance)
			
			#object_mask = held_object.collision_mask
			#object_layer = held_object.collision_layer
			#held_object.collision_mask = 0
			#held_object.collision_layer = 0
			#held_object.constant_force = Vector3.ZERO
			
			held_object.process_mode = Node.PROCESS_MODE_DISABLED
			

func primary_release():
	release_queued = true


func release_object():
	release_queued = false
	var pos = held_object.global_position
	var rot = held_object.global_rotation
	player.camera.remove_child(held_object)
	object_parent.add_child(held_object)
	held_object.global_position = pos
	held_object.global_rotation = rot
	
	#held_object.collision_mask = object_mask
	#held_object.collision_layer = object_layer
	held_object.constant_force = player.gravity * held_object.mass * player.down_direction
	
	held_object.process_mode = Node.PROCESS_MODE_INHERIT
	held_object = null
