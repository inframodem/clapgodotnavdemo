# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC

extends Button

var gamecontroller
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

#Input Button is pressed
#Output Clears gamecontroller variables and sets it to main menu
func _pressed() -> void:
	print("I was Pressed")
	gamecontroller.setPause(true)
	gamecontroller.setDirectory("")
	gamecontroller.setInterval(0.5)
	gamecontroller.clapVectList.clear()
	gamecontroller.RANSACVectList.clear()
	gamecontroller.ControlPosList.clear()
	gamecontroller.changeGameScene(Globals.Scenes.Blank)
	gamecontroller.changeUIState(Globals.UI_state.Main_Menu)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
