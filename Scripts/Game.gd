class_name Game extends Node2D

@export var zone: Control

var zoneLimit = 520
var zoneSize = 220

@export var blow: Control

var blowLimit = 700

@export var bubbleBar: ProgressBar

var bubbleLife: float = 1.0

var size = 0.02

@export var bubble: Sprite2D

var blowPos = 0

var blowVel = 0

var popped: bool = false

var moving: bool = false
var started: bool = false

func _physics_process(_dt):
	var volume = AudioServer.get_bus_peak_volume_left_db(2, 0)
	if (volume > 0 || Input.is_action_pressed("Test")) && ! popped:
		started = true
		size = size * 1.01
		bubble.scale = Vector2(size, size)
		blowVel += 0.1
		if blowVel < 0:
			blowVel += 0.1
	else:
		blowVel -= 0.05
		if blowVel > 0:
			blowVel -= 0.05
	blowPos += blowVel
	blow.position.y = blowLimit - blowPos

	if blowPos < 0:
		blowPos = -blowPos
		blowVel = -blowVel * 0.75

	if blowPos > blowLimit:
		blowPos = -blowPos + (blowLimit*2)
		blowVel = -blowVel * 0.75

	bubbleLife -= 0.005
	var blowCentre = blow.global_position.y + (blow.size.y /2)
	if blowCentre > zone.global_position.y && blowCentre < zone.global_position.y + zone.size.y && !popped:
		bubbleLife += 0.02
	if bubbleLife > 1:
		bubbleLife = 1
	bubbleBar.value = bubbleLife

	if bubbleLife < 0:
		popped = true

	if !moving && started:
		MoveZone()
		moving = true

func MoveZone():
	var tween: Tween = create_tween()
	var newPos = randf_range(0, zoneLimit - 150)
	while (abs(newPos - zone.position.y)) < 200:
		newPos = randf_range(0, zoneLimit - 150)
	tween.tween_property(zone, "position:y", newPos, randf_range(1, 4))
	tween.tween_callback(func(): moving = false)
		