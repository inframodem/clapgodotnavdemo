# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC

extends Button

var gamecontroller
@export var scene : Globals.Scenes
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

#Input Button is pressed
#Output Changes UI State and sets game controller scene it should load 
func _pressed() -> void:
	gamecontroller.selectedScene = scene
	gamecontroller.changeUIState(Globals.UI_state.Level_Start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
