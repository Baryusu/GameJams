class_name BaseItem
extends Area2D

@export var item_id: String = ""
@export var item_name: String = "Unknown Item"
@export var item_icon: Texture2D
@export_multiline var item_description: String = ""

# Your exact variables from the door script!
var showInteractionLabel := false
var player_in_range: Node2D = null

func _ready() -> void:
	# Automatically connect signals so you don't have to do it in the editor for every item
	if item_id in GlobalData.collected_item_ids:
		queue_free()
		return
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	# Controls the floating text exactly like your door
	$Label.visible = showInteractionLabel
	
	# Listens for the "E" key when the label is showing
	if showInteractionLabel and Input.is_action_just_pressed("interact"):
		pickup_item()

func _on_body_entered(body: Node2D) -> void:
	if body is Player: 
		showInteractionLabel = true
		player_in_range = body

func _on_body_exited(body: Node2D) -> void:
	if body is Player: 
		showInteractionLabel = false
		player_in_range = null
	
func pickup_item() -> void:
	# Call the backpack function on the player
	if player_in_range != null:
		var was_picked_up = player_in_range.add_item(item_name, item_icon, item_description)
		
		if was_picked_up:
				GlobalData.collected_item_ids.append(item_id)
				queue_free()
				_on_successful_pickup() # Delete the item from the ground

# Child items can overwrite this if they want to play a sound or effect!
func _on_successful_pickup() -> void:
	pass
