# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC
extends Button

@export var warninglabel : Label
var gamecontroller
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

#Input Button is pressed
#Output Changes UI State and sets game controller scene it should load and sets up lines2d
func _pressed() -> void:
		var cpath = "user://" + gamecontroller.filePath
		if !DirAccess.dir_exists_absolute(cpath) || gamecontroller.filePath == "":
			warninglabel.text = "Directory doesn't Exists!"
			return
		gamecontroller.loadTransVectors()
		gamecontroller.setPause(false)
		gamecontroller.changeUIState(Globals.UI_state.Level_Post)
		gamecontroller.changeGameScene(gamecontroller.selectedScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
