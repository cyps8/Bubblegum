class_name SceneMan extends Node

@export var skipMenu: bool = false

@export var main: PackedScene

@export var game: PackedScene

var currentScene: Node2D

static var ins: SceneMan

var record: float = 26

func _init():
	ins = self

func _ready():
	if skipMenu:
		ChangeScene(game)
	else:
		ChangeScene(main)

func ChangeScene(scene: PackedScene):
	if currentScene != null:
		remove_child(currentScene)
		currentScene.queue_free()
	var newScene = scene.instantiate() as Node2D
	add_child(newScene)
	currentScene = newScene