extends ColorRect

var gizmo_basis := Basis.IDENTITY
var gizmo_down := Vector3(0,-1,0)
var velocity = Vector3.ZERO

@export var axis_list = [Vector3(1,0,0), Vector3(0,1,0), Vector3(0,0,1), Vector3(-1,0,0), Vector3(0,-1,0), Vector3(0,0,-1)]
@export var line_color = Color(0.14,0.94,0.68,0.9)

func _draw():
	var x_axis = (velocity * 3) * gizmo_basis
	draw_line(Vector2(0,0), Vector2(x_axis.x, -x_axis.y), line_color, 1.0)
	
