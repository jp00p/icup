extends Resource
class_name BaseResource

@export var title:String = ""
@export var maximum:int = 0 : set = set_maximum
@export var starting_value:int = 0
@export var total:int = 0 : set = set_total

@export var speed_multiplier:float = 1.0 : set = set_speed_mult
@export var gain_multiplier:float = 1.0 : set = set_gain_mult

@export var reset_on_fill:bool = false
@export var bounce_fill:bool = false

@export_category("Timer stuff")
@export var on_timer:bool = false
@export var autostart:bool = true
@export var timeout:float = 1.0
@export var speed:float = 1.0 : set = set_speed
@export var per_tick:int = 1 : set = set_per_tick

@export_category("UI Stuff")
@export var bar_bg:Color = Color("Black")
@export var bar_fg:Color = Color("Green")
@export var black_text:bool = false
@export var text_outline:bool = false
@export var rainbow_fg:bool = false

var timer = null

signal resource_empty
signal resource_full
signal speed_changed
signal gain_changed
signal per_tick_changed
signal resource_total_changed

func tick():
    var gain = per_tick * gain_multiplier
    self.total = total + gain

func set_total(val):
    total = val
    if maximum > 0 and total >= maximum:
        total = maximum
        resource_full.emit()
        if bounce_fill:
            self.per_tick = -per_tick
    if total < 0:
        total = 0
        resource_empty.emit()
        if bounce_fill:
            self.per_tick = -per_tick

func set_maximum(val):
    maximum = val

func set_speed_mult(val):
    speed_multiplier = val
    speed_changed.emit()

func set_gain_mult(val):
    gain_multiplier = val
    gain_changed.emit()

func set_speed(val):
    speed = val
    speed_changed.emit()

func set_per_tick(val):
    per_tick = val
    per_tick_changed.emit()

func tooltip_template():
    var template = "%s \n%s"
    #if maximum != 0:
        #template += "/{maximum}"
    #template += "\n Per tick: {per_tick}"
    return template % [title, total]
