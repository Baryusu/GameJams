extends Control

@onready var play_button = $CenterContainer/VBoxContainer/PlayButton
@onready var load_slot1 = $CenterContainer/VBoxContainer/LoadSlot1
@onready var load_slot2 = $CenterContainer/VBoxContainer/LoadSlot2
@onready var load_slot3 = $CenterContainer/VBoxContainer/LoadSlot3

func _ready():
	_update_slot_labels()
	play_button.pressed.connect(_on_play_pressed)
	load_slot1.pressed.connect(func(): _on_load_pressed(1))
	load_slot2.pressed.connect(func(): _on_load_pressed(2))
	load_slot3.pressed.connect(func(): _on_load_pressed(3))
	
func _update_slot_labels():
	for i in range(1, 4):
		var file_path = "user://save_slot_%d.save" % i
		var button = get_node("CenterContainer/VBoxContainer/LoadSlot%d" % i)
		if FileAccess.file_exists(file_path):
			button.text = "Load Slot %d (Saved)" % i
		else:
			button.text = "Load Slot %d (Empty)" % i

func _on_play_pressed():
	if GameManager.gameplay_instance == null:
		GameManager.start_game()   # first time
	else:
		GameManager.resume_game()  # go back to existing gameplay

func _on_load_pressed(slot: int):
	GameManager.load_game(slot)
