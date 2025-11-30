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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var axisy = Input.get_axis("camera_up", "camera_down")
	var axisx = Input.get_axis("camera_left", "camera_right")
	
	if axisy > 0:
		lastAnimationState = 0
		self.texture = runDown
	elif axisy < 0:
		lastAnimationState = 1
		self.texture = runUp
	elif axisx < 0:
		lastAnimationState = 2
		self.texture = runLeft
	elif axisx > 0:
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
