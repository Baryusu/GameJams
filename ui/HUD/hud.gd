extends CanvasLayer

@onready var inventory = $inventory_gui


func _ready():
	inventory.close()
	
func _input(event):
	if Input.is_action_just_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
