extends CharacterBody2D
class_name Player

const SPEED = 3000.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("up"):
		direction.y += 1
	elif Input.is_action_just_pressed("down"):
		direction.y -= 1
	elif Input.is_action_just_pressed("left"):
		direction.x -= 1
	elif Input.is_action_just_pressed("right"):
		direction.x += 1
	
	velocity = direction * SPEED

	move_and_slide()
	
# --- INVENTORY LOGIC ---
const MAX_SLOTS: int = 6

func add_item(new_name: String, new_icon: Texture2D, new_description: String) -> bool:
	if GlobalData.inventory.size() < MAX_SLOTS:
		# Create a dictionary holding the item's details
		var item_data = {
			"name": new_name,
			"icon": new_icon,
			"description": new_description
		}
		
		GlobalData.inventory.append(item_data)
		print("Picked up: ", new_name)
		
		# Shout to the UI that the inventory changed
		EventBus.inventory_updated.emit(GlobalData.inventory)
		return true 
		
	print("Failed! Inventory is full.")
	return false
	
# Add this inside player.gd, near your existing add_item function
func add_note(title: String, text: String) -> bool:
	# Bundle the text into a dictionary
	var note_data = {
		"title": title,
		"text": text
	}
	
	# Save it to the global journal vault
	GlobalData.journal.append(note_data)
	print("Note added to Journal! Total notes: ", GlobalData.journal.size())
	
	# Return true so the physical paper knows it is safe to delete itself
	return true
	
