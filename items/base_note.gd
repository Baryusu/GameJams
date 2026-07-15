class_name BaseNote
extends Area2D

# Expose these to the Inspector so you can write different clues for every paper
@export var note_id: String = ""
@export var note_title: String = "Unknown Note"
@export_multiline var note_text: String = ""

var showInteractionLabel := false
var player_in_range: Node2D = null

func _ready() -> void:
	# 1. Safety Check: If we already collected this note, delete it immediately
	if note_id in GlobalData.collected_page_ids:
		queue_free()
		return
		
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	# Controls the floating text exactly like your items and doors
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
	if player_in_range != null:
		var was_picked_up = player_in_range.add_note(note_title, note_text)
		
		if was_picked_up:
			GlobalData.collected_page_ids.append(note_id)
			queue_free()
