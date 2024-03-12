extends Node

signal item_added(item)
signal item_removed(item)
signal seeds_changed

var INVENTORY : Array = []
var SEED_INVENTORY : Dictionary = {}

func add_item(item:BaseItem, add_stacks:int=1) -> void:
    if item in INVENTORY and item.consumable:
        item.stacks += add_stacks
    else:
        INVENTORY.push_back(item)
        if item.consumable:
            item.stacks = add_stacks
        item_added.emit(item)

func remove_item(item) -> void:
    INVENTORY.erase(item)
    item_removed.emit(item)

func add_seeds(plant, amt=1):
    SEED_INVENTORY[plant] = amt
    seeds_changed.emit()

func use_seed(plant):
    SEED_INVENTORY[plant] -= 1
    seeds_changed.emit()

