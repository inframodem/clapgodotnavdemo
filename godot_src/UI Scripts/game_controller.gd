extends Node

@export var ui_controller: Control
@export var frameInterval = 0.5
@export var filePath = ""
@export var isPaused = true
@export var isCapturing = false
var sceneLoader : SubViewportContainer
var viewport : SubViewport
# Called when the node enters the scene tree for the first time.
@export var capturedFrame = 0
var sinceLastFrame = 0.0

@export var selectedScene : Globals.Scenes

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
		await get_tree().process_frame
		await get_tree().process_frame
		var frame = viewport.get_texture().get_image()
		frame.save_png(cpath + "/" + filePath + "-0.png")
		capturedFrame += 1
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
	
func stopCapture() -> void:
	isCapturing = false
	capturedFrame = 0

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

	
