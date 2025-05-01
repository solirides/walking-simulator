class_name PhysicsObject
extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	search_mesh(self, 0)
	
	constant_force = Vector3(0,-1,0) * 9.8 * mass

func search_mesh(node:Node, depth:int):
	for child in node.get_children():
		print(child)
		if child is MeshInstance3D:
			print("is mesh")
			var mesh = child.mesh.create_convex_shape()
			var collision = CollisionShape3D.new()
			collision.shape = mesh
			self.add_child(collision)
			collision.position = child.position
		else:
			search_mesh(child, depth + 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
