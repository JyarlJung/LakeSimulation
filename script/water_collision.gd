extends ColorRect

class_name WaterCollision

var collision:PackedVector3Array

func _process(_delta):
	if collision.size() > 0:
		queue_redraw()
	pass

func _draw():
	draw_rect(Rect2(0,0,512,512),Color.BLACK)
	for coll_obj in collision:
		if coll_obj.z>0:
			draw_circle(Vector2(coll_obj.x,coll_obj.y),coll_obj.z,Color.RED)
		else:
			draw_circle(Vector2(coll_obj.x,coll_obj.y),randf()+1.0,Color.BLUE)
	collision.clear()
	pass

func coll(status:Vector3):
	collision.push_back(status)
	pass
