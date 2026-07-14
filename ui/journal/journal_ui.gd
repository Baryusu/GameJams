extends CanvasLayer

@onready var left_page = $LeftPage
@onready var right_page = $RightPage
# This keeps track of what page the left side of the book is currently showing
var current_left_page_index: int = 0

func _ready() -> void:
	# Hide the journal when the game starts
	hide()

# Call this function from your Player script when they press "J" or click the journal!
func open_journal() -> void:
	current_left_page_index = 0
	update_book_display()
	show()

func close_journal() -> void:
	hide()

func _input(event: InputEvent) -> void:
	# If the journal isn't visible, ignore keyboard inputs for flipping pages
	if not visible:
		return
		
	var total_notes = GlobalData.journal.size()
	
	# Listen for D or Right Arrow
	if event.is_action_pressed("ui_right"):
		# Only flip forward if there are more notes to read
		if current_left_page_index + 2 < total_notes:
			turn_page_forward()
			
	# Listen for A or Left Arrow
	if event.is_action_pressed("ui_left"):
		# Only flip backward if we aren't already on the very first page
		if current_left_page_index > 0:
			turn_page_back()

func update_book_display() -> void:
	var notes = GlobalData.journal
	var total_notes = notes.size()
	
	# --- RENDER THE LEFT PAGE ---
	if current_left_page_index < total_notes:
		# Using your BBCode formatting for the title!
		left_page.text = "[center][b]" + notes[current_left_page_index]["title"] + "[/b][/center]\n\n" + notes[current_left_page_index]["text"]
	else:
		left_page.text = "" # Blank page if no note exists
		
	# --- RENDER THE RIGHT PAGE ---
	if current_left_page_index + 1 < total_notes:
		right_page.text = "[center][b]" + notes[current_left_page_index + 1]["title"] + "[/b][/center]\n\n" + notes[current_left_page_index + 1]["text"]
	else:
		right_page.text = "" # Blank page if no note exists

func turn_page_forward() -> void:
	current_left_page_index += 2
	update_book_display()

func turn_page_back() -> void:
	current_left_page_index -= 2
	update_book_display()
