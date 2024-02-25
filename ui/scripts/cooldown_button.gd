extends Button

@export var button_text:String = "Cooldown button" : set = set_button_text
@export var for_timer:Timer

var status_text = "ON"
var button_size:Vector2

func _ready():
    set_button_text()
    if is_instance_valid(for_timer):
        %CooldownBar.max_value = for_timer.wait_time

func _process(_delta):
    if is_instance_valid(for_timer):
        %CooldownBar.value = for_timer.time_left

func set_button_text(val=button_text) -> void:
    button_text = val
    if is_instance_valid(for_timer):
        if for_timer.is_stopped():
            status_text = "OFF"
        else:
            status_text = "ON"
        text = "%s: %s" % [button_text, status_text]
        %ButtonText.text = "%s: %s" % [button_text, status_text]

func _on_pressed():
    if for_timer.is_stopped():
        for_timer.start()
    else:
        for_timer.stop()
    set_button_text()
