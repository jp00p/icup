## Handles the game cursor
extends AnimatedSprite2D

var cursor_name = "default"
var has_item = false
var caret_node

@onready var caret = preload("res://graphics/cursor_caret.png")

func _ready():
    caret_node = Sprite2D.new()
    caret_node.texture = caret
    caret_node.centered = false
    caret_node.hide()
    get_tree().current_scene.add_child(caret_node)
    Input.set_custom_mouse_cursor(sprite_frames.get_frame_texture("default", 0))
    Signals.connect("item_changed", handle_item_cursor)

func _process(_delta):
    Input.set_custom_mouse_cursor(sprite_frames.get_frame_texture(cursor_name, frame))
    if cursor_name not in ["clicked", "default"]:
        caret_node.global_position = get_global_mouse_position()

func _input(event):
    if cursor_name == "default" and event.is_action_pressed("left_click"):
        cursor_name = "clicked"
        caret_node.hide()
    if cursor_name == "clicked" and event.is_action_released("left_click"):
        cursor_name = "default"
        caret_node.hide()
    if event.is_action_released("right_click"):
        ## Reset the cursor and clear any items
        cursor_name = "default"
        caret_node.hide()
        Stats.CURRENT_TOOL = null


func handle_item_cursor(item:BaseItem):
    if item != null:
        if item.cursor_name_normal:
            cursor_name = item.cursor_name_normal
            caret_node.show()
    else:
        cursor_name = "default"
        caret_node.hide()
