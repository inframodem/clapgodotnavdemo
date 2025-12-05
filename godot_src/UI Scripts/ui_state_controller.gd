extends Control

var scenes = []
var currentLoadedScene
@export var current_ui_state = Globals.UI_state.Main_Menu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scenes.append(preload("res://UI Instances/Main Menu.tscn"))
	scenes.append(preload("res://UI Instances/Options.tscn"))
	scenes.append(preload("res://UI Instances/Level Select.tscn"))
	scenes.append(preload("res://UI Instances/Scene_Start.tscn"))
	scenes.append(preload("res://UI Instances/Scene_Inprogress.tscn"))
	scenes.append(preload("res://UI Instances/Scene_Loading.tscn"))
	scenes.append(preload("res://UI Instances/Scene_Post.tscn"))
	currentLoadedScene = get_child(0)
	

func changeScene(newState: Globals.UI_state) -> void:
	current_ui_state = newState
	remove_child(currentLoadedScene)
	var newUI = scenes[newState].instantiate()
	add_child(newUI)
	currentLoadedScene = get_child(0)
	
func debug() -> void:
	print("ui_control is accessible")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
