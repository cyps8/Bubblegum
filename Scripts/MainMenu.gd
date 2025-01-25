extends Node2D
var stage = 1
var visChar = 0
var alternate = 0.10
var talkSpeed = 0.05
var talking = false

func _ready():
	%Paper1.visible = true
	%Paper2.visible = true
	%Paper3.visible = true
	
func StartPressed():
	if talking:
		talkSpeed *= 0.5
		%Start.text = "HURRY UP"
	
	if stage == 1 && !talking:
		%Start.text = "CONTINUE"
		talking = true
		talkSpeed = 0.05
		var tween = create_tween()
		tween.tween_property(%Paper2, "position", Vector2(2500,1500), 1.5).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.parallel()
		tween.tween_property(%Paper1, "position", Vector2(%Paper1.position.x  - 1000,%Paper1.position.y ), 1.3).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.parallel()
		tween.tween_property(%Paper3, "position", Vector2(%Paper3.position.x,%Paper3.position.y - 1000), 1.1).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.parallel()
		tween.tween_property(%Wordart, "position", Vector2(%Wordart.position.x - 1500,%Wordart.position.y), 2).set_trans(tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_callback(StartToSpeak)
		
	if stage == 2 && !talking:
		%Start.text = "CONTINUE"
		visChar = 0
		talkSpeed = 0.05
		var whatHeSays = "I've been sluething through old case files at the presinct -\nbut I could not believe my eyes when I stumbled upon my greatest mystery yet."
		BGSpeak(whatHeSays, whatHeSays.length())
		
	if stage == 3 && !talking:
		%Start.text = "CONTINUE"
		visChar = 0
		talkSpeed = 0.05
		var whatHeSays = "The Case of the Stolen Bubblegum World Record."
		BGSpeak(whatHeSays, whatHeSays.length())
		
	if stage == 4 && !talking:
		%Start.text = "CONTINUE"
		visChar = 0
		talkSpeed = 0.05
		var whatHeSays = "TCotSBgWR for short."
		BGSpeak(whatHeSays, whatHeSays.length())
	# SceneMan.ins.ChangeScene(SceneMan.ins.game)

func StartToSpeak():
	visChar = 0
	var whatHeSays = "2004. California. Central Valley. \nIn a run-down city between The Armpit and the King's Canyon.\nIn a town of tumbleweeds and juicy fruit, where it never rains but the sun sure don't shine.\nThat was where our story began." 
	BGSpeak(whatHeSays, whatHeSays.length())
	
func BGSpeak(text:String, maxChar:int):
	talking = true
	visChar += 1
	alternate *= -1
	%Speech.visible_characters = visChar
	
	if visChar == maxChar:
		stage += 1
		talking = false
		%Start.text = "CONTINUE"
		return
	%Speech.text = text
	
	var speaking = create_tween()
	speaking.tween_property(%BubbleGumshoeUpper, "rotation", alternate, talkSpeed)
	speaking.tween_callback(BGSpeak.bind(text, text.length()))
