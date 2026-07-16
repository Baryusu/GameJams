extends Node

var gameplay_scene: PackedScene = preload("res://levels/gameplay.tscn")
var gameplay_instance: Node = null

func start_game():
	if gameplay_instance == null:
		gameplay_instance = gameplay_scene.instantiate()
		get_tree().root.add_child(gameplay_instance)
	get_tree().current_scene = gameplay_instance

func resume_game():
	if gameplay_instance != null:
		get_tree().current_scene = gameplay_instance

func exit_to_menu():
	if gameplay_instance:
		gameplay_instance.queue_free()
		gameplay_instance = null

	var menu = load("res://ui/MainMenu/main_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	get_tree().current_scene = menu

# --- Save System ---
func save_game(slot: int):
	if gameplay_instance == null:
		return

	var save_data = {
		"level_path": gameplay_instance.level_path,
		"player_position": gameplay_instance.player.global_position,
		"collected_items": GlobalData.collected_item_ids
	}

	var file = FileAccess.open("user://save_slot_%d.save" % slot, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_game(slot: int):
	var file_path = "user://save_slot_%d.save" % slot
	if not FileAccess.file_exists(file_path):
		print("No save in slot", slot)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var save_data = file.get_var()
	file.close()

	if gameplay_instance == null:
		gameplay_instance = gameplay_scene.instantiate()
		get_tree().root.add_child(gameplay_instance)

	get_tree().current_scene = gameplay_instance

	# Restore state
	gameplay_instance.load_area(save_data["level_path"], "")
	gameplay_instance.player.global_position = save_data["player_position"]
	GlobalData.collected_item_ids = save_data["collected_items"]
