# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC

#Behold the Game Controller it does everything behold bad software practices incarnate
#good thing I'm never updating this project
extends Node

@export var ui_controller: Control
@export var frameInterval = 0.5
@export var filePath = ""
@export var isPaused = true
@export var isCapturing = false
@export var capturedFrame = 0
@export var selectedScene : Globals.Scenes

var sceneLoader : SubViewportContainer
var viewport : SubViewport
# Called when the node enters the scene tree for the first time.

var sinceLastFrame = 0.0
@export var clapVectList : PackedVector2Array
@export var RANSACVectList : PackedVector2Array
@export var ControlPosList : PackedVector2Array

var cameraControl : CharacterBody2D

var controlLines : Line2D
var CLAPLines : Line2D
var RANSACLines : Line2D

var opencvPath : String


#Input Gets all other main Ui State components
#Output stores the nodes locally
func _ready() -> void:
	ui_controller = get_node("/root/ui_level/CanvasLayer/UI_State Controller")
	ui_controller.debug()
	sceneLoader = get_node("/root/ui_level/CanvasLayer/SubViewportContainer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#input checks to see if the gamecontroller should be capturing frames
#output creates a new screen shot and stores new translation vector
func _process(delta: float) -> void:
	if isCapturing:
		captureProcess(delta)

#input UI State Enum value
#output Changes UI state to another one
func changeUIState(newState: Globals.UI_state) -> void:
	ui_controller.changeScene(newState)

#input capture frame interval float
#output local frame interval set
func setInterval(newInter: float) -> void:
	frameInterval = newInter

#input capture frame save path string
#output scene's output path is saved locally
func setDirectory(newDir: String) -> void:
	filePath = newDir

#Input Boolean on camera movement pause
#Output determines if the camera can be moved
func setPause(pause: bool) -> void:
	isPaused = pause

#Input Scene Enum Value
#Output Changes the current scene to the scene the enum represents
func changeGameScene(cScene : Globals.Scenes) -> bool:
	var status : bool = sceneLoader.loadScene(cScene)
	if status:
		print("Successfully Changed Scene")
		return status
	else:
		print("Failed to Change Scene")
		return status

#Input Called from Start Scene Button
#Output Starts 
func startCapture() -> bool:
	var cpath = "user://" + filePath
	if DirAccess.dir_exists_absolute(cpath):
		return false
	var status = changeGameScene(selectedScene)
	if status:
		viewport = sceneLoader.getSubViewport()
		DirAccess.make_dir_recursive_absolute(cpath)
		changeUIState(Globals.UI_state.Level_Inprogress)
		#make frame 0
		#go through a couple frames make sure everything is rendering
		await get_tree().process_frame
		await get_tree().process_frame
		#get 
		var frame = viewport.get_texture().get_image()
		frame.save_png(cpath + "/" + filePath + "-0.png")
		capturedFrame += 1
		ControlPosList.append(Vector2(0.0, 0.0))
		isPaused = false
		isCapturing = true
	return status

#input checks to see if the gamecontroller should be capturing frames
#output creates a new screen shot and stores new translation vector
func captureProcess(delta: float) -> void:
	sinceLastFrame += delta
	if sinceLastFrame < frameInterval:
		return
	sinceLastFrame = 0.0
	var cpath = "user://" + filePath
	var frame = viewport.get_texture().get_image()
	frame.save_png(cpath + "/" + filePath + "-" + str(capturedFrame) + ".png")
	capturedFrame += 1
	LogControlPos()

#input Called by Stop Capture Button
#output Stops Capturing in _process function
func stopCapture() -> void:
	isCapturing = false
	capturedFrame = 0
	sinceLastFrame = 0.0
	
#input Called in Delete Scene Button
#output removes current filePath Directory Recursively
func removeDirectory() -> bool:
	var cpath = "user://" + filePath 
	if !DirAccess.dir_exists_absolute(cpath):
		return false
	delete_dir_recursive(cpath)
	return true

#input Called in Delete Scene Button
#output removes current filePath Directory Recursively
func delete_dir_recursive(path: String) -> void:
	var d := DirAccess.open(path)
	if d == null:
		return
		
	d.list_dir_begin()
	var item := d.get_next()
	while item != "":
		if item in [".", ".."]:
			item = d.get_next()
			continue
		
		var full_path := path + "/" + item
		if d.current_is_dir():
			delete_dir_recursive(full_path)
		else:
			DirAccess.remove_absolute(full_path)
		item = d.get_next()
	DirAccess.remove_absolute(path)

#input Called in Loaded Scene from the Character Controller
#output sets cameraController for logging Positions
func characterSetter(body : CharacterBody2D):
	cameraControl = body

#input Called in captureProcess function
#output logs transform position cameraController for translation vector list rounded to nearest pixel
func LogControlPos() -> void:
	if cameraControl == null:
		return
	ControlPosList.append(round(cameraControl.position))
	print("logging: " + str(cameraControl.position))

#input Called in capture stop button
#output Creates the text file of control vectors
func exportControlList() -> void:
	var controlVecLines = []
	if ControlPosList.size() < 2:
		return
	var pos1 = Vector2(0.0, 0.0)
	var pos2 : Vector2
	for pos in range(1, ControlPosList.size()):
		pos2 = ControlPosList[pos]
		var translationVector = Vector2(pos2.x - pos1.x, pos2.y - pos1.y)
		controlVecLines.append(translationVector)
		pos1 = pos2
	var Lines = []
	var cpath = "user://" + filePath
	if !DirAccess.dir_exists_absolute(cpath):
		return
	var writePath = "user://" + filePath + "/" + filePath + "_CONTROL.txt"
	for vect in range(0, controlVecLines.size()):
		Lines.append("directoryName-" + str(vect) + ".png" + " > " +
		 "directoryName-" + str(vect + 1) + ".png : " + str(controlVecLines[vect].x) + " " + str(controlVecLines[vect].y))
	var file = FileAccess.open(writePath, FileAccess.WRITE)
	for line in Lines:
		file.store_line(line)
	file.close()
	
#input Called in scene loading controller
#output Opens up a file explorer of the Scene Folder
func openSceneFolder() -> void:
	var cpath = "user://" + filePath
	if !DirAccess.dir_exists_absolute(cpath):
		return
	OS.shell_open(ProjectSettings.globalize_path(cpath))

#input Called in scene loading controller
#output Executes OpenCV Program that creates translation vector data
func getOpenCVProgram() -> bool:
	var exeDir = OS.get_executable_path().get_base_dir()
	var exeFilepath = exeDir + "/opencvclap.exe"
	if FileAccess.file_exists(exeFilepath):
		return true
	else:
		return false

#input Called in scene loading controller
#output Executes OpenCV Program that creates translation vector data
func executeOpenCVProgram() -> bool:
	var exeDir = OS.get_executable_path().get_base_dir()
	var exeFilepath = exeDir + "/opencvclap.exe"
	var cpath = "user://" + filePath
	if getOpenCVProgram():
		OS.create_process(exeFilepath, [ ProjectSettings.globalize_path(cpath), "clap_ransac" ], true)
		return true
	else:
		return false
		
#input Called in loadTransVectors function
#output Creates a Vector2Array of positions from translation vectors
func readFile(currFile : FileAccess) -> PackedVector2Array:
	var retArray : PackedVector2Array
	retArray.append(Vector2(0.0, 0.0))
	if currFile == null:
		return retArray
	while not currFile.eof_reached():
		var line = currFile.get_line()
		
		if line.strip_edges().is_empty():
			continue
		var parts = line.split(" ", false)
		
		var posVect : Vector2 = retArray[-1]
		posVect.x = posVect.x + float(parts[-2])
		posVect.y = posVect.y + float(parts[-1])
		retArray.push_back(posVect)
	currFile.close()
	return retArray

#input Called in a bunch of different buttons and nodes in Scene Post UI and scene 
#output Creates a Vector2Array of positions from translation vectors in game controller for extraction
func loadTransVectors() -> void:
	var cpath = "user://" + filePath
	if !DirAccess.dir_exists_absolute(cpath):
		return
	if FileAccess.file_exists(cpath + "/" + filePath + "_CONTROL.txt"):
		var controlFile = FileAccess.open(cpath + "/" + filePath + "_CONTROL.txt", FileAccess.READ)
		ControlPosList = readFile(controlFile)
	if FileAccess.file_exists(cpath + "/" + filePath + "_CLAP.txt"):
		var clapFile = FileAccess.open(cpath + "/" + filePath + "_CLAP.txt", FileAccess.READ)
		clapVectList = readFile(clapFile)
	if FileAccess.file_exists(cpath + "/" + filePath + "_RANSAC.txt"):
		var ransacFile = FileAccess.open(cpath + "/" + filePath + "_RANSAC.txt", FileAccess.READ)
		RANSACVectList = readFile(ransacFile)

#input Called in line2ds in scene space for displaying path using Enum of transLines
#output Returns held Vector2Array in game controller 
func retrieveVec2Array(arr : Globals.transLines) -> PackedVector2Array:
	match arr:
		Globals.transLines.ControlLines:
			return ControlPosList
		Globals.transLines.RANSACLines:
			return RANSACVectList
		Globals.transLines.CLAPLines:
			return clapVectList
		_:
			return []

#input Called in line2ds to determine if they should display lines
#output current UI State enum held by UI State Controller
func getCurrentUISTATE() -> Globals.UI_state:
	return ui_controller.current_ui_state

#input Called in lines2d to set self in gamecontroller
#output gamecontroller holds the input line2d
func setLines(arr : Globals.transLines, lines : Line2D) -> void:
	match arr:
		Globals.transLines.ControlLines:
			controlLines = lines
		Globals.transLines.RANSACLines:
			CLAPLines = lines
		Globals.transLines.CLAPLines:
			RANSACLines = lines

#input Called in checkboxes to determine if Lines should be visible based on enum
#output changes lines visibility based on enum
func toggleLinesVisibility(toggle : bool, arr : Globals.transLines) -> void:
		match arr:
			Globals.transLines.ControlLines:
				controlLines.visible = toggle
			Globals.transLines.RANSACLines:
				CLAPLines.visible = toggle
			Globals.transLines.CLAPLines:
				RANSACLines.visible = toggle

#input Called in load translation vectors 
#output Reloads point vectors in line2d to display them
func manualLoadLines() -> void:
	loadTransVectors()
	controlLines.manualLoadLines()
	RANSACLines.manualLoadLines()
	CLAPLines.manualLoadLines()
