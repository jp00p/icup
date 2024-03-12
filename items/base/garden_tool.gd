## Garden tools get used on plants

extends BaseItem
class_name GardenTool

## Use on plants
func use(plant=null):
    # plant could also be an empty plot
    if len(effects) > 0 and plant != null:
        for effect in effects:
            if effect != "":
                var expr = Expression.new()
                # Pass the level of this tool as a variable named ilvl
                var error = expr.parse(effect, ["ilvl", "self"])
                if error != OK:
                    push_error(expr.get_error_text())
                var _result = expr.execute([self.level, self], plant)
    item_used.emit()
    if consumable:
        self.stacks -= 1
