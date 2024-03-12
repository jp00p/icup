extends Control
class_name Plant

signal harvested(plant, essence_value)

@onready var plant_harvest_particles = preload("res://fx/plant_harvest_particles.tscn")
@onready var gnome_graphic = preload("res://ui/gardening/gnome.tscn")

@export var plant_resource:BasePlant = null # the actual MEAT of the PLANT
@onready var image = %Image
@onready var growth_timer = %GrowthTimer

var tooltip_instance
var growth_tick:int = 0

func _ready() -> void:
    Signals.connect("global_tick", plant_growth_tick)
    %Fertilizer.rotation_degrees = randi_range(-90, 90)
    if plant_resource:
        plant_resource = plant_resource.duplicate()
        tooltip_text = plant_resource.tooltip_template()
        image.texture = plant_resource.current_frame
        growth_timer.wait_time = plant_resource.growth_times[plant_resource.growth_stage]

func _process(_delta) -> void:
    if plant_resource:
        image.texture = plant_resource.current_frame
    queue_redraw()

func plant_growth_tick() -> void:
    if plant_resource.growth_stage < plant_resource.growth_max_level:
        growth_tick += 1
        if growth_tick >= int(plant_resource.growth_times[plant_resource.growth_stage]*Globals.TICKS_PER_HOUR):
            growth_tick = 0
            if plant_resource.check_growth_requirements():
                plant_resource.growth_stage += 1

func _on_growth_timer_timeout() -> void:
    ## When plant finishing a growth stage
    if plant_resource.growth_stage < plant_resource.growth_max_level && plant_resource.check_growth_requirements():
        plant_resource.growth_stage += 1
    growth_timer.wait_time = plant_resource.growth_times[plant_resource.growth_stage]

func _gui_input(event) -> void:
    ## On click
    if Globals.left_click(event):
        if Stats.CURRENT_TOOL != null:
            Stats.CURRENT_TOOL.use(plant_resource)
        elif plant_resource.ready_to_harvest:
            harvest()

func harvest() -> void:
    if plant_resource.ready_to_harvest:
        var particles = plant_harvest_particles.instantiate()
        harvested.emit(self, plant_resource.harvest_value())
        Stats.set_resource(Globals.RESOURCE_TYPES.HARVEST_ESSENCE, Stats.RESOURCES[Globals.RESOURCE_TYPES.HARVEST_ESSENCE].total + plant_resource.harvest_value())
        if plant_resource.spawns_gnome():
            if not Flags.GNOMES_UNLOCKED:
                Flags.GNOMES_UNLOCKED = true
            spawn_gnome_graphic()
            Stats.set_resource(Globals.RESOURCE_TYPES.GNOMES, Stats.RESOURCES[Globals.RESOURCE_TYPES.GNOMES].total + 1)
        particles.position = position + Vector2(32,32)
        get_parent().add_child(particles)

func spawn_gnome_graphic() -> void:
    var gnomey = gnome_graphic.instantiate()
    gnomey.position = position + Vector2(16,16)
    get_parent().add_child(gnomey)

func _draw() -> void:
    if plant_resource.watered:
        draw_circle(Vector2(32,32), 32, Color(0,0,256,0.5))
    if plant_resource.fertilized:
        %Fertilizer.show()

func _make_custom_tooltip(_for_text="null") -> PanelContainer:
    if is_instance_valid(plant_resource):
        var tooltip = preload("res://ui/tooltip.tscn").instantiate()
        tooltip.tracked_resource = plant_resource
        return tooltip
    return null
