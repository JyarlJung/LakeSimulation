extends Node3D

@export var object:Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	translate(Vector3.RIGHT * (object.global_position.x - global_position.x) * 0.02)
	translate(Vector3.UP * ((object.global_position.z * -0.4) - global_position.y +13) * 0.02)
	pass
