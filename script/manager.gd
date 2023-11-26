extends Node3D

@export var env:WorldEnvironment
@export var fog_curve:Curve
@export var water:Water
@export var ball:PackedScene
var fog:bool = false
var rain:bool = false
var rain_step:float = 1.0;
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.content_scale_size = Vector2i(640,360)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if fog:
		env.environment.fog_density =  fog_curve.sample(fmod(Sun.time,1.0)) * 0.005
		env.environment.fog_sky_affect =  fog_curve.sample(fmod(Sun.time,1.0));
	else:
		env.environment.fog_density = 0.0
		env.environment.fog_sky_affect = 0.0
	var mat:ShaderMaterial = env.environment.sky.sky_material
	if rain:
		if rain_step > 0.0:
			rain_step -= 0.002
			mat.set_shader_parameter("clouds_cutoff",rain_step * 0.4)
	else:
		if rain_step < 1.0:
			rain_step += 0.002
			mat.set_shader_parameter("clouds_cutoff",rain_step * 0.4)
	if rain_step < 0.6:
		water.rain_amount = int((1.0 - (rain_step/0.6)) * 30.0)
	elif rain_step >= 1.0:
		water.rain_amount = 0
		
		
	pass


func _on_fast_toggled(button_pressed:bool):
	if button_pressed:
		Sun.dt = 0.0008
	else:
		Sun.dt = 0.0001
	pass # Replace with function body.


func _on_fog_toggled(button_pressed):
	fog = button_pressed
	pass # Replace with function body.


func _on_rain_toggled(button_pressed):
	rain = button_pressed
	pass # Replace with function body.


func _on_ball_button_up():
	var ball_node:Ball = ball.instantiate()
	add_child(ball_node) 
	ball_node.global_position = get_viewport().get_camera_3d().global_position
	ball_node.global_position.x+= randf()*2.0-1.0
	ball_node.water = water
	ball_node.specific_gravity = randf()*0.8 + 0.4
	pass # Replace with function body.


func _on_res_toggled(button_pressed):
	if button_pressed:
		get_tree().root.content_scale_size = Vector2i(1280,720)
		RenderingServer.global_shader_parameter_set("res",2)
	else:
		get_tree().root.content_scale_size = Vector2i(640,360)
		RenderingServer.global_shader_parameter_set("res",1)
	pass # Replace with function body.


func _on_button_refl_toggled(button_pressed):
	if button_pressed:
		RenderingServer.global_shader_parameter_set("refl",false)
	else:
		RenderingServer.global_shader_parameter_set("refl",true)
	pass # Replace with function body.
