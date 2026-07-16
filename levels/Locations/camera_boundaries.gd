extends Node2D 

@onready var bounds = $CameraBoundaries

@export var dialogue_file: DialogueResource
@export var dialogue_title: String = "start"

func _ready() -> void:
	var dropped_card = get_node_or_null("Items/CompanyCard")
	
	if dropped_card != null:
		var card_collision = dropped_card.get_node_or_null("CollisionShape2D")
		
		if GlobalData.watched_cctv == true:
			dropped_card.show()
			if card_collision != null:
				card_collision.disabled = false
		else:
			dropped_card.hide()
			if card_collision != null:
				card_collision.disabled = true

	# --- YOUR EXISTING CAMERA LOGIC ---
	var camera = get_viewport().get_camera_2d()
	if camera and bounds:
		camera.limit_left = int(bounds.global_position.x)
		camera.limit_top = int(bounds.global_position.y)
		camera.limit_right = int(bounds.global_position.x + bounds.size.x)
		camera.limit_bottom = int(bounds.global_position.y + bounds.size.y)
		
	# --- YOUR EXISTING DIALOGUE LOGIC ---
	if dialogue_file != null:
		play_opening_monologue()

func play_opening_monologue() -> void:
	await get_tree().create_timer(0.5).timeout
	DialogueManager.show_example_dialogue_balloon(dialogue_file, dialogue_title)
