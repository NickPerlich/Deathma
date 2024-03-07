extends CanvasLayer

var slots = [null, null, null, null, null]
@onready var slot_images = [$Control/Slot1/Slot1Image, $Control/Slot2/Slot2Image, $Control/Slot3/Slot3Image, $Control/Slot4/Slot4Image, $Control/Slot5/Slot5Image]

func _ready():
	slots = Global.get_inventory()
	update_inventory_UI()
	
func _input(event):
		if event.is_action_pressed("Slot_1"):
			use_item(0)
			print("item 1 is used")
		elif event.is_action_pressed("Slot_2"):
			use_item(1)
			print("item 2 is used")
		elif event.is_action_pressed("Slot_3"):
			use_item(2)
			print("item 3 is used")	
		elif event.is_action_pressed("Slot_4"):
			use_item(3)
			print("item 4 is used")
		elif event.is_action_pressed("Slot_5"):
			use_item(4)
			print("item 5 is used")
			


func use_item(slot_index):
	if slots[slot_index]:
		slots[slot_index].use()
		slots[slot_index] = null
		slot_images[slot_index].texture = null # Clear the texture
		update_inventory_UI()
		
func update_inventory_UI():
	slots = Global.get_inventory()
	print("updating UI")
	for i in range(len(slots)):
		print("updating slot ", i)
		if slots[i] != null:
			print("found item in slot ", i)
			slot_images[i].texture = slots[i].item_texture
