## The base class for all items
extends Resource
class_name BaseItem

signal price_changed(new_price)
signal quantity_changed()
signal item_used()
signal item_depleted()

@export_category("Basic details")
@export var item_name:String = "Base item"
@export var item_icon:AtlasTexture
@export var tooltip_description:String
@export var level:int = 1
@export var base_price:int = 1 : set = set_price

@export_category("Usage")
@export var consumable:bool = false
@export var auto_use:bool = false
var stacks:int = 1 : set = set_stacks
@export var max_stacks:int = 99

@export_category("Effects")
@export var cooldown:float = 0.0
@export var effects:Array = []

@export_category("Cursor")
@export var cursor_name_normal:String
@export var cursor_name_clicked:String

func tooltip_template() -> String:
    return "%s:\n%s" % [item_name,tooltip_description]

## Overload this function with specific items/types
func use(_on):
    pass

func set_price(val) -> void:
    base_price = val
    price_changed.emit(base_price)

func set_stacks(val:int) -> void:
    stacks = min(val, max_stacks)
    quantity_changed.emit()
    if stacks <= 0 and consumable:
        Player.remove_item(self)
        item_depleted.emit()
