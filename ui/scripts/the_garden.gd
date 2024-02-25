extends Control

@onready var empty_plot = preload("res://ui/gardening/empty_plot.tscn")

func _ready():
    Signals.plant_seed.connect(add_plant)
    Signals.plot_added.connect(add_empty_plot)
    Signals.auto_water.connect(auto_water)
    for _p in Stats.PLAYER_MAX_PLOTS:
        add_empty_plot()

func add_plant(plant:BasePlant):
    var new_plant = Globals.BASE_PLANT.instantiate()
    new_plant.plant_resource = plant
    var total_plants = len(get_tree().get_nodes_in_group("garden_plant"))-1
    if total_plants < Stats.PLAYER_MAX_PLOTS:
        %Plots.add_child(new_plant)
        for c in %Plots.get_children():
            if c is EmptyPlot:
                %Plots.move_child(new_plant, c.get_index())
                c.queue_free()
                break
        new_plant.connect("harvested", plant_removed)

func plant_removed(plant:Control, _points_value):
    var old_plant_index = plant.get_index()
    var new_plot = add_empty_plot()
    %Plots.move_child(new_plot, old_plant_index)
    plant.queue_free()

func add_empty_plot():
    var new_empty_plot = empty_plot.instantiate()
    %Plots.add_child(new_empty_plot)
    return new_empty_plot

func auto_water():
    var plants = get_tree().get_nodes_in_group("garden_plant")
    plants = plants.filter(func(plant): return plant is Control && !plant.plant_resource.watered)
    if plants.size() > 0:
        plants.pick_random().plant_resource.set_watered(true)
