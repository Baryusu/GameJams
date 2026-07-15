extends Node2D

@onready var player = $player
@onready var level_root = $LevelRoot

func _ready():
	# Load Level 1 immediately when Gameplay starts
	load_area("res://levels/Locations/Detective_Office_Opening_Scene.tscn", "SpawnPoint")

func load_area(path: String, spawn_point: String = ""):
	# Clear old level
	for child in level_root.get_children():
		child.queue_free()

	# Instance new level
	var new_area = load(path).instantiate()
	level_root.add_child(new_area)

	# Move player to spawn point marker inside new area
	if spawn_point != "":
		var spawn = new_area.get_node_or_null(spawn_point)
		if spawn:
			player.global_position = spawn.global_position
			
			# --- NEW: THE ANIMATION FIX ---
			# Force the player to stop moving and face forward
			if player.has_method("reset_room_state"):
				player.reset_room_state()

	# Check if the new area has a Camera2D
	var level_camera = new_area.get_node_or_null("Camera2D")
	if level_camera:
		# Disable player's camera
		var player_camera = player.get_node_or_null("Camera2D")
		if player_camera:
			player_camera.enabled = false
		# Enable level camera
		level_camera.enabled = true
	else:
		# No camera in level, keep player's camera active
		var player_camera = player.get_node_or_null("Camera2D")
		if player_camera:
			player_camera.enabled = true
			
			# --- NEW: LOCK THE CAMERA BOUNDS ---
			var bounds = new_area.get_node_or_null("CameraBoundaries")
			if bounds:
				# Snap the limits to the edges of your groupmates' ReferenceRect
				player_camera.limit_left = int(bounds.global_position.x)
				player_camera.limit_top = int(bounds.global_position.y)
				player_camera.limit_right = int(bounds.global_position.x + bounds.size.x)
				player_camera.limit_bottom = int(bounds.global_position.y + bounds.size.y)
			else:
				# If no box exists, reset the limits so the camera roams freely
				player_camera.limit_left = -10000000
				player_camera.limit_top = -10000000
				player_camera.limit_right = 10000000
				player_camera.limit_bottom = 10000000
