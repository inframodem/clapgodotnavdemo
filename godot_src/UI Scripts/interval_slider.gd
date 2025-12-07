# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC
extends HSlider

var gamecontroller
@export var interLabel : Label
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Input The slider is moved
#Output sets Gamecontroller's capture interval to this slider's value
func _on_drag_ended(value_changed: bool) -> void:
	if !value_changed:
		return
	interLabel.text = "Screenshot Interval: " + str(self.value) + " sec."
	gamecontroller.setInterval(self.value)
