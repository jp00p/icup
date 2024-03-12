@tool
extends PanelContainer

@onready var bar = %ProgressBar
@onready var bar_text = %BarText
@onready var bar_title = %Title
@export var resource:BaseResource = null
var timer:Timer = null
var styles_bg:StyleBoxFlat
var styles_fg:StyleBoxFlat

func _ready():
    # set values
    if is_instance_valid(resource):
        bar.value = int(resource.total)
        bar.max_value = resource.maximum

        # set labels
        bar_text.text = str(resource.total)
        bar_title.text = str(resource.title)

        styles_bg = StyleBoxFlat.new()
        styles_fg = StyleBoxFlat.new()
        styles_bg.bg_color = resource.bar_bg
        styles_fg.bg_color = resource.bar_fg
        bar.add_theme_stylebox_override("background", styles_bg)
        bar.add_theme_stylebox_override("fill", styles_fg)
        bar_text.add_theme_color_override("font_outline_color", Color("Black"))
        if resource.black_text:
            bar_text.add_theme_color_override("font_color", Color("Black"))
            bar_text.add_theme_color_override("font_outline_color", Color("White"))
        if resource.text_outline:
            bar_text.add_theme_constant_override("outline_size", 4)

        if resource.on_timer:
            timer = Timer.new()
            timer.wait_time = resource.timeout * resource.speed
            bar.add_child(timer)
            timer.connect("timeout", resource.tick)
            if resource.autostart:
                timer.start()

func _process(_delta):
    if is_instance_valid(resource):
        bar.value = float(resource.total)
        bar.max_value = resource.maximum
        bar_text.text = "%s" % resource.total
        if resource.rainbow_fg:
            styles_fg.bg_color.h += 0.0025

func _make_custom_tooltip(_for_text="null"):
    var tooltip = preload("res://ui/tooltip.tscn").instantiate()
    tooltip.tracked_resource = self.resource
    return tooltip
