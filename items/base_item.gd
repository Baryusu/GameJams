class_name BaseItem
extends Area2D

@export var item_id: String = ""
@export var item_name: String = "Unknown Item"
@export var item_icon: Texture2D
@export_multiline var item_description: String = ""

# --- DIALOGUE MANAGER VARIABLES ---
@export var dialogue_file: DialogueResource
@export var dialogue_title: String = "start"

# --- NEW: TRANSITION VARIABLES ---
@export_file("*.tscn") var transition_target_scene: String = ""
@export var transition_spawn_point: String = "SpawnPoint"

var showInteractionLabel := false
var player_in_range: Node2D = null

func _ready() -> void:
	if item_id in GlobalData.collected_item_ids:
		queue_free()
		return
		
	# --- NEW: BULLETPROOF CONNECTIONS ---
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _process(_delta):
	if showInteractionLabel and Input.is_action_just_pressed("interact"):
		pickup_item()

func _on_body_entered(body: Node2D) -> void:
	# --- NEW: BULLETPROOF PLAYER CHECK ---
	if body.name == "Player" or body.name == "player": 
		showInteractionLabel = true
		player_in_range = body

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body.name == "player": 
		showInteractionLabel = false
		player_in_range = null
	
func pickup_item() -> void:
	if player_in_range != null:
		var was_picked_up = player_in_range.add_item(item_name, item_icon, item_description)
		
		if was_picked_up:
			GlobalData.collected_item_ids.append(item_id)
			
			# Grab the manager now before the item deletes itself
			var gameplay_manager = get_tree().current_scene
			
			if dialogue_file != null:
				DialogueManager.show_example_dialogue_balloon(dialogue_file, dialogue_title)
				
				# --- NEW: WAIT FOR DIALOGUE TO FINISH ---
				# This pauses the code right here until the player clicks past the last text box!
				await DialogueManager.dialogue_ended
			
			# --- NEW: TRIGGER TRANSITION ---
			# If you put a scene into the Inspector, travel to it!
			if transition_target_scene != "":
				if gameplay_manager != null and gameplay_manager.has_method("load_area"):
					gameplay_manager.load_area(transition_target_scene, transition_spawn_point)

			queue_free()
			_on_successful_pickup()

func _on_successful_pickup() -> void:
	pass
