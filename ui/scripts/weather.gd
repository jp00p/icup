extends Control

# measurements
var hour_length : int = 5 # ticks
var day_length : int = 24 # hours
var season_length : int = 14 # days

# timekeeping
var local_tick : int = 0
var season_tick : int = 0
var global_tick : int = 0 : set = set_global_tick
var ordinal : String = "AM"
var time_of_day : int = 1
var season : Globals.SEASONS = Globals.SEASONS.SPRING

# sky objects
var sunrise : int = 6
var dusk : int = 15
var moonrise : int = 19
var starrise : int = 18
var celestial_phase = "moonrise" : set = set_phase
var celestial_progress : int = 0
var stars_visible : bool = true
var star_progress : int = 0
var weather : Array
var overcast : bool = false
var raining : bool = false

# all the nodes
@onready var animations = %Animations
@onready var sky_anim = %Sky
@onready var sky_rect = %SkyRect
@onready var celestial_anim = %Celestial
@onready var celestial_rect = %CelestialRect
@onready var stars_rect = %StarsRect
@onready var stars_anim = $Animations/Stars
@onready var clouds_rect = %CloudsRect
@onready var clouds_anim = %Clouds
@onready var weather_anim = %Weather
@onready var weather_rect = %WeatherRect

func _ready():
    Signals.connect("global_tick", advance_time)
    animations.hide()
    self.global_tick = 0

func advance_time():
    local_tick += 1
    if local_tick % hour_length == 0:
        local_tick = 0
        self.global_tick = global_tick + 1

func set_global_tick(tick):
    global_tick = int(fposmod(tick, 24))
    time_of_day = wrapi(global_tick,1,13)
    ordinal = "AM"
    if global_tick > 11:
        ordinal = "PM"
    if global_tick == 0:
        new_day()
    sky_anim.frame = global_tick
    advance_celestial_objects()
    set_clock_text()

func new_day():
    set_weather()
    season_tick += 1
    if season_tick % season_length == 0:
        next_season()

func next_season():
    pass

func advance_clouds():
    pass

func advance_celestial_objects():
    celestial_rect.visible = !overcast
    sky_rect.visible = !overcast
    if global_tick == sunrise:
        self.celestial_phase = "sun"
    if global_tick == moonrise:
        self.celestial_phase = "moon"
    if global_tick == starrise:
        star_progress = 0
        stars_visible = true
    if global_tick == (sunrise + 1):
        stars_visible = false
    clouds_anim.frame = 0
    if overcast and stars_visible:
        clouds_anim.frame = 1

    celestial_progress += 1
    celestial_anim.frame = celestial_progress
    stars_rect.visible = stars_visible && !overcast
    if stars_visible and !overcast:
        star_progress += 1
        stars_anim.frame = star_progress

func set_weather():
    weather = Globals.pick_weather(Globals.SEASONS.WINTER)
    var precip = weather[0]
    var clouds = weather[1]
    print("%s %s" % [precip, clouds])
    if precip == "CLEAR":
        weather_rect.hide()
        weather_anim.stop()
        raining = false
    else:
        weather_rect.show()
        weather_anim.animation = precip.to_lower()
        weather_anim.play()
        raining = true
    if clouds == "CLEAR":
        clouds_rect.hide()
    else:
        if clouds == "OVERCAST":
            overcast = true
        clouds_rect.show()
        clouds_anim.animation = clouds.to_lower()

func set_phase(phase):
    celestial_phase = phase
    celestial_anim.animation = celestial_phase
    celestial_progress = 0

func set_clock_text():
    %Label.text = "%s %s\n%s/%s" % [time_of_day, ordinal, weather[0].to_lower(), weather[1].to_lower()]

func get_spriteframes_texture(frames:SpriteFrames, anim_name:String, frame:int) -> Texture2D:
    return frames.get_frame_texture(anim_name, frame)


func _on_sky_frame_changed():
    var sky_texture = get_spriteframes_texture(sky_anim.sprite_frames, "daycycle", global_tick)
    sky_rect.texture = sky_texture

func _on_celestial_frame_changed():
    var celes_texture = get_spriteframes_texture(celestial_anim.sprite_frames, celestial_phase, celestial_progress)
    celestial_rect.texture = celes_texture

func _on_stars_frame_changed():
    var stars_texture = get_spriteframes_texture(stars_anim.sprite_frames, "stars", star_progress)
    stars_rect.texture = stars_texture

func _on_weather_frame_changed():
    var weather_texture = get_spriteframes_texture(weather_anim.sprite_frames, weather_anim.animation, weather_anim.frame)
    weather_rect.texture = weather_texture

func _on_clouds_frame_changed():
    var clouds_texture = get_spriteframes_texture(clouds_anim.sprite_frames, clouds_anim.animation, clouds_anim.frame)
    clouds_rect.texture = clouds_texture

func _on_clouds_animation_changed():
    _on_clouds_frame_changed()
