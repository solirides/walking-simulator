extends Node


@export var marker = preload("res://modules/debug/marker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func mark(location:Vector3, color:Color = Color(0,1,0,1)):
	var instance = marker.instantiate()
	get_tree().get_root().add_child(instance)
	instance.mesh = instance.mesh.duplicate(true)
	instance.mesh.material.albedo_color = color
	instance.mesh.material.emission = color
	instance.mesh.material.emission_enabled = true
	#print(instance.mesh.material.albedo_color)
	instance.position = location
