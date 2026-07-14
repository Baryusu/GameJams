extends CanvasLayer

@onready var panel = $Panel
@onready var resume_button = $Panel/VBoxContainer/Resume
@onready var quit_button = $Panel/VBoxContainer/QuitToMenu

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS   # keep working while paused
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

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
	GameManager.exit_to_menu()   # 👈 back to MainMenu, gameplay stays saved
