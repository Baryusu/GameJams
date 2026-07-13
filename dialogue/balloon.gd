extends CanvasLayer
## A basic dialogue balloon for use with Dialogue Manager.
## Modified for a linear Visual Novel (no choice menus) with portrait support.

# --- SETTINGS YOU CAN CHANGE IN THE INSPECTOR ---
@export var dialogue_resource: DialogueResource
@export var start_from_title: String = ""
@export var auto_start: bool = false
@export var will_block_other_input: bool = true

# The buttons the player presses to interact (set in Project > Input Map)
@export var next_action: StringName = &"ui_accept"
@export var skip_action: StringName = &"ui_cancel"

# --- UI NODES ---
# @onready grabs the nodes from your scene tree as soon as the game starts
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var left_portrait: TextureRect = %LeftPortrait
@onready var right_portrait: TextureRect = %RightPortrait
@onready var balloon: Control = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var progress: Polygon2D = %Progress # The little arrow that shows when text is done

# --- BACKGROUND VARIABLES ---
var temporary_game_states: Array = []
var is_waiting_for_input: bool = false
var will_hide_balloon: bool = false
var locals: Dictionary = {}
var _locale: String = TranslationServer.get_locale()
var mutation_cooldown: Timer = Timer.new()

# This special variable holds the current line of text. 
# Whenever it changes, it automatically triggers the apply_dialogue_line() function below.
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
		else:
			# If there are no more lines, delete or hide the balloon
			if owner == null:
				queue_free()
			else:
				hide()
	get:
		return dialogue_line

# --- MAIN FUNCTIONS ---

func _ready() -> void:
	# Hide the balloon when it first loads so it doesn't pop up empty
	balloon.hide()
	
	# Connect to Dialogue Manager's background systems
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)
	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)

	# If we checked "Auto Start" in the inspector, play immediately
	if auto_start:
		start()

func _process(delta: float) -> void:
	# Only show the little "next" arrow if the text is completely finished typing
	if is_instance_valid(dialogue_line):
		progress.visible = not dialogue_label.is_typing and not dialogue_line.has_tag("voice")

func _unhandled_input(_event: InputEvent) -> void:
	# Stops the player from walking around while the dialogue box is open
	if will_block_other_input:
		get_viewport().set_input_as_handled()

func start(with_dialogue_resource: DialogueResource = null, title: String = "", extra_game_states: Array = []) -> void:
	# This is the function that actually kicks off the conversation
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	
	if is_instance_valid(with_dialogue_resource):
		dialogue_resource = with_dialogue_resource
	if not title.is_empty():
		start_from_title = title
		
	# Grab the very first line of text and show the UI
	dialogue_line = await dialogue_resource.get_next_dialogue_line(start_from_title, temporary_game_states)
	show()

func apply_dialogue_line() -> void:
	# This runs every single time the character says a new line
	mutation_cooldown.stop()

	# Hide the "next" arrow and get ready for the new text
	progress.hide()
	is_waiting_for_input = false
	balloon.focus_mode = Control.FOCUS_ALL
	balloon.grab_focus()

	# Set the character's name at the top of the box
	character_label.visible = not dialogue_line.character.is_empty()
	character_label.text = tr(dialogue_line.character, "dialogue")

	var speaker = dialogue_line.character
	var player_name = "Detective"
	if speaker == player_name:
		var path = "res://assets/art/portraits/" + speaker + ".png"
		if ResourceLoader.exists(path):
			left_portrait.texture = load(path)
			left_portrait.visible = true
			left_portrait.modulate = Color(1, 1, 1, 1) # Full brightness
			right_portrait.modulate = Color(0.5, 0.5, 0.5, 1) # Dimmed
			
	elif speaker != "":
		# An NPC is talking
		var path = "res://assets/art/portraits/" + speaker + ".png"
		if ResourceLoader.exists(path):
			right_portrait.texture = load(path)
			right_portrait.visible = true

			# Highlight NPC, dim the player
			right_portrait.modulate = Color(1, 1, 1, 1) # Full brightness
			left_portrait.modulate = Color(0.5, 0.5, 0.5, 1) # Dimmed
	else:
	# The narrator is speaking (nobody's name is attached)
		left_portrait.modulate = Color(0.5, 0.5, 0.5, 1)
		right_portrait.modulate = Color(0.5, 0.5, 0.5, 1)
# ---------------------------

	# Reset the text label so it can start typing the new words
	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	# Reveal the balloon and start the typewriter effect
	balloon.show()
	will_hide_balloon = false
	dialogue_label.show()
	
	if not dialogue_line.text.is_empty():
		dialogue_label.type_out()
		await dialogue_label.finished_typing

	# Check what to do after the text finishes typing:
	if dialogue_line.has_tag("voice"):
		# If there is a voice acting file, wait for it to finish playing
		audio_stream_player.stream = load(dialogue_line.get_tag_value("voice"))
		audio_stream_player.play()
		await audio_stream_player.finished
		next(dialogue_line.next_id)
	elif dialogue_line.time != "":
		# If a specific time delay was set, wait for that timer to run out
		var time: float = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(time).timeout
		next(dialogue_line.next_id)
	else:
		# Otherwise, just wait for the player to click the "Next" button
		is_waiting_for_input = true
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

func next(next_id: String) -> void:
	# Tell Dialogue Manager to fetch the next line in the story
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id, temporary_game_states)

# --- INPUT & CLICKS ---

func _on_balloon_gui_input(event: InputEvent) -> void:
	# 1. If the text is currently in the middle of typing out...
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		
		# ...and the player clicks or presses 'skip', reveal all text instantly.
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	# 2. If the text is already fully typed out...
	if not is_waiting_for_input: return

	get_viewport().set_input_as_handled()

	# ...and the player clicks or presses 'next', move to the next dialogue line.
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)

# --- BACKGROUND HELPER FUNCTIONS ---
# These handle small background updates from Dialogue Manager

func _notification(what: int) -> void:
	# Updates the text instantly if the player changes the game language in the settings menu
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		_locale = TranslationServer.get_locale()
		var visible_ratio: float = dialogue_label.visible_ratio
		dialogue_line = await dialogue_resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()

func _on_mutation_cooldown_timeout() -> void:
	if will_hide_balloon:
		will_hide_balloon = false
		balloon.hide()

func _on_mutated(mutation: Dictionary) -> void:
	if not mutation.is_inline:
		is_waiting_for_input = false
		will_hide_balloon = true
		mutation_cooldown.start(0.1)
