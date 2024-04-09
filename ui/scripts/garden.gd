extends GameScreen

var seed_index = {}
var current_seed:BasePlant
var current_tool:BaseItem = null : set = set_current_tool

func _ready() -> void:
    Player.connect("item_added", add_item)
    Player.connect("seeds_changed", update_popup)
    Signals.connect("resource_changed", harvest_essence_updated)
    %BuyGardenPlot.disabled = true
    update_plot_cost()
    build_seed_dropdown()
    build_inventory()
    Player.add_seeds(Globals.PLANTS[1], 5)

func update_popup():
    print("updating popup")
    for plant in Player.SEED_INVENTORY.keys():
        if plant in seed_index.values():
            var idx = seed_index.find_key(plant)
            %ChooseSeedType.get_popup().set_item_text(idx, get_seed_name(plant))
    var popup_idx = seed_index.find_key(current_seed)
    update_popup_display(popup_idx)

func get_seed_name(plant):
    return "%s: %s" % [plant.seed_name, Player.SEED_INVENTORY.get(plant, "*")]

func update_popup_display(idx):
    %ChooseSeedType.get_popup().set_item_checked(idx, true)
    %ChooseSeedType.text = %ChooseSeedType.get_popup().get_item_text(idx)
    %ChooseSeedType.icon = %ChooseSeedType.get_popup().get_item_icon(idx)

func build_seed_dropdown() -> void:
    # connect seed popup menu
    %ChooseSeedType.get_popup().id_pressed.connect(choose_seed_type)
    %ChooseSeedType.get_popup().add_theme_constant_override("icon_max_width", 16)
    var seed_key = 0
    for plant in Globals.PLANTS:
        # add icon and text to dropdown menu
        #%ChooseSeedType.get_popup()
        %ChooseSeedType.get_popup().add_icon_item(
            plant.graphics.get_frame_texture("default", (plant.graphics.get_frame_count("default")-1)),
            get_seed_name(plant),
            seed_key
        )
        #%ChooseSeedType.get_popup().add_separator("")
        seed_index[seed_key] = plant
        seed_key += 1
    update_popup_display(0)
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
    Stats.GARDEN_SIZE = Stats.GARDEN_SIZE * 2
    Stats.RESOURCES[Globals.RESOURCE_TYPES.HARVEST_ESSENCE].total -= Stats.GARDEN_PLOT_PRICE
    update_plot_cost()

func harvest_essence_updated(_type=null) -> void:
    %BuyGardenPlot.disabled = (Stats.RESOURCES[Globals.RESOURCE_TYPES.HARVEST_ESSENCE].total >= Stats.GARDEN_PLOT_PRICE)

func update_plot_cost() -> void:
    Stats.GARDEN_PLOT_PRICE += Stats.GARDEN_SIZE.y * 2
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
