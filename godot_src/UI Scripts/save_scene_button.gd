# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC
extends Button

var gamecontroller
@export var warninglabel : Label
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

#Input Button is pressed
#Output Starts scene and frame capture process
func _pressed() -> void:
	if gamecontroller.filePath.length() < 5:
		warninglabel.text = "Scene name needs to be at least 5 characters long!"
		return
	var cpath = "user://" + gamecontroller.filePath
	if DirAccess.dir_exists_absolute(cpath):
		warninglabel.text = "Directory already Exists!"
		return
	await gamecontroller.startCapture()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
