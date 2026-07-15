extends CharacterBody2D
class_name Player

@onready var anim = $AnimatedSprite2D

const SPEED = 3000.0

var has_moved: bool = false

func _ready():
	anim.play("enter_door")

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
	
	if velocity.length() > 0:
		# The player is currently walking
		has_moved = true
		anim.play("walk")
		
		# Flip the sprite horizontally based on which way they are walking
		# If velocity.x is less than 0 (walking left), flip_h becomes true.
		if velocity.x != 0:
			anim.flip_h = velocity.x < 0 
			
	else:
		# The player is standing completely still
		if has_moved:
			# If they have walked at least once, use side_idle
			anim.play("idle")
		else:
			# If they haven't touched the keys yet, stay in front_idle
			anim.play("enter_door")
	
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
	
# Add this anywhere inside player.gd
func reset_room_state() -> void:
	# 1. Kill any leftover momentum from the previous room
	velocity = Vector2.ZERO 
	
	# 2. Make the script forget that we ever walked
	has_moved = false
	
	# 3. Force the front idle animation
	anim.play("enter_door")
	
