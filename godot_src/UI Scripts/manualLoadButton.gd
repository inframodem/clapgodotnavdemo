# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC

extends Button
var gamecontroller
@export var posLabel : Label
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

#Input Button is pressed
#Output Loads translation vectors and loads them into lines2d
func _pressed() -> void:
	gamecontroller.manualLoadLines()
	posLabel.loadFinalPoses()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
