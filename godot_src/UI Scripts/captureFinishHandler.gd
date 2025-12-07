# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC
extends Control

var gamecontroller
var fileCheckSecs = 5.0
var checkTracker = 0.0
var outputChecking
var cpath
var program
var isRunning = false;
# Called when the node enters the scene tree for the first time.
# Input checks to see if OpenCV program exists
#Output: Executes the program and produces the translation data
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")
	gamecontroller.exportControlList()
	gamecontroller.openSceneFolder()
	checkTracker = fileCheckSecs
	cpath = "user://" + gamecontroller.filePath
	if(gamecontroller.getOpenCVProgram()):
		gamecontroller.executeOpenCVProgram()
		isRunning = true
	else: 
		print("OpenCV Program Not Found")
		gamecontroller.setPause(false)
		gamecontroller.changeUIState(Globals.UI_state.Level_Post)
		gamecontroller.changeGameScene(gamecontroller.selectedScene)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#Input deltaTime 
#Output Changes scene if outputs are found
func _process(delta: float) -> void:
	if isRunning and checkTracker <= 0.0:
		checkForOutputs()
	elif isRunning:
		checkTracker -= delta

#Inputs directory path from gamecontroller
#Output Changes scene if found
func checkForOutputs() -> void:
	if (FileAccess.file_exists(cpath + "/"+ gamecontroller.filePath + "_CLAP.txt") and 
	FileAccess.file_exists(cpath + "/"+ gamecontroller.filePath + "_RANSAC.txt")):
		gamecontroller.loadTransVectors()
		gamecontroller.setPause(false)
		gamecontroller.changeUIState(Globals.UI_state.Level_Post)
		gamecontroller.changeGameScene(gamecontroller.selectedScene)
