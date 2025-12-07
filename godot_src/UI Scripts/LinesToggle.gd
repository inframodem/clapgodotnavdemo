# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC

extends CheckBox

var gamecontroller
@export var linestate : Globals.transLines
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Input Checkbox is pressed
#Output Changes Line Visibility for the line enum held
func _on_toggled(toggled_on: bool) -> void:
	gamecontroller.toggleLinesVisibility(toggled_on, linestate)
