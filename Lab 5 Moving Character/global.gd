extends Node

var inventory = []
var max_inventory_size = 5

func add_item_to_inventory(sprite_node: Sprite2D):
	var item_data = {
		"texture": sprite_node.texture,
		"region_rect": sprite_node.region_rect,
		"region_enabled": sprite_node.region_enabled
	}
	for i in range(min(inventory.size(), max_inventory_size)):
		if inventory[i] == null:
			inventory[i] = item_data
			return
	if inventory.size() < max_inventory_size:
		inventory.append(item_data)
	else:
		print("Inventory is full")

func get_inventory():
	return inventory
