extends Node

@onready var harvest_essence_resource = preload("res://resources/harvest_essence.tres")

## MAIN GAME STATS
var GARDEN_POWER:float = 1.0
var HARVEST_ESSENCE:int = 0 : set = set_harvest_essence
var CURRENT_TOOL:BaseItem = null : set = set_current_tool

## GARDEN STATS
var MAX_PLOTS = 77
var PLAYER_MAX_PLOTS = 10 : set = set_max_plots
var GARDEN_PLOT_PRICE = 1

func _ready():
    HARVEST_ESSENCE = harvest_essence_resource.total

## Setter for harvest essence
## Clamps to resource max, emits signal
func set_harvest_essence(val) -> void:
    HARVEST_ESSENCE = clamp(val, 0, harvest_essence_resource.maximum)
    harvest_essence_resource.total = HARVEST_ESSENCE
    Signals.harvest_essence_changed.emit()

## Setter for garden plots
func set_max_plots(val) -> void:
    PLAYER_MAX_PLOTS = clamp(val, 0, MAX_PLOTS)
    Signals.plot_added.emit()

## Setter for garden tool
func set_current_tool(item):
    CURRENT_TOOL = item
    Signals.item_changed.emit(CURRENT_TOOL)
