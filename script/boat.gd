extends FloatBody

@export var accel:float
@export var head:Node3D

var _initial_depth:float

func _ready():
	super._ready()
	_initial_depth = global_position.z

func _physics_process(delta):
	super._physics_process(delta)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos:Vector2 = get_viewport().get_mouse_position() as Vector2
		var vpt_size:Vector2 = get_viewport().get_texture().get_size() as Vector2
		var mouse_pos_normalize:Vector2 = mouse_pos / vpt_size
		var pivot:Vector3 = head.global_position- global_position
		
		if mouse_pos_normalize.x > 0.75:
			apply_force(Vector3.RIGHT * mass * accel * mouse_pos_normalize.x, pivot)
		elif mouse_pos_normalize.x < 0.25:
			apply_force(Vector3.LEFT * mass * accel * (1.0 - mouse_pos_normalize.x), pivot)
			
		if mouse_pos_normalize.y > 0.7:
			apply_force(Vector3.BACK * mass * accel * mouse_pos_normalize.y, pivot)
		elif mouse_pos_normalize.y < 0.3:
			apply_force(Vector3.FORWARD * mass * accel * (1.0 - mouse_pos_normalize.y), pivot)
	var depth_difference:float = global_position.z - _initial_depth
	if abs(depth_difference) > 4.0:
		apply_force(Vector3.FORWARD * mass * accel * sign(depth_difference))
	if global_position.x < 8:
		apply_force(Vector3.RIGHT * mass * accel)
	if global_position.x > 120:
		apply_force(Vector3.LEFT * mass * accel)
