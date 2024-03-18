extends PanelContainer

@export var entry_name : String = "Default sacrifice"
@export var gnome_cost : int = 1

@export var reward_resource : Globals.RESOURCE_TYPES
@export var reward_amt_min : int = 0
@export var reward_amt_max : int = 0

@export var reward_item : BaseItem = null
@export var item_stacks_min : int = 0
@export var item_stacks_max : int = 0

@export var reward_seed : BasePlant = null
@export var seeds_min : int = 0
@export var seeds_max : int = 0

func _ready() -> void:
    Signals.connect("resource_changed", check_gnomes)
    check_gnomes()

func check_gnomes(_type=null) -> void:
    %Button.disabled = Stats.get_resource_total(Globals.RESOURCE_TYPES.GNOMES) < gnome_cost

func _on_button_pressed():
    Stats.remove_resource(Globals.RESOURCE_TYPES.GNOMES, gnome_cost)
    Stats.TOTAL_GNOMES_KILLED += gnome_cost
    var log_string = "You killed %s gnomes!" % gnome_cost
    if reward_resource:
        var reward_amt = randi_range(reward_amt_min, reward_amt_max)
        var reward_res = Stats.get_resource(reward_resource)
        Stats.add_resource(reward_resource, reward_amt)
        log_string += "\nYou received %s %s" % [reward_amt, reward_res.title]
    if reward_item:
        var stacks = randi_range(item_stacks_min, item_stacks_max)
        Player.add_item(reward_item, stacks)
        log_string += "\nYou received %s %s" % [stacks, reward_item.item_name]
    if reward_seed:
        var seeds = randi_range(seeds_min, seeds_max)
        Player.add_seeds(reward_seed, seeds)
        log_string += "\nYou received %s %s" % [seeds, reward_seed.seed_name]
    Signals.add_log.emit(log_string)
