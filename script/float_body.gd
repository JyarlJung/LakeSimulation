extends RigidBody3D

class_name FloatBody

@export var specific_gravity := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var water:Water
@export var probes:Node3D

var _probes_array:Array
var _float_force:float
var _submerged_volume:float

# Called when the node enters the scene tree for the first time.
func _ready():
	_probes_array=probes.get_children();
	pass

func _physics_process(_delta):
	_float_force= mass * gravity / _probes_array.size() / specific_gravity
	_submerged_volume=0.0
	for p in _probes_array :
		var marker := p as Marker3D
		var volume := (4.0/3.0) * PI * pow(marker.gizmo_extents,3.0);
		var depth = water.get_height(global_position) - marker.global_position.y
		if depth > -marker.gizmo_extents:
			var clamped_depth:float
			var rad:float
			if depth > 0:
				clamped_depth = min(depth, marker.gizmo_extents)
				_submerged_volume = (0.5 * volume) + _submerged_volume
			else:
				clamped_depth = -depth
				_submerged_volume = (0.5 * volume) - _submerged_volume
			_submerged_volume = PI * (pow(marker.gizmo_extents,2)*clamped_depth - pow(clamped_depth,3)/3.0)
			_submerged_volume = (0.5 * volume) + (sign(depth) * _submerged_volume)
				
			rad = sqrt(pow(marker.gizmo_extents,2)-pow(clamped_depth,2))
			_submerged_volume /= volume;

			if depth < marker.gizmo_extents:
				water.hit_water(marker.global_position,rad)
			apply_force(Vector3.UP * _float_force * _submerged_volume, p.global_position - global_position)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if _submerged_volume>0:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
