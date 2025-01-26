extends Node

var stage = 1
var visChar = 0
var alternate = 0.10
var talkSpeed = 0.05
var talking = false
var rng = RandomNumberGenerator.new()
var timePassed = 0
var timeToNextTalk = 15

var stringsToSay: Array = ["This city'll chew ya up and spit ya out faster than ya can say 'burst my bubble buddy'.", 
"There's three kinds a folk in this town: uptown folk, downtown folk and clowntown folk.", 
"Big Hats Off is the place to go if ya ever need a hat like mine.", 
"When the going gets tough, the tough get going and that is one tough bubble you've got going there", 
"Never underestimate the power of deduction. I used two half price coupons and got this hat for free.",
"Here's a tip: Chew it for a long time, until all the sugar is out.",
"Here's a tip: If you have long hair, pull it away from your face.",
"Here's a tip: ...Be patient.",]

var tutorial = true

var yapping = false

var ending = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%BubbleGumshoeUpper.position.x += 250
	%BubbleGumshoeLower.position.x += 250
	ComeIn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timePassed += delta
	if timePassed > timeToNextTalk && !Game.ins.popped:
		# Every random number of seconds between 10 and 13
		timeToNextTalk = 1000
		ComeIn()
	if Game.ins.popped && !ending && !yapping:
		ComeIn()
		ending = true

func ComeIn():
	yapping = true
	# Tween him in
	var tween = create_tween()
	tween.tween_property(%BubbleGumshoeUpper, "position", Vector2(%BubbleGumshoeUpper.position.x - 250,%BubbleGumshoeUpper.position.y), 1).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property(%BubbleGumshoeLower, "position", Vector2(%BubbleGumshoeLower.position.x - 250,%BubbleGumshoeLower.position.y), 1).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_callback(StartToSpeak)

func StartToSpeak():
	# Generate a random number
	# Play a random string
	visChar = 0
	var whatHeSays: String = ""
	if tutorial == true:
		whatHeSays = "Blow into your microphone to blow the bubblegum, keep the bubble in the zone"
		tutorial = false
	elif ending:
		whatHeSays = "In spite of the bubble's humongous, enormous size... there were no witnesses.
...The case went cold."
	else:
		whatHeSays = stringsToSay.pick_random()
	BGSpeak(whatHeSays, whatHeSays.length())

func BGSpeak(text:String, maxChar:int):
	talking = true
	visChar += 1
	alternate *= -1
	%Speech.visible_characters = visChar
	
	if visChar == maxChar && !ending:
		var tween = create_tween()
		tween.tween_property(%BubbleGumshoeUpper, "position", Vector2(%BubbleGumshoeUpper.position.x + 250,%BubbleGumshoeUpper.position.y), 1).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.parallel()
		tween.tween_property(%BubbleGumshoeLower, "position", Vector2(%BubbleGumshoeLower.position.x + 250,%BubbleGumshoeLower.position.y), 1).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_callback(FinishTalking)
		return
	%Speech.text = text
	
	if visChar == maxChar:
		return

	var speaking = create_tween()
	speaking.tween_property(%BubbleGumshoeUpper, "rotation", alternate, talkSpeed)
	speaking.tween_callback(BGSpeak.bind(text, text.length()))

func FinishTalking():
	visChar = 0
	%Speech.visible_characters = visChar
	timePassed = 0
	timeToNextTalk = rng.randf_range(10.0, 13.0)
	yapping = false
