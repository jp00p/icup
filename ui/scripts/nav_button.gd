extends Control

@export var game_screen:PackedScene
@export var screen_name:String = ""
@export var button_title:String = ""
@export var active:bool = false : set = set_active

func _ready():
    $Button.text = button_title

func set_active(val):
    active = val

func _on_button_pressed():
    Signals.change_page.emit(screen_name)
