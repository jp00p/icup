extends Control
@onready var plant = preload("res://ui/gardening/plant.tscn")

# Harvest Essence
# each plant grown + harvested gives HE
# affected by quality and plant type
# HE is used to unlock new things

# Garden Mastery
# Garden Mastery increases on reset
# Most everything is affected by GM

# Garden level
# Some progression locked behind GL

# Weeds
# grow over time and will reduce the quality of HE if not tended to

# Water
# Fertilizer
# Plant food
# Sunshine
# Moonlight

# Plant seed
# Water plant
# Harvest plant (click on it)
# Work soil
# Add fertilizer
# Tend to weeds

#
#1. **Basic Planting:**
   #- Start with simple seeds like sunflowers and roses.
   #- Click to plant seeds and water them for initial points.
#
#2. **Soil Enhancement:**
   #- Upgrade soil quality to increase plant growth speed and yield.
   #- Unlock fertilizer options with unique effects on different plants.
#
#3. **Watering System:**
   #- Implement an automated watering system to reduce manual clicks.
   #- Upgrade watering efficiency and unlock rain barrels for natural watering.
#
#4. **Tool Upgrades:**
   #- Upgrade gardening tools for faster planting and harvesting.
   #- Unlock advanced tools like automated planters and robotic harvesters.
#
#5. **Crop Rotation Strategy:**
   #- Introduce a crop rotation system for increased efficiency.
   #- Strategically plan rotations for bonus points and healthier plants.
#
#6. **Pollinator Paradise:**
   #- Attract bees and butterflies to improve pollination.
   #- Upgrade flowers and install bee hives for additional benefits.
#
#7. **Crossbreeding Experiment:**
   #- Unlock the ability to crossbreed different plants for unique hybrids.
   #- Discover rare and valuable hybrid species with special properties.
#
#8. **Pest Management Mini-Game:**
   #- Encounter pests that threaten your garden.
   #- Implement a mini-game to squash bugs or use natural predators for points.
#
#9. **Garden Aesthetics:**
   #- Decorate your garden with various items for aesthetic appeal.
   #- Unlock garden gnomes, fountains, and themed decorations for bonuses.
#
#10. **Greenhouse Expansion:**
    #- Build a greenhouse for year-round gardening.
    #- Upgrade the greenhouse with climate control and advanced plant breeding.
#
#11. **Botanical Research Lab:**
    #- Establish a lab for advanced plant research.
    #- Conduct experiments for new seed varieties and gardening technologies.
#
#12. **Weather Manipulation:**
    #- Unlock the ability to control weather for optimal plant growth.
    #- Upgrade weather machines for rain, sunshine, and even rainbows.
#
#13. **Farming Guilds:**
    #- Join or create gardening guilds for collaborative bonuses.
    #- Participate in guild events and challenges for extra rewards.
#
#14. **Harvest Festival Events:**
    #- Host seasonal events like harvest festivals.
    #- Attract visitors for special bonuses, mini-games, and exclusive rewards.
#
#15. **Time Traveling Seeds:**
    #- Discover time-traveling seeds that bring historical or futuristic plants.
    #- Unlock different eras with unique challenges and rewards.
#
#16. **Quantum Gardening:**
    #- Explore quantum gardening with plants in multiple states simultaneously.
    #- Upgrade to quantum tools and experience unpredictable growth patterns.
#
#17. **Celestial Planting:**
    #- Unlock the ability to plant under celestial events (e.g., full moons, eclipses).
    #- Obtain rare celestial seeds for extraordinary plants.
#
#18. **Garden Zen Mastery:**
    #- Achieve Zen gardening status for meditation and bonus points.
    #- Unlock special Zen gardens with unique plant varieties.
#


func _ready():
    ## Hook up navigation and page changing
    Signals.connect("change_page", change_page)
    for nav_item in get_tree().get_nodes_in_group("nav_item"):
        if nav_item.game_screen:
            var new_screen = nav_item.game_screen.instantiate()
            %GameArea.add_child(new_screen)
            new_screen.hide()
            Globals.GAME_PAGES[new_screen.name.to_lower()] = new_screen

## Change game page
func change_page(page_name):
    for game_screen in get_tree().get_nodes_in_group("game_screen"):
        game_screen.hide()
    Globals.GAME_PAGES[page_name.to_lower()].show()
