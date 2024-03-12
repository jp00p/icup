extends PanelContainer

@export var project : ConstructionProject

func _ready() -> void:
    Signals.connect("resource_changed", check_price)
    if is_instance_valid(project):
        check_price()
        %Build.text = "%s gnomes" % project.price
        %ProjectName.text = project.project_name
        %Description.text = project.project_description

func check_price():
    %Build.disabled = !player_can_afford()

func player_can_afford() -> bool:
    return Stats.RESOURCES[Globals.RESOURCE_TYPES.GNOMES].total >= project.price
