# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC
extends Button

var gamecontroller
@export var nextUIState : Globals.UI_state
@export var shouldPause = true
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")
	if gamecontroller:
		print(self.name, " found the gamecontroller")
	else:
		print(self.name, " can't find the gamecontroller")

# Input Button is Pressed
#Output sets UI State to new uistate with little other actions
func _pressed() -> void:
	gamecontroller.changeUIState(nextUIState)
	gamecontroller.setPause(shouldPause)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
