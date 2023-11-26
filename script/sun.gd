extends DirectionalLight3D
class_name Sun

static var dt:float = 0.0001
static var time:float = 0.0
@export var _time:float = -200.0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	time+=dt;
	var rot:Vector3=Vector3.ZERO;
	rot.x=sin((_time+time) * PI * 2.0) * 0.5 - PI;
	rot.y=cos((_time+time) * PI * 2.0) * -0.9;
	rotation = rot;
	pass
