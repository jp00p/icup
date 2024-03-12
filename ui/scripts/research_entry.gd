extends PanelContainer

@export var research_project_name = "Default"

func _ready() -> void:
    %ResearchProject.text = research_project_name
