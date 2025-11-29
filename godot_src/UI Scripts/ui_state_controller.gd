extends Control

var scenes = []
var currentLoadedScene
@export var current_ui_state = Globals.UI_state.Main_Menu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scenes.append(preload("res://UI Instances/Main Menu.tscn").instantiate())
	scenes.append(preload("res://UI Instances/Options.tscn").instantiate())
	scenes.append(preload("res://UI Instances/Level Select.tscn").instantiate())
	scenes.append(preload("res://UI Instances/Scene_Start.tscn").instantiate())
	scenes.append(preload("res://UI Instances/Scene_Loading.tscn").instantiate())
	scenes.append(preload("res://UI Instances/Scene_Post.tscn").instantiate())
	currentLoadedScene = get_child(0)
	

func changeScene(newState: Globals.UI_state) -> void:
	remove_child(currentLoadedScene)
	add_child(scenes[newState])
	currentLoadedScene = get_child(0)
	
func debug() -> void:
	print("ui_control is accessible")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
