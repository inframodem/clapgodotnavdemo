extends Button

@export var warninglabel : Label
var gamecontroller
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

func _pressed() -> void:
		var cpath = "user://" + gamecontroller.filePath
		if !DirAccess.dir_exists_absolute(cpath) || gamecontroller.filePath == "":
			warninglabel.text = "Directory doesn't Exists!"
			return
		gamecontroller.loadTransVectors()
		gamecontroller.setPause(false)
		gamecontroller.changeUIState(Globals.UI_state.Level_Post)
		gamecontroller.changeGameScene(gamecontroller.selectedScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
