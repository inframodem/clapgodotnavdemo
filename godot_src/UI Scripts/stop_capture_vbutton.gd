extends Button

var gamecontroller
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")
	if gamecontroller != null:
		print("Stop Capture found game controller")

func _pressed() -> void:
	print("I was Pressed")
	gamecontroller.stopCapture()
	gamecontroller.setPause(true)
	gamecontroller.changeUIState(Globals.UI_state.Level_Loading)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
