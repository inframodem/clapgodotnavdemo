extends Line2D

@export var LinesRepresent : Globals.transLines
var gamecontroller
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")
	if gamecontroller.getCurrentUISTATE() == Globals.UI_state.Level_Post:
		gamecontroller.setLines(LinesRepresent, self)
		self.points = gamecontroller.retrieveVec2Array(LinesRepresent)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func manualLoadLines() -> void:
	self.points = gamecontroller.retrieveVec2Array(LinesRepresent)
