# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC
extends Button

var gamecontroller
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")
	if gamecontroller != null:
		print("Stop Capture found game controller")

# Input Button is Pressed
#Output sets UI State and scene to loading screen
func _pressed() -> void:
	print("I was Pressed")
	gamecontroller.stopCapture()
	gamecontroller.setPause(true)
	gamecontroller.changeUIState(Globals.UI_state.Level_Loading)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
