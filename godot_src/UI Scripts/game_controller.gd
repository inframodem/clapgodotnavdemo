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



func _ready() -> void:

	ui_controller = get_node("/root/ui_level/CanvasLayer/UI_State Controller")
	ui_controller.debug()
	sceneLoader = get_node("/root/ui_level/CanvasLayer/SubViewportContainer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isCapturing:
		captureProcess(delta)
	
func changeUIState(newState: Globals.UI_state) -> void:
	ui_controller.changeScene(newState)
	
func setInterval(newInter: float) -> void:
	frameInterval = newInter
	
func setDirectory(newDir: String) -> void:
	filePath = newDir
	
func setPause(pause: bool) -> void:
	isPaused = pause

func changeGameScene(cScene : Globals.Scenes) -> bool:
	var status : bool = sceneLoader.loadScene(cScene)
	if status:
		print("Successfully Changed Scene")
		return status
	else:
		print("Failed to Change Scene")
		return status

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
	
func stopCapture() -> void:
	isCapturing = false
	capturedFrame = 0
	sinceLastFrame = 0.0
	

func removeDirectory() -> bool:
	var cpath = "user://" + filePath 
	if !DirAccess.dir_exists_absolute(cpath):
		return false
	delete_dir_recursive(cpath)
	return true

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

func characterSetter(body : CharacterBody2D):
	cameraControl = body

func LogControlPos() -> void:
	if cameraControl == null:
		return
	ControlPosList.append(round(cameraControl.position))
	print("logging: " + str(cameraControl.position))

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
	
func openSceneFolder() -> void:
	var cpath = "user://" + filePath
	if !DirAccess.dir_exists_absolute(cpath):
		return
	OS.shell_open(ProjectSettings.globalize_path(cpath))

func getOpenCVProgram() -> bool:
	var exeDir = OS.get_executable_path().get_base_dir()
	var exeFilepath = exeDir + "/opencvclap.exe"
	if FileAccess.file_exists(exeFilepath):
		return true
	else:
		return false
		
func executeOpenCVProgram() -> bool:
	var exeDir = OS.get_executable_path().get_base_dir()
	var exeFilepath = exeDir + "/opencvclap.exe"
	var cpath = "user://" + filePath
	if getOpenCVProgram():
		OS.create_process(exeFilepath, [ ProjectSettings.globalize_path(cpath), "clap_ransac" ], true)
		return true
	else:
		return false
		
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
			
func getCurrentUISTATE() -> Globals.UI_state:
	return ui_controller.current_ui_state

func setLines(arr : Globals.transLines, lines : Line2D) -> void:
	match arr:
		Globals.transLines.ControlLines:
			controlLines = lines
		Globals.transLines.RANSACLines:
			CLAPLines = lines
		Globals.transLines.CLAPLines:
			RANSACLines = lines
			
func toggleLinesVisibility(toggle : bool, arr : Globals.transLines) -> void:
		match arr:
			Globals.transLines.ControlLines:
				controlLines.visible = toggle
			Globals.transLines.RANSACLines:
				CLAPLines.visible = toggle
			Globals.transLines.CLAPLines:
				RANSACLines.visible = toggle

func manualLoadLines() -> void:
	loadTransVectors()
	controlLines.manualLoadLines()
	RANSACLines.manualLoadLines()
	CLAPLines.manualLoadLines()
