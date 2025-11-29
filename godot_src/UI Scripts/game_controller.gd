extends Node

@export var ui_controller: Control
@export var frameInterval = 0.5
@export var filePath = ""
@export var isPaused = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_controller = get_node("/root/ui_level/CanvasLayer/UI_State Controller")
	ui_controller.debug()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func changeScene(newState: Globals.UI_state) -> void:
	ui_controller.changeScene(newState)
	
func setInterval(newInter: float) -> void:
	frameInterval = newInter
	
func setDirectory(newDir: String) -> void:
	filePath = newDir
	
func setPause(pause: bool) -> void:
	isPaused = pause
