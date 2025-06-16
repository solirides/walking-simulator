class_name Player
extends RigidBody3D

const AXIS_LIST = [Vector3(1,0,0), Vector3(0,1,0), Vector3(0,0,1), Vector3(-1,0,0), Vector3(0,-1,0), Vector3(0,0,-1)]
const BASE_AXIS_LIST = [Vector3(1,0,0), Vector3(0,1,0), Vector3(0,0,1)]
var down_direction = Vector3(0,-1,0)
var time_delta = 0
var jump_ready = true
#var jump_queued = false
var roll_queued = false
var roll_direction = 0
var held_object:Node = null
@onready var active_wieldable:Wieldable = $CameraPivot/Shake/Camera3D/Hands/Wieldable
var last_camera_pos = Vector3(0,0,0)
var camera_pos = Vector3(0,0,0)
var camera_time = 0

#export var physics_rate = 1/60
@export_category("Player")
@export var mouse_sensitivity:float = 0.16
@export var fov:float = 80.0
@export var dynamic_fov:float = 12.0
@export var dynamic_fov_min:float = 6.0
@export var roll_sensitivity:float = 2
@export var camera_sway:float = 2
@export var lean_scale:float = 0.005
@export var lean_angle:float = 0.04
@export var lean_speed:float = 3
@export var movement_speed:float = 600
#export var max_speed = 14
#export var acceleration_speed = 1000
#@export var deceleration_speed = 0.1
@export var drag:float = 0.1
@export var ground_drag:float = 0.1
@export var speed_cap:float = 10
@export var gravity:float = 9.8
@export var jump_speed:float = 6.0
@export var hold_strength:float = 10.0
@export var fly:bool = false

# controls camera yaw
@export_category("Nodes")
@onready var camera_pivot = $CameraPivot
@onready var shake = $CameraPivot/Shake
# controls camera pitch
@onready var camera = $CameraPivot/Shake/Camera3D
@onready var smooth_camera = $CameraPivot/Shake/SmoothCamera
#@onready var subviewport = $SubViewport
@onready var feet_collision = $FeetCollision
#onready var feet_area = $FeetArea
@onready var jump_cooldown = $JumpCooldown
@onready var sway_timer = $Sway
@onready var raycast = $CameraPivot/Shake/Camera3D/RayCast3D
@onready var hold_position = $CameraPivot/Shake/Camera3D/Marker3D
@onready var hands = $CameraPivot/Shake/Camera3D/Hands
@onready var hud = $HUD


func _ready():
#	self.set_can_sleep(false)
	#subviewport.size = get_viewport().size
	#get_viewport().size_changed.connect(_on_viewport_changed)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_time = Time.get_ticks_usec()
	last_camera_pos = camera.position
	camera_pos = camera.position
	camera.fov = fov
	camera.make_current()
	#smooth_camera.make_current()
	#add_constant_central_force(gravity * self.mass * Vector3(0, -1, 0))
	constant_force = gravity * self.mass * down_direction
	
	active_wieldable.player = self

func _process(delta):
	# this used to be a crazy one-liner
	# dynamic fov using logistic equation
	var fov_logistic = logistic((-linear_velocity.length() + dynamic_fov_min), 9.0, 1.0)
	var new_fov = fov + max(0, fov_logistic * dynamic_fov)
	#camera.fov = lerp(camera.fov, new_fov, delta * 20)
	#var now = Time.get_ticks_usec()
	#var t = (now - camera_time) * Engine.physics_ticks_per_second / 1000000.0
	#smooth_camera.global_position = lerp(last_camera_pos, camera_pos, t)
	#smooth_camera.global_rotation = camera.global_rotation
	#print(last_camera_pos)
	#print(camera.position)
	#print(now)
	#print(now - camera_time)
	#camera_time = now
	#print(get_physics_process_delta_time()) # always 1/60?????
	#print(get_process_delta_time())
	#print((1.0 / float(Engine.physics_ticks_per_second)))
	#print("camera")
	
	hud.update_direction_gizmo(camera.global_basis, down_direction, closest_axis(camera.global_transform.basis.x.normalized()))
	hud.update_velocity(camera.global_basis, down_direction, self.linear_velocity)
	#camera.fov = fov + (linear_velocity.length() * 10)

