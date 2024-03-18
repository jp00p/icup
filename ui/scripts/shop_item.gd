## The UI for an item in the shop
extends PanelContainer

var base_item : Resource
var stacks:int
var required_resource:Globals.RESOURCE_TYPES
var repeatable_purchase : bool = false
var use_on_purchase : bool = false

func _ready() -> void:
    if is_instance_valid(base_item):
        base_item.setup_local_to_scene()
        self.name = base_item.item_name
        Signals.resource_changed.connect(check_affordability)
        %ItemName.text = base_item.item_name
        %ItemDescription.text = base_item.tooltip_description
        %Icon.texture = ImageTexture.create_from_image(base_item.item_icon.get_image())
        base_item.connect("price_changed", on_price_change)
        set_price_text()
    else:
        print("Shop item seems busted: %s" % base_item)

func purchase() -> void:
    Player.add_item(base_item, stacks)
    spend_resource_cost()
    if base_item.auto_use:
        base_item.use()
    if not repeatable_purchase:
        queue_free()

## When player presses buy button
func _on_purchase_pressed() -> void:
    purchase()

## If item's price changes
func on_price_change(_val) -> void:
    set_price_text()

## Disable button if player can't afford
func check_affordability(_type=null) -> void:
    %Purchase.disabled = !player_has_enough_resources()

## Set text on price button
func set_price_text() -> void:
    %Purchase.text = "Buy for %s" % base_item.base_price
    check_affordability()

## Check if player has the required resource
func player_has_enough_resources() -> bool:
    return Stats.RESOURCES[required_resource].total >= base_item.base_price

## Spend the resource
func spend_resource_cost() -> void:
    Stats.set_resource(required_resource, Stats.RESOURCES[required_resource].total - base_item.base_price)
