class_name ScrapNote
extends Area2D

@export var note_id: String =  ""
@export var note_title: String = "Unknown Note"
@export_multiline var note_text: String = ""

# Your exact variables from the door script!
var showInteractionLabel := false
var player_in_range: Node2D = null

func _ready() -> void:
	# Automatically connect signals so you don't have to do it in the editor for every item
	if note_id in GlobalData.collected_page_ids:
		queue_free()
		return
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	# Controls the floating text exactly like your door
	$Label.visible = showInteractionLabel
	
	# Listens for the "E" key when the label is showing
	if showInteractionLabel and Input.is_action_just_pressed("interact"):
		pickup_note()

func _on_body_entered(body: Node2D) -> void:
	if body is Player: 
		showInteractionLabel = true
		player_in_range = body

func _on_body_exited(body: Node2D) -> void:
	if body is Player: 
		showInteractionLabel = false
		player_in_range = null
	
func pickup_note() -> void:
	# Call the backpack function on the player
	var note_data = {
		"title": note_title,
		"text": note_text
	}
	GlobalData.journal.append(note_data)
	GlobalData.collected_page_ids.append(note_id)
	
	print("Detective found a note.")
	queue_free()

# Child items can overwrite this if they want to play a sound or effect!
func _on_successful_pickup() -> void:
	pass
