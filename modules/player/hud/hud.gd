extends Control


@onready var canvas = $DirectionGizmo
#@export_node_path var viewport:NodePath
#@export var texturerect:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#texturerect.texture.viewport_path = viewport
	#print($TextureRect.texture.viewport_path)
	#print(viewport)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_direction_gizmo(basis:Basis, down:Vector3, roll_direction:Vector3):
	canvas.gizmo_basis = basis
	canvas.gizmo_down = down
	canvas.gizmo_roll_direction = roll_direction
	canvas.queue_redraw()
