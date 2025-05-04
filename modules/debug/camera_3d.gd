extends Node3D

@export var mouse_sensitivity = 0.16
@onready var camera = $Camera3D
var camera_anglev=0

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		print(Input.mouse_mode)
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		#self.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		self.rotate_y(deg_to_rad(-event.screen_relative.x * mouse_sensitivity))
		self.rotate_x(deg_to_rad(-event.screen_relative.y * mouse_sensitivity))
		self.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
	
