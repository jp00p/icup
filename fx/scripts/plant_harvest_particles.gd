extends CPUParticles2D

func _ready():
    self.emitting = true

func _on_finished():
    queue_free()
