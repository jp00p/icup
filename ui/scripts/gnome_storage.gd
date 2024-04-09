extends GameScreen

var upgrades = [
    GnomeContainer.new("Pants pocket", 5, 0),
    GnomeContainer.new("Small pouch", 10, 25),
    GnomeContainer.new("Tiny jar", 25, 50),
    GnomeContainer.new("Shoebox", 50, 100),
    GnomeContainer.new("Decorative tin", 100, 500),
    GnomeContainer.new("Tupperware container", 500, 1000),
    GnomeContainer.new("Desk drawer", 750, 1500),
    GnomeContainer.new("Fanny pack", 1000, 3000),
    GnomeContainer.new("Large mason jar", 0, 0),
    GnomeContainer.new("Cookie tin", 0, 0),
    GnomeContainer.new("Toolbox", 0, 0),
    GnomeContainer.new("Tackle box", 0, 0),
    GnomeContainer.new("Suitcase", 0, 0),
    GnomeContainer.new("Storage bin", 0, 0),
    GnomeContainer.new("Shelf on a bookcase", 0, 0),
    GnomeContainer.new("Small suitcase", 0, 0),
    GnomeContainer.new("Plastic storage drawers", 0, 0),
    GnomeContainer.new("Under-bed storage container", 0, 0),
    GnomeContainer.new("Toy chest", 0, 0),
    GnomeContainer.new("Garage shelf", 0, 0),
    GnomeContainer.new("Closet shelf", 0, 0),
    GnomeContainer.new("Cardboard box", 0, 0),
    GnomeContainer.new("Large cardboard box", 0, 0),
    GnomeContainer.new("Trunk", 0, 0),
    GnomeContainer.new("Storage locker", 0, 0),
    GnomeContainer.new("Storage room", 0, 0),
    GnomeContainer.new("Shed", 0, 0),
    GnomeContainer.new("Storage unit", 0, 0),
    GnomeContainer.new("Attic space", 0, 0),
    GnomeContainer.new("Cargo van", 0, 0),
    GnomeContainer.new("Small storage facility", 0, 0),
    GnomeContainer.new("Garage", 0, 0),
    GnomeContainer.new("Basement", 0, 0),
    GnomeContainer.new("Barn", 0, 0),
    GnomeContainer.new("Shipping container", 0, 0),
    GnomeContainer.new("Warehouse section", 0, 0),
    GnomeContainer.new("Entire warehouse", 0, 0),
    GnomeContainer.new("Storage yard", 0, 0),
    GnomeContainer.new("Distribution center", 0, 0),
    GnomeContainer.new("Truck trailer", 0, 0),
    GnomeContainer.new("Cargo ship", 0, 0),
    GnomeContainer.new("Freight train car", 0, 0),
    GnomeContainer.new("Hangar", 0, 0),
    GnomeContainer.new("Warehouse complex", 0, 0),
    GnomeContainer.new("Aircraft carrier deck", 0, 0),
    GnomeContainer.new("Stadium", 0, 0),
    GnomeContainer.new("Megastore", 0, 0)
]

var current_storage_idx = 0

func _ready() -> void:
    Signals.connect("resource_changed", update_gnomes)
    update_storage_labels()

func update_storage_labels() -> void:
    %StorageName.text = upgrades[current_storage_idx].container_name
    %StorageSize.text = "You can carry a total of %s gnomes" % upgrades[current_storage_idx].storage_size
    %UpgradeButton.text = "Upgrade for $%s" % upgrades[current_storage_idx].cost

func update_gnomes(type):
    var gnomes = Stats.RESOURCES[Globals.RESOURCE_TYPES.GNOMES].total
    var gnome_count = %GnomePile.get_child_count()
    var gnome_diff = gnomes - gnome_count
    if gnome_diff > 0:
        for i in range(gnome_diff):
            var new_gnome = %GnomeGraphic.duplicate()
            new_gnome.show()
            %GnomePile.add_child(new_gnome)
    elif gnome_diff < 0:
        for i in range(abs(gnome_diff)):
            %GnomePile.get_child(i).queue_free()


func _on_upgrade_button_pressed():
    current_storage_idx = wrapi(current_storage_idx+1, 0, upgrades.size())
    update_storage_labels()
