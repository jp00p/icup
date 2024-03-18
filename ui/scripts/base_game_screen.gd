extends Panel
class_name GameScreen

var tick = 0
var max_x : int = 48
var max_y : float = 1.0

func _ready() -> void:
    Signals.connect("hour_tick", sales_tick)

func sales_tick() -> void:
    tick += 1
    var y = randf_range(0, 1)
    #sales_graph.draw_line(Vector2(tick, y),)
    #plot.add_point(Vector2(tick, y))

