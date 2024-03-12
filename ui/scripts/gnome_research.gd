@tool
extends GameScreen

# Gnome biology
# Gnome society
# Gnome psychology
# Gnome magic
# Gnome history
# Gnome science
# Gnome math

@export var research_row = preload("res://ui/research/research_entry.tscn")

var research_topics = [
    "Gnome biology",
    "Gnome language",
    "Gnome science",
    "Gnome math",
    "Gnome history",
    "Gnome society",
    "Gnome psychology",
    "Gnome magic",
    "Gnome genome"

]

# Called when the node enters the scene tree for the first time.
func _ready():
    for topic in research_topics:
        var row = research_row.instantiate()
        row.research_project_name = topic
        %ResearchRows.add_child(row)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