func _physics_process(delta):
	time_delta = delta
	#last_camera_pos = camera_pos
	#camera_pos = camera.global_position
	
	var direction = Vector3.ZERO
	direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = direction.normalized()
	var velocity = camera_pivot.global_transform.basis * direction * movement_speed
	velocity = (2 - linear_velocity.normalized().dot(velocity.normalized())) * velocity
	velocity = max(speed_cap - linear_velocity.length(), 1) * velocity
	
	#if direction.x > 0:
		#camera.rotation.z = lerp_angle(camera_pivot.rotation.z, deg_to_rad(-5), 0.05)
	#elif direction.x < 0:
		#camera.rotation.z = lerp_angle(camera_pivot.rotation.z, deg_to_rad(5), 0.05)
	#else:
		#camera.rotation.z = lerp_angle(camera_pivot.rotation.z, 0, 0.05)
	
	#var x_vel = velocity.dot(camera_pivot.global_transform.basis.x)
	##print(x_vel)
	##print(clamp(-x_vel * camera_lean / movement_speed, -max_lean, max_lean))
	#if x_vel > 0:
		#shake.rotation.z = lerp_angle(shake.rotation.z, clamp(-x_vel * camera_lean / movement_speed, -max_lean, max_lean), delta * lean_speed)
		##shake.rotation.z = deg_to_rad(60)
	#elif x_vel < 0:
		#shake.rotation.z = lerp_angle(shake.rotation.z, clamp(-x_vel * camera_lean / movement_speed, -max_lean, max_lean) , delta * lean_speed)
	#else:
		#shake.rotation.z = lerp_angle(shake.rotation.z, 0, delta * lean_speed)
	
	#var lean_dir = -self.linear_velocity.cross(self.global_transform.basis.y).normalized()
	#print(lean_dir)
	#var current_rot = Quaternion(shake.global_transform.basis).normalized()
##	var target_rot = Quaternion(Basis.looking_at(lean_dir, self.global_transform.basis.y)).normalized()
	#var target_rot:Quaternion
	#if lean_dir == Vector3.ZERO:
		#target_rot = Quaternion(camera_pivot.global_transform.basis).normalized()
	#else:
		#target_rot = Quaternion(lean_dir, lean_angle).normalized()
	#var smooth_rot = current_rot.slerp(target_rot, delta * lean_speed)
	#shake.global_transform.basis = Basis(smooth_rot)
	
	
	var lean_dir = -self.linear_velocity.cross(self.global_transform.basis.y).normalized()
	#print(lean_dir)
	var current_rot = shake.global_transform.basis
#	var target_rot = Quaternion(Basis.looking_at(lean_dir, self.global_transform.basis.y)).normalized()
	var target_rot:Basis
	if lean_dir == Vector3.ZERO:
		target_rot = camera_pivot.global_transform.basis
	else:
		target_rot = camera_pivot.global_transform.basis.rotated(lean_dir, clamp(linear_velocity.length() * lean_scale, -lean_angle, lean_angle))
	var smooth_rot = current_rot.orthonormalized().slerp(target_rot.orthonormalized(), delta * lean_speed)
	shake.global_transform.basis = smooth_rot
	
	camera.rotation.z = lerp(camera.rotation.z, 0.0, delta * 10)
	
	#if speed_cap - linear_velocity.length() > 0:
		#velocity = (speed_cap - linear_velocity.length()) * velocity
		#pass
	#else:
		#velocity = Vector3(0, 0, 0)
