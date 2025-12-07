# Open CV Project: 12/1/2025
# Generates screenshots to use in OpenCV to process them with CLAP and RANSAC

extends CharacterBody2D


@export var SPEED = 100.0
var gamecontroller

func _ready() -> void:
	gamecontroller = get_tree().get_current_scene().get_node("Game Controller")
	gamecontroller.characterSetter(self)

#Called every Frame inputs deltaTime between each frame and outputs nothing but moves attached Collider
func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	var isPaused = gamecontroller.isPaused
	var directiony := Input.get_axis("camera_up", "camera_down")
	var directionx := Input.get_axis("camera_left", "camera_right")
	if directionx and !isPaused:
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directiony and !isPaused:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
