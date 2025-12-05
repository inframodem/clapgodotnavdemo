extends Control

var gamecontroller
var fileCheckSecs = 5.0
var checkTracker = 0.0
var outputChecking
var cpath
var program
var isRunning = false;
# Called when the node enters the scene tree for the first time.
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
func _process(delta: float) -> void:
	if isRunning and checkTracker <= 0.0:
		checkForOutputs()
	elif isRunning:
		checkTracker -= delta

func checkForOutputs() -> void:
	if (FileAccess.file_exists(cpath + "/"+ gamecontroller.filePath + "_CLAP.txt") and 
	FileAccess.file_exists(cpath + "/"+ gamecontroller.filePath + "_RANSAC.txt")):
		gamecontroller.loadTransVectors()
		gamecontroller.setPause(false)
		gamecontroller.changeUIState(Globals.UI_state.Level_Post)
		gamecontroller.changeGameScene(gamecontroller.selectedScene)
