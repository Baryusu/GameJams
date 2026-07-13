extends Area2D
@export_file("*.tscn") var target_scene: String
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
		get_tree().change_scene_to_file(target_scene)
