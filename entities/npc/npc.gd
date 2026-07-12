extends Area2D

var showInteractionLabel = false

func _process(delta):
	$Label.visible = showInteractionLabel
	
	if showInteractionLabel && Input.is_action_just_pressed("interact"):
		$Label.text = "Hello, Player!!!"
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player: showInteractionLabel = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player: showInteractionLabel = false
