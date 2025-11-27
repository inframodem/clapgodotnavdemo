extends Node

enum UI_state { Main_Menu, Options, Level_Select, Level_Start, Level_Inprogress, Level_Loading, Level_Post }
@export var current_ui_state = UI_state.Main_Menu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
