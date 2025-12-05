extends Button
var gamecontroller
@export var posLabel : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

func _pressed() -> void:
	gamecontroller.manualLoadLines()
	posLabel.loadFinalPoses()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