#	velocity = lerp(velocity * delta, velocity, acceleration_speed * delta)
#	if feet_collision.is_colliding():
#		print("collide")
#		if Input.is_action_pressed("jump"):
#			apply_central_impulse(jump_velocity)
#	print(velocity)
#	print(direction)
#	print(feet_collision.is_colliding()
#	add_central_force(Vector3.DOWN * gravity * delta)
	#var roll = Input.get_action_strength("roll_right") - Input.get_action_strength("roll_left")
	if roll_queued:
		#self.rotate(camera_pivot.global_transform.basis.z, roll * roll_sensitivity * delta)
		roll(camera.global_transform.basis.x.normalized() * roll_direction)
	
	# gravity
	#apply_central_force(-self.global_transform.basis.y * 9.8 * mass)
	
	apply_central_force(mass * velocity * delta)
	if fly == true:
		var vertical_dir = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
		var vertical_velocity = Vector3(0,vertical_dir * movement_speed,0)
		apply_central_force(mass * vertical_velocity * delta)
	apply_central_force(-linear_velocity * mass * drag)
	
#	print("pos " + str(self.translation))
	
	if held_object != null and held_object is RigidBody3D:
		var force = hold_strength * held_object.mass * (hold_position.global_position - held_object.global_position)
		held_object.apply_central_force(force)
		print(force)

func _integrate_forces(state):
	if fly == true:
		constant_force = Vector3.ZERO
	#elif feet_collision.has_overlapping_bodies():
##		print("collide")
##		print(feet_area.get_overlapping_bodies())
		#if jump_queued and jump_ready:
			#jump()
	var is_on_ground = false
	for i in state.get_contact_count():
		var normal = state.get_contact_local_normal(i)
		if normal.dot(-down_direction) > 0.8:
			is_on_ground = true
			# cancel x z components of normal force
			var fix = false
			
			var axis_list = []
			
			for axis in BASE_AXIS_LIST:
				if down_direction != axis:
					axis_list.append(axis)
			
			for axis in axis_list:
				#var axis = Vector3.ZERO
				#axis[j] = 1
				# velocity in direction
				if abs(linear_velocity.dot(axis)) < 0.1:
					#apply_central_force(-normal.x * mass * gravity * axis)
					apply_central_force(-normal.dot(axis) * mass * gravity * axis)
					linear_velocity -= linear_velocity.dot(axis) * axis
					fix = true
			if fix:
				apply_central_force(mass * gravity * (1 + normal.dot(down_direction)) * -(down_direction))
				#apply_central_force(Vector3(0, mass * gravity * (1 - normal.y), 0))
	
	# not considering down direction
	#var normal = state.get_contact_local_normal(i)
		#if normal.dot(Vector3(0,1,0)) > 0.8:
			#is_on_ground = true
			## cancel x z components of normal force
			#var fix = false
			#if abs(linear_velocity.x) < 0.1:
				#apply_central_force(Vector3(-normal.x * mass * gravity, 0, 0))
				#linear_velocity.x = 0
				#fix = true
			#if abs(linear_velocity.z) < 0.1:
				#apply_central_force(Vector3(-normal.z * mass * gravity, 0, 0))
				#linear_velocity.z = 0
				#fix = true
			#if fix:
				#apply_central_force(Vector3(0, mass * gravity * (1 - normal.y), 0))
	
	# ground drag
	
	var jumped = false
	if Input.is_action_pressed("jump") and is_on_ground:
		if jump_ready:
			jump()
			jumped = true
	
	if is_on_ground and !jumped:
		state.linear_velocity.x = lerp(state.linear_velocity.x,0.0,ground_drag)
		state.linear_velocity.y = lerp(state.linear_velocity.y,0.0,ground_drag)
		state.linear_velocity.z = lerp(state.linear_velocity.z,0.0,ground_drag)
	

func jump():
	#jump_queued = false
	jump_ready = false
	jump_cooldown.start()
	apply_central_impulse(mass * jump_speed * -down_direction)

