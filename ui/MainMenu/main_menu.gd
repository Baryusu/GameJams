extends Control

@onready var play_button = $CenterContainer/VBoxContainer/PlayButton

func _ready():
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	GameManager.start_game()
