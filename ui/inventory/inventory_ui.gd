extends Control

var isOpen: bool = false
var current_selected_index: int = 0 # Keeps track of the highlighted slot (0 to 5)

@onready var box_container: HBoxContainer = $NinePatchRect/HboxContainer

func _ready() -> void:
	# 1. Start listening to the radio station for future updates
	EventBus.inventory_updated.connect(update_ui)
	
	# 2. NEW: Immediately draw whatever is already saved in the vault!
	update_ui(GlobalData.inventory)
	
	# 3. Turn on the selector for the first slot
	update_selection()

# --- YOUR EXISTING OPEN/CLOSE LOGIC ---
func open():
	visible = true
	isOpen = true
	update_selection() # Make sure the selector is visible when opened

func close():
	visible = false
	isOpen = false
# --------------------------------------

# --- NEW KEYBOARD NAVIGATION LOGIC ---
func _input(event: InputEvent) -> void:
	# Only allow moving the selector if the inventory is actually open
	if isOpen:
		var slots = box_container.get_children()
		var max_index = slots.size() - 1
		
		# If we press the Right Arrow
		if event.is_action_pressed("ui_right"):
			current_selected_index += 1
			# If we go past the last slot, wrap back to the first one
			if current_selected_index > max_index:
				current_selected_index = 0 
			update_selection()
			
		# If we press the Left Arrow
		elif event.is_action_pressed("ui_left"):
			current_selected_index -= 1
			# If we go past the first slot, wrap to the last one
			if current_selected_index < 0:
				current_selected_index = max_index 
			update_selection()

func update_selection() -> void:
	var slots = box_container.get_children()
	
	# Loop through all 6 slots
	for i in range(slots.size()):
		var slot = slots[i]
		var selector_ui = slot.get_node("Selector")
		
		# If this slot's number matches our current selection, show the square!
		if i == current_selected_index:
			selector_ui.visible = true
			# If the slot we highlighted actually has an item in it...
			if i < current_inventory.size():
				# Grab the item data and combine the Name and Description
				var selected_item = current_inventory[i]
				description_label.text = selected_item["name"] + "\n" + selected_item["description"]
			else:
				# If the slot is empty, clear the text!
				description_label.text = "Empty Slot"
		# Otherwise, hide it!
		else:
			selector_ui.visible = false
# --------------------------------------
var current_inventory: Array = []
@onready var description_label: Label = $DescriptionLabel
# --- YOUR EXISTING DISPLAY LOGIC ---
func update_ui(inventory_data: Array) -> void:
	current_inventory = inventory_data
	var slots = box_container.get_children()
	
	for i in range(slots.size()):
		var slot = slots[i]
		var icon_rect = slot.get_node("ItemIcon") 
		
		if i < inventory_data.size():
			var current_item = inventory_data[i]
			icon_rect.texture = current_item["icon"]
			icon_rect.visible = true
		else:
			icon_rect.texture = null
			icon_rect.visible = false
