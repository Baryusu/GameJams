extends Area2D

@export_file("*.tscn") var target_scene: String
@export var target_spawn_point: String = "SpawnPoint"

@export var required_flag: String = ""
@export var locked_dialogue_file: DialogueResource
@export var locked_dialogue_title: String = "start"

var showInteractionLabel := false

func _ready() -> void:
	# --- NEW: AUTO-CONNECT SIGNALS ---
	# This ensures the door always works, even if the Editor disconnects it!
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _process(_delta):
	$Label.visible = showInteractionLabel
	
	if showInteractionLabel and Input.is_action_just_pressed("interact"):
		try_open_door()

func _on_body_entered(body: Node2D) -> void:
	# --- NEW: BULLETPROOF PLAYER CHECK ---
	# Checks for both spellings so it doesn't break!
	if body.name == "Player" or body.name == "player": 
		showInteractionLabel = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body.name == "player": 
		showInteractionLabel = false
	
func try_open_door() -> void:
	if required_flag != "" and GlobalData.get(required_flag) == false:
		if locked_dialogue_file != null:
			DialogueManager.show_example_dialogue_balloon(locked_dialogue_file, locked_dialogue_title)
		return 

	if target_scene == "":
		print("No door available")
	else:
		var gameplay_manager = get_tree().current_scene
		
		if gameplay_manager != null and gameplay_manager.has_method("load_area"):
			gameplay_manager.load_area(target_scene, target_spawn_point)
