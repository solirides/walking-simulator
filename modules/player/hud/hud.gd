extends Control

@onready var direction_gizmo = $DirectionGizmo
@onready var velocity_gizmo = $VelocityGizmo
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
	direction_gizmo.gizmo_basis = basis
	direction_gizmo.gizmo_down = down
	direction_gizmo.gizmo_roll_direction = roll_direction
	direction_gizmo.queue_redraw()
	
func update_velocity(basis:Basis, down:Vector3, velocity:Vector3):
	velocity_gizmo.gizmo_basis = basis
	velocity_gizmo.gizmo_down = down
	velocity_gizmo.velocity = velocity
	velocity_gizmo.queue_redraw()
