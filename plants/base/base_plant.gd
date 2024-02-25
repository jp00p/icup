## The base class for all plants
extends Resource
class_name BasePlant

signal harvested

@export_category("Basic details")
@export var plant_name:String = "Default Plant Name"
@export var graphics: SpriteFrames

@export_category("Growth")
@export var growth_stage:int = 0 : set = set_growth_stage
@export var growth_max_level:int = 6
@export var growth_times:PackedFloat32Array = [1,2,3,4,5,6,10]
@export var growth_requirements:Array = []

@export_category("Harvest")
@export var base_harvest_essence:int = 1
@export var base_harvest_essence_max:int = 1

var watered:bool = false : set = set_watered
var fertilized:bool = false : set = set_fertilized
var ready_to_harvest:bool = false : set = set_ready_to_harvest
var quality:float = 1.0
var current_frame

var harvest_essence_average:int = 0

func _ready() -> void:
    resource_local_to_scene = true
    harvest_essence_average = round((base_harvest_essence + base_harvest_essence_max) / 2)

func harvest_value() -> int:
    return round(randi_range(base_harvest_essence, base_harvest_essence_max) * quality)

func tooltip_template() -> String:
    var water_string = "No"
    var fert_string = "No"
    if watered:
        water_string = "Yes"
    if fertilized:
        fert_string = "Yes"
    var avg = round(((base_harvest_essence + base_harvest_essence_max) / 2) * quality)
    return "%s\n%s/%s\nWatered/Fertilized?\n%s/%s\nEstimated value %sHE" % [plant_name, growth_stage, growth_max_level, water_string, fert_string, avg]

func set_quality(val) -> void:
    quality = val

func set_watered(val) -> void:
    watered = val

func set_fertilized(val:bool) -> void:
    fertilized = val

func fertilize(amt:int) -> void:
    pass

func set_ready_to_harvest(val) -> void:
    ready_to_harvest = val
    if ready_to_harvest:
        pass

func set_growth_stage(val) -> void:
    growth_stage = min(val, growth_max_level)
    current_frame = graphics.get_frame_texture("default", growth_stage)
    if growth_stage >= growth_max_level:
        ready_to_harvest = true

func check_growth_requirements() -> bool:
    if growth_stage + 1 > growth_requirements.size():
        return true
    var requirement = growth_requirements[growth_stage + 1]
    if requirement != null:
        var expr = Expression.new()
        var error = expr.parse(requirement)
        if error != OK:
            push_error(expr.get_error_text())
            print("error! %s" % expr.get_error_text())
        var _result = expr.execute([], self)
        return _result
    else:
        return true
