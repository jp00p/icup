extends CanvasLayer

@onready var log_entry = preload("res://ui/log_entry.tscn")

func add_entry(text):
    var entry = log_entry.instantiate()
    entry.text = text
    $LogEntries.add_child(entry)

func _ready():
    Signals.connect("add_log", add_entry)
