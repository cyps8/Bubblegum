extends Node

var stage = 1
var visChar = 0
var alternate = 0.10
var talkSpeed = 0.05
var talking = false
var rng = RandomNumberGenerator.new()
var timePassed = 0
var timeToNextTalk = 10

var stringsToSay = ["This city'll chew ya up and spit ya out faster than ya can say 'burst my bubble buddy'.", 
"There's three kinds a folk in this town: uptown folk, downtown folk and clowntown folk.", 
"Big Hats Off is the place to go if ya ever need a hat like mine.", 
"When the going gets tough, the tough get going and that is one tough bubble you've got going there", 
"Never underestimate the power of deduction. I used two half price coupons and got this hat for free.",
"Here's a tip: Chew it for a long time, until all the sugar is out.",
"Here's a tip: If you have long hair, pull it away from your face.",
"Here's a tip: ...Be patient.",]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timePassed += delta

	if timePassed > timeToNextTalk:
		# Every random number of seconds between 10 and 13
		timeToNextTalk = 1000
		

		# Tween him in
		var tween = create_tween()
		tween.tween_property(%BubbleGumshoeUpper, "position", Vector2(%BubbleGumshoeUpper.position.x,%BubbleGumshoeUpper.position.y + 100), 1).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.parallel()
		tween.tween_property(%BubbleGumshoeLower, "position", Vector2(%BubbleGumshoeLower.position.x,%BubbleGumshoeLower.position.y + 100), 1).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_callback(StartToSpeak)
	
	

	pass

func StartToSpeak():
	# Generate a random number
	# Play a random string
	visChar = 0
	var whatHeSays = stringsToSay[rng.rand_range(0, stringsToSay.count)] 
	BGSpeak(whatHeSays, whatHeSays.length())

func BGSpeak(text:String, maxChar:int):
	talking = true
	visChar += 1
	alternate *= -1
	%Speech.visible_characters = visChar
	
	if visChar == maxChar:
		var tween = create_tween()
		tween.tween_property(%BubbleGumshoeUpper, "position", Vector2(%BubbleGumshoeUpper.position.x,%BubbleGumshoeUpper.position.y - 100), 1).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.parallel()
		tween.tween_property(%BubbleGumshoeLower, "position", Vector2(%BubbleGumshoeLower.position.x,%BubbleGumshoeLower.position.y - 100), 1).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_callback(FinishTalking)
		return
	%Speech.text = text
	
	var speaking = create_tween()
	speaking.tween_property(%BubbleGumshoeUpper, "rotation", alternate, talkSpeed)
	speaking.tween_callback(BGSpeak.bind(text, text.length()))

func FinishTalking():
	visChar = 0
	timePassed = 0
	timeToNextTalk = rng.randf_range(10.0, 13.0)
