extends Node3D

class_name Water

@export var mesh:MeshInstance3D
@export var rain:GPUParticles3D
@export var mesh_size:Vector2
@export var subdivision:Vector2i
@export var collision_size:Vector2i
@export var vp_collision:SubViewport
@export var vp_simul:SubViewport
@export var vp_buffer:SubViewport
@export var rain_amount:int = 0

var _coll:WaterCollision
var _time:float=0
# Called when the node enters the scene tree for the first time.
func _ready():
	_coll = vp_collision.get_child(0) as WaterCollision
	
	vp_collision.size = collision_size
	vp_simul.size = collision_size
	vp_buffer.size = collision_size
	
	var cr_coll:ColorRect = vp_collision.get_child(0) as ColorRect
	var cr_simul:ColorRect = vp_collision.get_child(0) as ColorRect
	var cr_buffer:ColorRect = vp_collision.get_child(0) as ColorRect
	cr_coll.size = collision_size
	cr_simul.size = collision_size
	cr_buffer.size = collision_size
	
	var vpt_coll:ViewportTexture = vp_collision.get_texture()
	var vpt_sim:ViewportTexture = vp_simul.get_texture()
	var vpt_buf:ViewportTexture = vp_buffer.get_texture()
	
	var simul:ColorRect = vp_simul.get_child(0) as ColorRect
	var buf:ColorRect = vp_buffer.get_child(0) as ColorRect
	
	simul.material.set_shader_parameter('col_tex', vpt_coll)
	simul.material.set_shader_parameter('sim_tex', vpt_buf)
	simul.material.set_shader_parameter('size', collision_size)
	
	buf.material.set_shader_parameter('simulation', vpt_sim)
	
	mesh.get_surface_override_material(0).set_shader_parameter('simulation', vpt_sim)
	mesh.get_surface_override_material(0).set_shader_parameter('collision_size', collision_size)
	mesh.get_surface_override_material(0).set_shader_parameter('subdivision', subdivision)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rain != null:
		if rain_amount > 0 :
			rain.amount = rain_amount * 4
			rain.emitting = true
		else :
			rain.emitting = false
	for i in range(rain_amount):
		hit_water(Vector3(randf()*mesh_size.x / subdivision.x,0.0,randf()*mesh_size.y / subdivision.y),-1.0)
	_time+=delta
	pass

func get_height(pos:Vector3) -> float:
	return global_position.y + (sin(_time + pos.x) * 0.04);

func hit_water(pos:Vector3, rad:float):
	var rad_scale:Vector2 = Vector2(collision_size.x,collision_size.y) * Vector2(subdivision.x,subdivision.y) / mesh_size
	var new_pos = pos - global_position + Vector3(mesh_size.x * 0.5,0,mesh_size.y * 0.5)
	new_pos = Vector3(new_pos.x * rad_scale.x, new_pos.y, new_pos.z * rad_scale.y)
	new_pos.x = fposmod(new_pos.x, collision_size.x)
	new_pos.z = fposmod(new_pos.z, collision_size.y)
	_coll.coll(Vector3(new_pos.x,new_pos.z,rad * rad_scale.x))
	
