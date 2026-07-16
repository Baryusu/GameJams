extends Control

# Left menu buttons
@onready var play_button      = $CenterContainer/VBoxContainerLeft/TextureRect/PlayButton
@onready var load_game_button = $CenterContainer/VBoxContainerLeft/TextureRect2/LoadGame
@onready var settings_button  = $CenterContainer/VBoxContainerLeft/TextureRect3/Settings
@onready var credits_button   = $CenterContainer/VBoxContainerLeft/TextureRect4/Credits
@onready var exit_button      = $CenterContainer/VBoxContainerLeft/Exit/PlayButton

# Right menu slots
@onready var load_slot1       = $CenterContainer2/TextureRect2/LoadSlot1
@onready var load_slot2       = $CenterContainer2/TextureRect3/LoadSlot2
@onready var load_slot3       = $CenterContainer2/TextureRect4/LoadSlot3

@onready var anim_player      = $AnimationPlayer

var pending_load_slot: int = -1   # store which slot to load after anim

func _ready():
	_update_slot_labels()

	for b in [play_button, load_game_button, settings_button, credits_button, exit_button,
			  load_slot1, load_slot2, load_slot3]:
		b.flat = true
		b.modulate.a = 0.0

	play_button.pressed.connect(_on_play_pressed)
	load_game_button.pressed.connect(_on_load_game_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

	load_slot1.pressed.connect(func(): _on_load_pressed(1))
	load_slot2.pressed.connect(func(): _on_load_pressed(2))
	load_slot3.pressed.connect(func(): _on_load_pressed(3))

	anim_player.animation_finished.connect(_on_anim_finished)

	$CenterContainer2.visible = false

func _update_slot_labels():
	var slots = [load_slot1, load_slot2, load_slot3]
	for i in range(slots.size()):
		var file_path = "user://save_slot_%d.save" % (i+1)
		var button = slots[i]
		if FileAccess.file_exists(file_path):
			button.text = "Load Slot %d (Saved)" % (i+1)
		else:
			button.text = "Load Slot %d (Empty)" % (i+1)

# --- Button handlers ---
func _on_play_pressed():
	if GameManager.gameplay_instance == null:
		GameManager.start_game()
	else:
		GameManager.resume_game()

func _on_load_game_pressed():
	$CenterContainer2.visible = true
	anim_player.play("load_open")

func _on_load_pressed(slot: int):
	pending_load_slot = slot
	anim_player.play("load_close")

func _on_anim_finished(anim_name: String):
	if anim_name == "load_close":
		$CenterContainer2.visible = false
		if pending_load_slot > 0:
			GameManager.load_game(pending_load_slot)
			_update_slot_labels()
			pending_load_slot = -1

func _on_settings_pressed():
	return
	GameManager.open_settings()

func _on_credits_pressed():
	GameManager.show_credits()

func _on_exit_pressed():
	GameManager.exit_game()