func roll(direction:Vector3):
	# find closest axis
	# equivalent to using dot product but simplified
	# this part is weird
	var target = closest_axis(direction)
	
	#print(direction)
	#print(a)
	#print(target)
	#print(self.global_position + target)
	
	#mark(self.global_position, Color(1,1,1,1))
	#mark(self.global_position + target, Color(0,1,0,1))
	#mark(self.global_position + direction, Color(1,0,0,1))
	#mark(self.global_position + camera_pivot.global_transform.basis.y.cross(target).normalized(), Color(0,0,1,1))
	
	self.rotate(-down_direction.cross(target).normalized(), PI/2)
	down_direction = -target
	constant_force = down_direction * gravity * self.mass
	roll_queued = false

func snap_gravity(target:Vector3):
	if target == down_direction:
		return
	var rot_p = camera_pivot.global_rotation
	#var rot = camera.global_rotation
	# intended to remove the effects of camera shake
	var rot = camera.global_rotation * shake.basis.inverse()
	
	if target == -down_direction:
		#self.rotate(down_direction.cross(target).normalized(), PI)
		pass
	else:
		self.rotate(down_direction.cross(target).normalized(), PI/2)
		down_direction = target
		constant_force = down_direction * gravity * self.mass

		camera_pivot.global_rotation = rot
		camera_pivot.rotation.x = 0
		camera_pivot.rotation.z = 0
		camera.global_rotation = rot
		#camera.rotation.z = 0
		#camera.rotation.y = 0
		

func closest_axis(direction) -> Vector3:
	var a = 0
	var sign = sign(direction.x)
	var largest = abs(direction.x)
	if abs(direction.y) > largest:
		largest = abs(direction.y)
		sign = sign(direction.y)
		a = 1
	if abs(direction.z) > largest:
		largest = abs(direction.z)
		sign = sign(direction.z)
		a = 2
	
	var target = Vector3.ZERO
	match a:
		0:
			target = Vector3(1, 0, 0)
		1:
			target = Vector3(0, 1, 0)
		2:
			target = Vector3(0, 0, 1)
		_:
			target = Vector3(1, 0, 0)
	
	return (target * sign)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		print(Input.mouse_mode)
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		camera_pivot.rotate_y(deg_to_rad(-event.screen_relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.screen_relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		#camera.rotation.z = 0
	
	if Input.is_action_just_pressed("toggle_perspective"):
		if camera.position.z != 0:
			camera.position.z = 0
		else:
			camera.position.z = 5
	
	#if Input.is_action_just_pressed("jump"):
		#jump_queued = true
	
	if Input.is_action_just_released("roll_left"):
		roll_queued = true
		roll_direction = -1
	if Input.is_action_just_released("roll_right"):
		roll_queued = true
		roll_direction = 1
	
	if Input.is_action_just_pressed("snap_gravity"):
		var target = closest_axis(-camera.global_transform.basis.z.normalized())
		#print(target)
		snap_gravity(target)
	
	if Input.is_action_just_pressed("secondary"):
		var collider = raycast.get_collider()
		print(collider)
		if collider != null:
			if collider is PhysicsObject:
				held_object = collider
		
	if Input.is_action_just_released("secondary"):
		if held_object != null:
			held_object.constant_force = gravity * held_object.mass * down_direction
			held_object = null
	
	if Input.is_action_just_pressed("primary"):
		if active_wieldable != null:
			active_wieldable.primary_activate()
		
	if Input.is_action_just_released("primary"):
		if active_wieldable != null:
			active_wieldable.primary_release()


func _on_jump_cooldown_timeout():
	jump_ready = true
	#print("jump ready")
	
#func _on_viewport_changed():
	#subviewport.size = get_viewport().size

func logistic(x, c, k) -> float:
	return 1.0 / (1.0 + 9 * pow(2, k * x)) - (1/(k + 1))

#func toggle_fly(bool state):
	#else:
		#constant_force = gravity * self.mass * down_direction
	
	
