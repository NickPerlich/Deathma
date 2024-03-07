extends Node

var inventory = []
var max_inventory_size = 5

func add_item_to_inventory(item):
	for i in range(min(inventory.size(), max_inventory_size)):
		if inventory[i] == null:
			inventory[i] = item
			return
	if inventory.size() < max_inventory_size:
		inventory.append(item)
	else:
		print("inventory is full")

func get_inventory():
	return inventory
