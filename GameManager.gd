extends Node

var gameplay_scene: PackedScene = preload("res://levels/gameplay.tscn")
var gameplay_instance: Node = null

func start_game():
	if gameplay_instance == null:
		gameplay_instance = gameplay_scene.instantiate()
		get_tree().root.add_child(gameplay_instance)
	get_tree().current_scene = gameplay_instance

func exit_to_menu():
	var menu = load("res://ui/MainMenu/main_menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	get_tree().current_scene = menu
