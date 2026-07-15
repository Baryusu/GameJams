extends Node2D 

@onready var bounds = $CameraBoundaries

# --- DIALOGUE MANAGER ADD-ON VARIABLES ---
# This lets you drag and drop your .dialogue file into the Inspector
@export var dialogue_file: DialogueResource
# This lets you type the specific starting node (e.g., "start_outside_house")
@export var dialogue_title: String = ""

func _ready() -> void:
	# --- YOUR EXISTING CAMERA LOGIC ---
	var camera = get_viewport().get_camera_2d()
	if camera and bounds:
		camera.limit_left = int(bounds.global_position.x)
		camera.limit_top = int(bounds.global_position.y)
		camera.limit_right = int(bounds.global_position.x + bounds.size.x)
		camera.limit_bottom = int(bounds.global_position.y + bounds.size.y)
		
	# --- NEW: TRIGGER THE ADD-ON ---
	# Only play if you actually assigned a file AND a title in the Inspector
	if dialogue_file != null and dialogue_title != "":
		play_opening_monologue()

func play_opening_monologue() -> void:
	# Wait a half second for the screen to fade in/load
	await get_tree().create_timer(1.5).timeout
	
	# Call the add-on's built-in balloon function
	# (Note: If your add-on uses a different function name to show the balloon, use that here!)
	DialogueManager.show_example_dialogue_balloon(dialogue_file, dialogue_title)
