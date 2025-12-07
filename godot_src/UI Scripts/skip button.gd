# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC
extends Button

var gamecontroller
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

# Input Button is Pressed
#Output sets UI State and scene to post free roam mode
func _pressed() -> void:
	print("I was Pressed")
	gamecontroller.setPause(false)
	gamecontroller.changeUIState(Globals.UI_state.Level_Post)
	gamecontroller.changeGameScene(gamecontroller.selectedScene)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
