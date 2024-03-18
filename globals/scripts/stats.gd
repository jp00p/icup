extends Node

@onready var RESOURCES = {
    Globals.RESOURCE_TYPES.HARVEST_ESSENCE: preload("res://resources/harvest_essence.tres"),
    Globals.RESOURCE_TYPES.GNOMES: preload("res://resources/gnomes.tres"),
    Globals.RESOURCE_TYPES.SCIENTICIANS: preload("res://resources/scienticians.tres")
}

@onready var harvest_essence_resource = preload("res://resources/harvest_essence.tres")
@onready var gnomes_resource = preload("res://resources/gnomes.tres")

## MAIN GAME STATS
var GARDEN_POWER:float = 1.0
var CURRENT_TOOL:BaseItem = null : set = set_current_tool
var TOTAL_GNOMES_KILLED = 0

## GARDEN STATS
var GARDEN_SIZE = Vector2(5,5) : set = set_garden_size
var MAX_PLOTS = 77

var GARDEN_PLOT_PRICE = 1

## PLAYER STATS
var STRENGTH = 0
var DEFENSE = 0

func get_resource(type:Globals.RESOURCE_TYPES) -> BaseResource:
    return RESOURCES[type]

func get_resource_total(type:Globals.RESOURCE_TYPES) -> int:
    return RESOURCES[type].total

func set_resource(type:Globals.RESOURCE_TYPES,val:int) -> void:
    RESOURCES[type].total = clamp(val, 0, RESOURCES[type].maximum)
    Signals.resource_changed.emit(type)

func add_resource(type:Globals.RESOURCE_TYPES,amt:int) -> void:
    var res = get_resource(type)
    set_resource(type, res.total + amt)

func remove_resource(type:Globals.RESOURCE_TYPES,amt:int) -> void:
    var res = get_resource(type)
    set_resource(type, res.total - amt)

## Setter for garden tool
func set_current_tool(item) -> void:
    CURRENT_TOOL = item
    Signals.item_changed.emit(CURRENT_TOOL)

func set_garden_size(val) -> void:
    GARDEN_SIZE = val
    Signals.garden_size_changed.emit()

func _ready():
    set_resource(Globals.RESOURCE_TYPES.HARVEST_ESSENCE, 0)
    set_resource(Globals.RESOURCE_TYPES.GNOMES, 0)
    set_resource(Globals.RESOURCE_TYPES.SCIENTICIANS, 0)
