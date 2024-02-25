extends Node

signal item_added(item)
signal item_removed(item)

var INVENTORY : Array = []

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
