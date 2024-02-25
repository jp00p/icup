extends Control

var seed_index = {}
var current_seed
var current_tool:BaseItem = null : set = set_current_tool

func _ready() -> void:
    Player.item_added.connect(add_item)
    Player.item_removed.connect(build_inventory)
    Signals.connect("harvest_essence_changed", harvest_essence_updated)
    %BuyGardenPlot.disabled = true
    update_plot_cost()
    build_seed_dropdown()
    build_inventory()

func build_seed_dropdown() -> void:
    # connect seed popup menu
    %ChooseSeedType.get_popup().id_pressed.connect(choose_seed_type)
    var seed_key = 0
    for plant in Globals.PLANTS.values():
        # add icon and text to dropdown menu
        %ChooseSeedType.get_popup().add_icon_item(plant.resource.graphics.get_frame_texture("default", 6), plant.resource.plant_name, seed_key)
        seed_index[seed_key] = plant.resource
        seed_key += 1
    %ChooseSeedType.get_popup().set_item_checked(0, true)
    %ChooseSeedType.text = %ChooseSeedType.get_popup().get_item_text(0)
    %ChooseSeedType.icon = %ChooseSeedType.get_popup().get_item_icon(0)
    current_seed = seed_index[0]


func add_item(item) -> void:
    if item is GardenTool:
        var tool_slot = Globals.GARDEN_TOOL_SLOT.instantiate()
        tool_slot.item_resource = item
        %GardenItems.add_child(tool_slot)

func build_inventory(_item:BaseItem=null) -> void:
    for item in Player.INVENTORY:
        add_item(item)

func _on_plant_seed_button_pressed() -> void:
    Signals.plant_seed.emit(current_seed)

func choose_seed_type(id:int) -> void:
    var seed_type_text = %ChooseSeedType.get_popup().get_item_text(id)
    current_seed = seed_index[id]
    %ChooseSeedType.icon = %ChooseSeedType.get_popup().get_item_icon(id)
    %ChooseSeedType.text = seed_type_text

func _on_buy_garden_plot_pressed() -> void:
    Stats.PLAYER_MAX_PLOTS += 1
    Stats.HARVEST_ESSENCE -= Stats.GARDEN_PLOT_PRICE
    update_plot_cost()

func harvest_essence_updated() -> void:
    if Stats.HARVEST_ESSENCE >= Stats.GARDEN_PLOT_PRICE:
        %BuyGardenPlot.disabled = false
    else:
        %BuyGardenPlot.disabled = true

func update_plot_cost() -> void:
    Stats.GARDEN_PLOT_PRICE += Stats.PLAYER_MAX_PLOTS + 1
    %GardenPlotPrice.text = "Cost: %s HE" % Stats.GARDEN_PLOT_PRICE

func set_current_tool(tool) -> void:
    current_tool = tool
    Signals.item_changed.emit(current_tool)

func _on_gui_input(event) -> void:
    if Globals.right_click(event):
        if current_tool != null:
            self.current_tool = null

func _on_autoplant_timer_timeout() -> void:
    Signals.plant_seed.emit(current_seed)

func _on_autowater_timer_timeout() -> void:
    Signals.auto_water.emit()
