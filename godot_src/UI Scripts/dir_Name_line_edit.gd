# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC
extends LineEdit
var gamecontroller

# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Input: User changes text in line edit
#Output: Sets scene path in game controller
func _on_text_changed(new_text: String) -> void:
	if new_text.length() <= 0:
		return
	
	var regex = RegEx.new()
	regex.compile("^[A-Za-z0-9_]+$")
	var lastchar = new_text[-1]
	if not regex.search(lastchar):
		self.text = new_text.substr(0, new_text.length() - 1)
		self.caret_column = new_text.length()
		
	gamecontroller.setDirectory(self.text)
	#print(gamecontroller.filePath)
