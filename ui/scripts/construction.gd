@tool
extends GameScreen

const CONSTRUCTION_PROJECT_ROW = preload("res://ui/construction/construction_project_row.tscn")

func _ready():
    build_list()

func build_list() -> void:
    for project in Globals.construction_projects:
        var project_row = CONSTRUCTION_PROJECT_ROW.instantiate()
        project_row.project = project
        %ProjectList.add_child(project_row)
