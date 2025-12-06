extends Button

# Export variables to configure in the editor
@export var action_name: String = "move_forward"
@export_enum("Keyboard", "Controller") var input_type: String = "Keyboard"

var is_remapping: bool = false

func _ready():
	pressed.connect(_on_button_pressed)
	update_button_text()

func update_button_text():
	var events = InputMap.action_get_events(action_name)
	var display_text = "Not Bound"
	
	for event in events:
		if input_type == "Keyboard" and event is InputEventKey:
			display_text = OS.get_keycode_string(event.physical_keycode)
			break
		elif input_type == "Controller" and event is InputEventJoypadButton:
			display_text = "Button " + str(event.button_index)
			break
		elif input_type == "Controller" and event is InputEventJoypadMotion:
			var direction = "+" if event.axis_value > 0 else "-"
			display_text = "Axis " + str(event.axis) + direction
			break
	
	text = display_text

func _on_button_pressed():
	if not is_remapping:
		is_remapping = true
		text = "Press any key..." if input_type == "Keyboard" else "Press any button..."

func _input(event):
	if not is_remapping:
		return
	
	var should_remap = false
	
	if input_type == "Keyboard" and event is InputEventKey and event.pressed:
		should_remap = true
	elif input_type == "Controller" and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		if event is InputEventJoypadButton and event.pressed:
			should_remap = true
		elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.5:
			should_remap = true
	
	if should_remap:
		remap_action(event)
		is_remapping = false
		update_button_text()
		get_viewport().set_input_as_handled()

func remap_action(new_event: InputEvent):
	# Get all current events for this action
	var events = InputMap.action_get_events(action_name)
	
	# Only remove events that match our input_type
	for event in events:
		if input_type == "Keyboard" and event is InputEventKey:
			# Remove only keyboard events
			InputMap.action_erase_event(action_name, event)
		elif input_type == "Controller":
			# Remove only controller events (buttons and axes)
			if event is InputEventJoypadButton or event is InputEventJoypadMotion:
				InputMap.action_erase_event(action_name, event)
	
	# Add the new event (this preserves events of the other type)
	InputMap.action_add_event(action_name, new_event)
