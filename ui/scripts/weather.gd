extends Control

var local_tick : int = 0
var global_tick : int = 0 : set = set_global_tick
var ordinal : String = "AM"
var time_of_day : int = 1

var sunrise : int = 6
var moonrise : int = 19
var starrise : int = 18
var celestial_phase = "moonrise" : set = set_phase
var celestial_progress : int = 0
var stars_visible : bool = true
var star_progress : int = 0


@onready var animations = %Animations
@onready var sky_anim = %Sky
@onready var sky_rect = %SkyRect
@onready var celestial_anim = %Celestial
@onready var celestial_rect = %CelestialRect
@onready var stars_rect = %StarsRect
@onready var stars_anim = $Animations/Stars


func _ready():
    Signals.connect("global_tick", advance_time)
    animations.hide()
    self.global_tick = 0

func advance_time():
    local_tick += 1
    if local_tick % 3 == 0:
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
    pass

func advance_celestial_objects():
    if global_tick == sunrise:
        self.celestial_phase = "sun"
    if global_tick == moonrise:
        self.celestial_phase = "moon"
    if global_tick == starrise:
        star_progress = 0
        stars_visible = true
    if global_tick == (sunrise + 1):
        stars_visible = false
    celestial_progress += 1
    celestial_anim.frame = celestial_progress
    stars_rect.visible = stars_visible
    if stars_visible:
        star_progress += 1
        stars_anim.frame = star_progress

func set_phase(phase):
    celestial_phase = phase
    celestial_anim.animation = celestial_phase
    celestial_progress = 0

func set_clock_text():
    %Label.text = "%s %s" % [time_of_day, ordinal]

func _on_sky_frame_changed():
    var sky_texture = sky_anim.sprite_frames.get_frame_texture("daycycle", global_tick)
    sky_rect.texture = sky_texture

func _on_celestial_frame_changed():
    var celes_texture = celestial_anim.sprite_frames.get_frame_texture(celestial_phase, celestial_progress)
    celestial_rect.texture = celes_texture

func _on_stars_frame_changed():
    var stars_texture = stars_anim.sprite_frames.get_frame_texture("stars", star_progress)
    stars_rect.texture = stars_texture
