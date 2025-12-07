# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC

extends TextureRect
@export var idleDown: Texture
@export var idleUp: Texture
@export var idleLeft: Texture
@export var idleRight: Texture

@export var runDown: Texture
@export var runUp: Texture
@export var runLeft: Texture
@export var runRight: Texture

var lastAnimationState := 0
var gamecontroller : Node
# Input Gets gamecontroller
#Output sets Gamecontroller locally
func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#Input Input mapped controls are pressed
#Output Sets player animation to "simulate" a character to display collider
func _process(delta: float) -> void:
	var isPaused = gamecontroller.isPaused
	var axisy = Input.get_axis("camera_up", "camera_down")
	var axisx = Input.get_axis("camera_left", "camera_right")
	
	if axisy > 0 and !isPaused:
		lastAnimationState = 0
		self.texture = runDown
	elif axisy < 0 and !isPaused:
		lastAnimationState = 1
		self.texture = runUp
	elif axisx < 0 and !isPaused:
		lastAnimationState = 2
		self.texture = runLeft
	elif axisx > 0 and !isPaused:
		lastAnimationState = 3
		self.texture = runRight
	else: 
		match lastAnimationState:
			0:
				self.texture = idleDown
			1:
				self.texture = idleUp
			2:
				self.texture = idleLeft
			3:
				self.texture = idleRight

func animationController() -> void:
	pass
