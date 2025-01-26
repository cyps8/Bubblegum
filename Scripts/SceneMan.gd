class_name SceneMan extends Node

@export var main: PackedScene

@export var game: PackedScene

var currentScene: Node2D

static var ins: SceneMan

func _init():
	ins = self

func _ready():
	ChangeScene(game)

func ChangeScene(scene: PackedScene):
	if currentScene != null:
		remove_child(currentScene)
		currentScene.queue_free()
	var newScene = scene.instantiate() as Node2D
	add_child(newScene)
	currentScene = newScene