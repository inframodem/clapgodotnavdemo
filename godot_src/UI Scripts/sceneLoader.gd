extends SubViewportContainer

var currentScene : Node2D
var viewport : SubViewport
var scenePathList = []
var cameraScaleList = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport = get_node("SubViewport")
	cameraScaleList.append(1)
	scenePathList.append("")
	cameraScaleList.append(3)
	scenePathList.append("res://Main Scenes/dungeon_scene.tscn")
	cameraScaleList.append(1)
	scenePathList.append("res://Main Scenes/park_scene.tscn")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loadScene(nextScene : Globals.Scenes) -> bool:
	var hasLoaded = false
	if(viewport.get_children().size() > 0):
		var cscene = viewport.get_child(0)
		viewport.remove_child(cscene)
	if nextScene == Globals.Scenes.Blank:
		self.stretch_shrink = cameraScaleList[Globals.Scenes.Blank]
		hasLoaded = true
	else:
		self.stretch_shrink = cameraScaleList[nextScene]
		ResourceLoader.load_threaded_request(scenePathList[nextScene])
		while true:
			var status := ResourceLoader.load_threaded_get_status(scenePathList[nextScene])
			if status == ResourceLoader.THREAD_LOAD_LOADED:
				break
			await get_tree().process_frame

		var packedScene : PackedScene = ResourceLoader.load_threaded_get(scenePathList[nextScene])
		var sceneInstance = packedScene.instantiate()
		viewport.add_child(sceneInstance)
		hasLoaded = true
	return hasLoaded

func getSubViewport() -> SubViewport:
	return viewport
