extends Sprite2D

var effect

var size = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_dt):
	var volume = AudioServer.get_bus_peak_volume_left_db(1, 0)
	if volume > 0:
		size = size * 1.01
		scale = Vector2(size, size)