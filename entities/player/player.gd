extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("up"):
		direction.x += 1
	elif Input.is_action_just_pressed("down"):
		direction.x -= 1
	elif Input.is_action_just_pressed("left"):
		direction.y -= 1
	else:
		direction.y += 1
	
	velocity = direction * SPEED

	move_and_slide()
