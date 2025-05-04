extends Node3D

@export var terrain:Node
@export var collision:Node
@export var timer:Timer
@export var player:Node
@export var step = 20
@export var collision_scale:float = 0.125

func _ready():
	timer.connect("timeout", Callable(self, "move"))
	timer.start()

func create_collision():
	var heightmap = terrain.get_surface_override_material(0).get("shader_parameter/heightmap")
	#var heightmap = load("res://modules/terrain/terrain_heightmap.tres")
	#var height_scale = terrain.get_surface_override_material(0).get("shader_parameter/heightmap_height_scale")
	var height_scale = 100
	var shape = HeightMapShape3D.new()
	shape.map_width = int(heightmap.width * collision_scale)
	shape.map_depth = int(heightmap.height * collision_scale)
	
	var float_array = []
	var image = heightmap.noise.get_image(heightmap.width, heightmap.height)
	image.resize(shape.map_width, shape.map_depth, Image.INTERPOLATE_NEAREST)
	
	print(shape.map_width)
	print(heightmap.width)
	
	for y in shape.map_depth:
		for x in shape.map_width:
			float_array.push_back(image.get_pixel(x, y).r)
			
	print(float_array[3])
	
	
	#print(len(float_array))
	
	shape.map_data = float_array
	collision.shape = shape
	
	#collision.scale.x = terrain.scale.x
	collision.scale.x = 1.0 / collision_scale
	collision.scale.y = height_scale
	collision.scale.z = 1.0 / collision_scale
	
	
	

func move():
	if player == null or true:
		return
	var pos = player.global_transform.origin.snapped(Vector3(step, 0, step))
	self.global_transform.origin.x = pos.x
	self.global_transform.origin.z = pos.z
	timer.start()


func _on_mesh_instance_3d_ready() -> void:
	create_collision()
