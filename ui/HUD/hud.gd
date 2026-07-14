extends CanvasLayer

@onready var inventory = $inventory_ui
@onready var journal = $journal_ui


func _ready():
	inventory.close()
	journal.close_journal()
	
func _input(event):
	if Input.is_action_just_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
	if Input.is_action_just_pressed("toggle_journal"):
		if journal.visible:
			journal.close_journal()
		else:
			journal.open_journal()
