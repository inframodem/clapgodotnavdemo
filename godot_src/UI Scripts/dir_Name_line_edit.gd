extends LineEdit
var gamecontroller

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	print(gamecontroller.filePath)
