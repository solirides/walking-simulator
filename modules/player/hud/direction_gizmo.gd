extends ColorRect


var gizmo_basis := Basis.IDENTITY
var gizmo_down := Vector3(0,-1,0)
var gizmo_roll_direction := Vector3(1,0,0)

@export var axis_list = [Vector3(1,0,0), Vector3(0,1,0), Vector3(0,0,1), Vector3(-1,0,0), Vector3(0,-1,0), Vector3(0,0,-1)]
@export var axis_colors = [Color(1,0,0,0.9), Color(0,1,0,0.9), Color(0,0,1,0.9), Color(0.5,0,0,0.5), Color(0,0.5,0,0.5), Color(0,0,0.5,0.5)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	for i in range(6):
		var x_axis = (axis_list[i] * 40) * gizmo_basis
		draw_line(Vector2(0,0), Vector2(x_axis.x, -x_axis.y), axis_colors[i], 4)
	
	var roll = (gizmo_roll_direction * 40) * gizmo_basis
	draw_circle(Vector2(roll.x, -roll.y), 4, Color(1,0.3,1,0.8), true, -1.0, false)
	draw_circle(Vector2(-roll.x, roll.y), 4, Color(0.3,1,1,0.8), true, -1.0, false)
	
	var down = (gizmo_down * 60) * gizmo_basis
	draw_circle(Vector2(down.x, -down.y), 4, Color(0.9,1,0.9,0.8), true, -1.0, false)
