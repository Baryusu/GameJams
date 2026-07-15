extends Area2D

@onready var anim = $AnimatedSprite2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

const Balloon = preload("res://dialogue/balloon.tscn")
var showInteractionLabel = false

func _ready():
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _process(delta):
	$Label.visible = showInteractionLabel
	anim.play("idle")
	if showInteractionLabel && Input.is_action_just_pressed("interact"):
		trigger_dialogue()
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player: showInteractionLabel = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player: showInteractionLabel = false
	
func trigger_dialogue() -> void:
	get_tree().paused = true
 
	# Instantiate your custom balloon and add it to the scene
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	
	# Start the dialogue
	balloon.start(dialogue_resource, dialogue_start)
func _on_dialogue_ended(_resource: DialogueResource) -> void:
	# This automatically runs the exact moment the balloon closes
	get_tree().paused = false
