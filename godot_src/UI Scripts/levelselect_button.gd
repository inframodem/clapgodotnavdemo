extends Button

var gamecontroller
@export var scene : Globals.Scenes
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

func _pressed() -> void:
	gamecontroller.selectedScene = scene
	gamecontroller.changeUIState(Globals.UI_state.Level_Start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
