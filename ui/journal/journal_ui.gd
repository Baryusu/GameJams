extends CanvasLayer

@onready var left_page = $Control/HBoxContainer/Control/LeftPageText
@onready var right_page = $Control/HBoxContainer/Control2/RightPageText

# This keeps track of what page the left side of the book is currently showing
var current_left_page_index: int = 0

func _ready() -> void:
	hide()  # Hide the journal when the game starts

func open_journal() -> void:
	current_left_page_index = 0
	update_book_display()
	show()

func close_journal() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if not visible:
		return

	var total_notes = GlobalData.journal.size()

	if event.is_action_pressed("ui_right"):
		if current_left_page_index + 2 < total_notes:
			turn_page_forward()

	if event.is_action_pressed("ui_left"):
		if current_left_page_index > 0:
			turn_page_back()

func update_book_display() -> void:
	var notes = GlobalData.journal
	var total_notes = notes.size()

	# Left page
	if current_left_page_index < total_notes:
		left_page.bbcode_enabled = true
		left_page.text = "[center][b]" + notes[current_left_page_index]["title"] + "[/b][/center]\n\n" + notes[current_left_page_index]["text"]
	else:
		left_page.text = ""

	# Right page
	if current_left_page_index + 1 < total_notes:
		right_page.bbcode_enabled = true
		right_page.text = "[center][b]" + notes[current_left_page_index + 1]["title"] + "[/b][/center]\n\n" + notes[current_left_page_index + 1]["text"]
	else:
		right_page.text = ""

func turn_page_forward() -> void:
	current_left_page_index += 2
	update_book_display()

func turn_page_back() -> void:
	current_left_page_index -= 2
	update_book_display()
