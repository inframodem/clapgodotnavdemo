extends Button

var gamecontroller
@export var warninglabel : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

func _pressed() -> void:
	if gamecontroller.filePath.length() < 5:
		warninglabel.text = "Scene name needs to be at least 5 characters long!"
		return
	var cpath = "user://" + gamecontroller.filePath
	if DirAccess.dir_exists_absolute(cpath):
		warninglabel.text = "Directory already Exists!"
		return
	gamecontroller.startCapture()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
