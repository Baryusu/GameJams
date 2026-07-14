extends Node2D

@onready var player = $player
@onready var level_root = $LevelRoot

func _ready():
	# Load Level 1 immediately when Gameplay starts
	load_area("res://levels/firstlevel/firstlevel.tscn", "SpawnPoint")

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
