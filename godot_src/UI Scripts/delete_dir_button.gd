extends Button
@export var warning_text : Label
var gamecontroller : Node
var numPressed = 0
@export var revertCooldown = 10.0
var curCooldown = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

func _pressed() -> void:
	var dirName : String = gamecontroller.filePath
	if(dirName.length() < 5):
		warning_text.text = "Scene's Name needs to be greater than 5 characters!"
		return
	var cpath = "user://" + dirName
	
	if !DirAccess.dir_exists_absolute(cpath):
		warning_text.text = "Directory does not Exist!"
		return
	if numPressed <= 0:
		self.text = "Are you Sure?"
		curCooldown = revertCooldown
		numPressed += 1
		return
	elif numPressed > 0:
		gamecontroller.removeDirectory()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if numPressed > 0 and curCooldown <= 0:
		self.text = "Delete Scene"
		numPressed = 0
	elif numPressed > 0:
		curCooldown -= delta
		
