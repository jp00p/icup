extends PanelContainer

@export var text = "Default log entry text"

func _ready():
    $LogText.text = text
    $AnimationPlayer.play("log_enter")
    await $AnimationPlayer.animation_finished
    await get_tree().create_timer(4).timeout
    $AnimationPlayer.play("log_exit")
    await $AnimationPlayer.animation_finished
    queue_free()
