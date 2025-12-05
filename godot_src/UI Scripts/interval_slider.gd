extends HSlider

var gamecontroller
@export var interLabel : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_drag_ended(value_changed: bool) -> void:
	if !value_changed:
		return
	interLabel.text = "Screenshot Interval: " + str(self.value) + " sec."
	gamecontroller.setInterval(self.value)
