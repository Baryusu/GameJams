extends Node

# This will hold your items permanently between scenes
var inventory: Array = []

# This will remember which specific items on the ground have been picked up
var collected_item_ids: Array = []

var journal: Array = []

var collected_page_ids: Array = []

var spoke_to_parents: bool = false
