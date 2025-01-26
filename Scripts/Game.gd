class_name Game extends Node2D

@export var zone: Control

var zoneLimit = 520
var zoneSize = 220

@export var blow: Control

var blowLimit = 700

@export var bubbleBar: ProgressBar

var bubbleLife: float = 1.0

var size = 0.03

var minSize = 0.03

@export var bubble: Sprite2D

@export var burst: CPUParticles2D

@export var scoreLabel: RichTextLabel

@export var cam: Camera2D

@export var retry: Button

var camDefault: Vector2 = Vector2(599, 441)

var blowPos = 0

var blowVel = 0

var popped: bool = false

var moving: bool = false
var started: bool = false
var blowing: bool = false

var over: bool = false
var under: bool = false

var score: float = 0

var squishAmount = 0

var camLevel = 0

var difficulty = 1

static var ins: Game

func _init():
	ins = self

func _ready():
	bubble.scale = Vector2(size, size)
	cam.position = camDefault
	cam.zoom = Vector2.ONE

func _physics_process(_dt):
	var volume = AudioServer.get_bus_peak_volume_left_db(2, 0)
	var blowCentre = blow.global_position.y + (blow.size.y /2)
	if (volume > -10 || Input.is_action_pressed("Test")) && ! popped:
		if started == false:
			MoveZone(true)
		started = true
		blowing = true
		if blowCentre < zone.global_position.y + zone.size.y:
			size = size * 1.008
			bubble.scale = Vector2(size, size)
		blowVel += 0.1
		if blowVel < 0:
			blowVel += 0.1
	else:
		blowing = false
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

	bubbleLife -= 0.004 * difficulty
	
	if !popped:
		if blowCentre > zone.global_position.y + zone.size.y:
			if blowing: 
				size = size * 0.999
			else:
				size = size * 0.997
			under = true
		elif blowCentre < zone.global_position.y:
			bubbleLife -= 0.004 * difficulty
			over = true
		else:
			bubbleLife += 0.05
			under = false
			over = false
	if bubbleLife > 1:
		bubbleLife = 1
	bubbleBar.value = bubbleLife

	if bubbleLife < 0 && !popped:
		popped = true
		retry.visible = false # should be true but its broken :c
		if over:
			bubble.texture = null
			burst.scale_amount_max = size
			burst.scale_amount_min = size
			burst.emitting = true

	if !moving && started:
		MoveZone()

	if size < minSize:
		size = minSize

	if !popped:
		bubble.scale = Vector2(size, size)

	if size * 33 >= score:
		score = size * 33
	if score > SceneMan.ins.record:
		SceneMan.ins.record = score
	scoreLabel.text = str("Bubble Size: " + str(snapped(size * 33, 0.1)) + " inches\nRecord Size: " + str(snapped(SceneMan.ins.record, 0.1)) + " inches")

	if over && !popped:
		bubble.scale = Vector2(size + (size * 0.1 * (1 - bubbleLife) * randf()), size + (size * 0.1 * (1 - bubbleLife) * randf()))

	if under && !popped:
		squishAmount = 1 - bubbleLife
	
	if squishAmount > 0:
		if !under:
			squishAmount -= 0.05
			if squishAmount < 0:
				squishAmount = 0
		bubble.scale = Vector2(bubble.scale.x + (bubble.scale.x * 0.2 * squishAmount), bubble.scale.y - (bubble.scale.y * 0.2 * squishAmount))

	if popped:
		bubble.scale = bubble.scale * 0.99

	if camLevel == 0 && size * 33 > 100:
		camLevel += 1
		var camTween: Tween = create_tween()
		camTween.tween_property(cam, "position", Vector2(681, -628), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		camTween.parallel()
		camTween.tween_property(cam, "zoom", Vector2(0.3, 0.3), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		difficulty = 1.1
	if camLevel == 1 && size * 33 > 400:
		camLevel += 1
		var camTween: Tween = create_tween()
		camTween.tween_property(cam, "position", Vector2(664, -8561), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		camTween.parallel()
		camTween.tween_property(cam, "zoom", Vector2(0.03, 0.03), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		difficulty = 1.3
	if camLevel == 2 && size * 33 > 4000:
		camLevel += 1
		var camTween: Tween = create_tween()
		camTween.tween_property(cam, "position", Vector2(664, -100561), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		camTween.parallel()
		camTween.tween_property(cam, "zoom", Vector2(0.003, 0.003), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		difficulty = 1.8
	if camLevel == 3 && size * 33 > 40000:
		camLevel += 1
		var camTween: Tween = create_tween()
		camTween.tween_property(cam, "position", Vector2(664, -1200561), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		camTween.parallel()
		camTween.tween_property(cam, "zoom", Vector2(0.0003, 0.0003), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		difficulty = 2.5


func MoveZone(first: bool = false):
	moving = true
	var tween: Tween = create_tween()
	if !first:
		var newPos = randf_range(0, zoneLimit - 150)
		while (abs(newPos - zone.position.y)) < 150:
			newPos = randf_range(0, zoneLimit - 150)
		tween.tween_property(zone, "position:y", newPos, randf_range(1, 4))
	else:
		tween.tween_property(zone, "position:y", 300, 4)
	tween.tween_callback(func(): moving = false)
		
func Retry():
	SceneMan.ins.ChangeScene(SceneMan.ins.main)
