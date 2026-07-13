extends Node

var previous_scene: String = ""
var current_scene: String = ""

func go_to_scene(target_scene: String, save_current: bool = true):
	if save_current:
		previous_scene = current_scene
	
	current_scene = target_scene
	get_tree().change_scene_to_file(target_scene)
