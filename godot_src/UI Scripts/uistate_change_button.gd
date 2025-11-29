extends Button

var gamecontroller
@export var nextUIState : Globals.UI_state
@export var shouldPause = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")
	if gamecontroller:
		print(self.name, " found the gamecontroller")
	else:
		print(self.name, " can't find the gamecontroller")

func _pressed() -> void:
	gamecontroller.changeScene(nextUIState)
	gamecontroller.setPause(shouldPause)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
