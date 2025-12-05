extends Label

var gamecontroller
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")
	loadFinalPoses()
		
func loadFinalPoses():
	var labeltext = ""
	if gamecontroller.clapVectList.size() > 0:
		var finalpos : Vector2 = gamecontroller.clapVectList[-1]
		labeltext += "CLAP: " + str(finalpos) + "\n"
	if gamecontroller.RANSACVectList.size() > 0:
		var finalpos : Vector2 = gamecontroller.RANSACVectList[-1]
		labeltext += "Ransac: " + str(finalpos) + "\n"
	if gamecontroller.ControlPosList.size() > 0:
		var finalpos : Vector2 = gamecontroller.ControlPosList[-1]
		labeltext += "Control: " + str(finalpos) + "\n"
	self.text = labeltext
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
