extends GameScreen

@onready var shop_items = [
    {
        "name":"Basic Fertilizer",
        "resource":preload("res://items/basic_fertilizer.tres"),
        "repeatable":true,
        "required_resource":Globals.RESOURCE_TYPES.HARVEST_ESSENCE,
        "stacks":5
    },
    {
        "name":"Water",
        "resource":preload("res://items/watering_can.tres"),
        "repeatable":false,
        "required_resource":Globals.RESOURCE_TYPES.HARVEST_ESSENCE
    },
    {
        "name":"Garden gnome",
        "resource":preload("res://items/garden_gnome.tres"),
        "repeatable":false,
        "required_resource":Globals.RESOURCE_TYPES.GNOMES
    },
]

@onready var shop_grid = %ShopGrid

const SHOP_ITEM = preload("res://ui/shop_item.tscn")

func _ready():
    for item:Dictionary in shop_items:
        var new_item = SHOP_ITEM.instantiate()
        new_item.base_item = item["resource"]
        new_item.repeatable_purchase = item["repeatable"]
        new_item.required_resource = item["required_resource"]
        if "stacks" in item.keys():
            new_item.stacks = item["stacks"]
        shop_grid.add_child(new_item)
