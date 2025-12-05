extends CheckBox

var gamecontroller
@export var linestate : Globals.transLines
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_toggled(toggled_on: bool) -> void:
	gamecontroller.toggleLinesVisibility(toggled_on, linestate)
