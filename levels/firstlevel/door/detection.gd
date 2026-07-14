extends Area2D

var player_inside = false

func _ready():
	set_process_unhandled_input(true)

func _on_body_entered(body):
	print("Entered:", body.name)
	if body.name == "player":
		player_inside = true
		print("player_inside set to TRUE")

func _on_body_exited(body):
	print("Exited:", body.name)
	if body.name == "player":
		player_inside = false
		print("player_inside set to FALSE")

func _unhandled_input(event):
	if player_inside and event.is_action_pressed("interact"):
		print("Interacting with door...")
		GameManager.gameplay_instance.load_area("res://levels/secondlevel/secondlevel.tscn", "SpawnPoint")
