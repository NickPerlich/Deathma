#bananabread

extends "res://item.gd"

var health_to_restore = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	item_texture = preload("res://Art/banana_bread.png")
	print(item_texture)
	
func use():
	print("Banana Bread eaten!")
	queue_free()
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		var cloned_item = self.duplicate()  # Clone the current item
		cloned_item.item_texture = self.item_texture
		Global.add_item_to_inventory(cloned_item)  # Add the cloned item to the global inventory
		var inventory_node = $"../player/Inventory"
		if inventory_node:
			inventory_node.update_inventory_UI()
		else:
			print("Failed to find inventory node")
		queue_free()  # Remove the original item from the game world
