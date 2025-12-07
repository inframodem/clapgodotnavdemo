# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC

extends Line2D

@export var LinesRepresent : Globals.transLines
var gamecontroller
# Called when the node enters the scene tree for the first time.

#Gets translation data from gamecontroller and sets self to retrieved points as self
#Inputs points retrieved from gamecontroller
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")
	#Ignore if the scene is capturing
	if gamecontroller.getCurrentUISTATE() == Globals.UI_state.Level_Post:
		gamecontroller.setLines(LinesRepresent, self)
		self.points = gamecontroller.retrieveVec2Array(LinesRepresent)

# Not used
func _process(delta: float) -> void:
	pass

#Just Calls Game Controllers retrieveVec2Array inputs: Nothing but is called by Gamecontroller like a loathsome oroboros
#outputs Nothing but sets self's points to retrieved Vec2Array
func manualLoadLines() -> void:
	self.points = gamecontroller.retrieveVec2Array(LinesRepresent)
