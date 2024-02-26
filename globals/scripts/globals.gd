extends Node

## General
var GAME_PAGES = {} # holds references to each page of the game

enum RESOURCE_TYPES {
    HARVEST_ESSENCE=0
}

## Weather
enum SEASONS {
    SPRING,
    SUMMER,
    AUTUMN,
    WINTER
}

enum WEATHER_CLOUDS {
    CLEAR,
    PARTLY_CLOUDY,
    CLOUDY,
    OVERCAST
}

enum WEATHER_PRECIP {
    CLEAR,
    RAIN,
    SNOW
}

var PRECIP_CHANCES = {
    SEASONS.SPRING: {
        WEATHER_PRECIP.CLEAR: 0.6,
        WEATHER_PRECIP.RAIN: 0.4
    },
    SEASONS.SUMMER: {
        WEATHER_PRECIP.CLEAR: 0.9,
        WEATHER_PRECIP.RAIN: 0.1,
    },
    SEASONS.AUTUMN: {
        WEATHER_PRECIP.CLEAR: 0.3,
        WEATHER_PRECIP.RAIN: 0.3,
        WEATHER_PRECIP.SNOW: 0.3
    },
    SEASONS.WINTER: {
        WEATHER_PRECIP.CLEAR: 0.25,
        WEATHER_PRECIP.RAIN: 0.4,
        WEATHER_PRECIP.SNOW: 0.4
    }
}

var CLOUD_CHANCES = {
    WEATHER_PRECIP.CLEAR: {
        WEATHER_CLOUDS.CLEAR: 0.8,
        WEATHER_CLOUDS.PARTLY_CLOUDY: 0.3,
        WEATHER_CLOUDS.CLOUDY: 0.3
    },
    WEATHER_PRECIP.RAIN: {
        WEATHER_CLOUDS.OVERCAST: 0.8,
        WEATHER_CLOUDS.CLOUDY: 0.4,
        WEATHER_CLOUDS.PARTLY_CLOUDY: 0.2
    },
    WEATHER_PRECIP.SNOW: {
        WEATHER_CLOUDS.OVERCAST: 0.5,
        WEATHER_CLOUDS.CLOUDY: 0.3,
        WEATHER_CLOUDS.CLEAR: 0.1
    }
}

func pick_weather(season:SEASONS=SEASONS.SPRING) -> Array:
    var precip_type = WEATHER_PRECIP.values()[WeightedChoice.pick(PRECIP_CHANCES[season])]
    var clouds_type = WEATHER_CLOUDS.values()[WeightedChoice.pick(CLOUD_CHANCES[precip_type])]
    print("%s %s" % [precip_type, clouds_type])
    return [ WEATHER_PRECIP.keys()[precip_type], WEATHER_CLOUDS.keys()[clouds_type] ]

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
    global_timer.wait_time = 0.05
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
