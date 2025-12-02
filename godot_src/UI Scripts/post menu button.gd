extends Button

var gamecontroller
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

func _pressed() -> void:
	print("I was Pressed")
	gamecontroller.setPause(true)
	gamecontroller.setDirectory("")
	gamecontroller.setInterval(0.5)
	gamecontroller.changeUIState(Globals.UI_state.Main_Menu)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
