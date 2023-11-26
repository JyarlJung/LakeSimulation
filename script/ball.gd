extends FloatBody
class_name Ball
var time:float = 0.0

func _ready():
	super._ready()
	linear_velocity = Vector3.FORWARD * (randf()*10.0 +5.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	time+=1.0
	if time>500.0:
		queue_free()
	pass
