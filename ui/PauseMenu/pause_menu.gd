extends CanvasLayer

@onready var panel = $Panel
@onready var resume_button = $Panel/HBoxContainer/TextureRectLeft/VBoxContainerLeft/Resume
@onready var save_game_button = $Panel/HBoxContainer/TextureRectLeft/VBoxContainerLeft/SaveGame
@onready var settings_button = $Panel/HBoxContainer/TextureRectLeft/VBoxContainerLeft/Settings
@onready var quit_button = $Panel/HBoxContainer/TextureRectLeft/VBoxContainerLeft/QuitToMenu

@onready var save_slot1 = $Panel/HBoxContainer/Control/TextureRectRight/VBoxContainerRight/SaveSlot1
@onready var save_slot2 = $Panel/HBoxContainer/Control/TextureRectRight/VBoxContainerRight/SaveSlot2
@onready var save_slot3 = $Panel/HBoxContainer/Control/TextureRectRight/VBoxContainerRight/SaveSlot3

@onready var anim_player = $AnimationPlayer

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS   # keep working while paused

	# Hide button visuals but keep them functional
	for b in [resume_button, save_game_button, settings_button, quit_button,
			  save_slot1, save_slot2, save_slot3]:
		b.flat = true          # removes stylebox borders
		b.modulate.a = 0.0     # makes them invisible

	# Connect signals
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	save_game_button.pressed.connect(_on_save_game_pressed)

	save_slot1.pressed.connect(func(): _on_save_pressed(1))
	save_slot2.pressed.connect(func(): _on_save_pressed(2))
	save_slot3.pressed.connect(func(): _on_save_pressed(3))

	# Hide right menu at start
	$Panel/HBoxContainer/Control/TextureRectRight.visible = false

func _input(event: InputEvent):
	if event.is_action_pressed("Pause"):
		toggle_pause()

func toggle_pause():
	if visible:
		resume_game()
	else:
		pause_game()

func pause_game():
	visible = true
	get_tree().paused = true

func resume_game():
	visible = false
	get_tree().paused = false

func _on_resume_pressed():
	resume_game()

func _on_quit_pressed():
	get_tree().paused = false
	GameManager.exit_to_menu()

func _on_save_game_pressed():
	# Show right menu with animation
	$Panel/HBoxContainer/Control/TextureRectRight.visible = true
	anim_player.play("slide_in_right")

func _on_save_pressed(slot: int):
	GameManager.save_game(slot)
	print("Game saved to slot %d" % slot)

	# Play slide out animation
	anim_player.play("slide_in_left")

	# Hide right menu after animation finishes
	anim_player.animation_finished.connect(func(anim_name):
		if anim_name == "slide_in_left":
			$Panel/HBoxContainer/Control/TextureRectRight.visible = false
	)
