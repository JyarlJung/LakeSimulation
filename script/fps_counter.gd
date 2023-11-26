extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mouse_pos:Vector2 = get_viewport().get_mouse_position() as Vector2
	var vpt_size:Vector2 = get_viewport().get_texture().get_size() as Vector2
	var mouse_pos_normalize:Vector2 = mouse_pos / vpt_size
	text = str(Engine.get_frames_per_second())+"fps";
	pass
