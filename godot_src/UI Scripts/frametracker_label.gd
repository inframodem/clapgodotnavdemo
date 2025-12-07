# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC
extends Label

var gamecontroller
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#Input number of frames captured from game controlled
#Sets text to reflect input
func _process(delta: float) -> void:
	var numFrames : int = gamecontroller.capturedFrame
	self.text = "Frame: " + str(numFrames)
