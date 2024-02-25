extends Control

@export var item_resource:GardenTool

func _ready() -> void:
    tooltip_text = "BLANK"
    if is_instance_valid(item_resource):
        %Icon.texture = ImageTexture.create_from_image(item_resource.item_icon.get_image())
        update_uses()
        item_resource.connect("item_depleted", remove_item)
        item_resource.connect("quantity_changed", update_uses)

## Set current tool when clicked
func _on_gui_input(event:InputEvent) -> void:
    if event.is_action_released("left_click"):
        Stats.CURRENT_TOOL = item_resource

func _make_custom_tooltip(_for_text="null") -> PanelContainer:
    var tooltip = preload("res://ui/tooltip.tscn").instantiate()
    tooltip.tracked_resource = item_resource
    return tooltip

func remove_item() -> void:
    Stats.CURRENT_TOOL = null
    queue_free()

func update_uses() -> void:
    %Uses.visible = item_resource.consumable && item_resource.stacks > 0
    %Uses.text = "%s" % item_resource.stacks
