extends GameScreen

func _ready():
    Signals.connect("resource_changed", update_gnomes)

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
