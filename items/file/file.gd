extends BaseItem

func _ready():
	super._ready()  # <-- this runs BaseItem._ready() first
	item_id = "file01"
	item_name = "Confidential File"
	item_description = "A folder containing sensitive documents."
	# item_icon set in editor
