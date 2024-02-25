extends Node

## General
var GAME_PAGES = {}
enum RESOURCE_TYPES {
    HARVEST_ESSENCE=0
}


## Gardening
var BASE_PLANT = preload("res://ui/gardening/plant.tscn")
var GARDEN_TOOL = preload("res://items/base/garden_tool.gd")
var GARDEN_TOOL_SLOT = preload("res://ui/gardening/garden_tool.tscn")

var PLANTS:Dictionary = {
    "azurium_bean" : {
        "resource":preload("res://plants/azurium_bean.tres"),
    },
    "quliltih_root" : {
        "resource":preload("res://plants/quilith_root.tres")
    },
    "crunchette" : {
        "resource":preload("res://plants/crunchette.tres")
    }
}

func _ready():
    var global_timer = Timer.new()
    global_timer.wait_time = 0.1
    global_timer.autostart = true
    global_timer.one_shot = false
    global_timer.connect("timeout", tick)
    add_child(global_timer)

func tick():
    Signals.emit_signal("global_tick")

func left_click(event:InputEvent):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            return true
    return false

func right_click(event:InputEvent):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
            return true
    return false
