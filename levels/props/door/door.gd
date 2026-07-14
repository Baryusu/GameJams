extends Area2D
@export_file("*.tscn") var target_scene: String
@export var target_spawn_point: String = "SpawnPoint"
var showInteractionLabel:= false

func _process(delta):
	$Label.visible = showInteractionLabel
	
	if showInteractionLabel && Input.is_action_just_pressed("interact"):
		transition_scene()

func _on_body_entered(body: Node2D) -> void:
	if body is Player: showInteractionLabel = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player: showInteractionLabel = false
	
func transition_scene() -> void:
	if target_scene == "":
		print("No door available")
	else:
		# 1. Find the main Gameplay node (Assuming it is the root node of your game)
		var gameplay_manager = get_tree().current_scene
		
		# 2. Tell the Gameplay manager to swap the levels using your friend's function!
		if gameplay_manager != null:
			gameplay_manager.load_area(target_scene, target_spawn_point)
		else:
			print("Error: Could not find the Gameplay node!")
