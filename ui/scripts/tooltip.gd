extends Control

@onready var textlabel = $RichTextLabel

var tracked_resource:Resource
var custom_text:String = ""
var tooltip_content:String = ""

func _ready():
    if tracked_resource and tracked_resource.has_method("tooltip_template"):
        tooltip_content = tracked_resource.tooltip_template()
    if custom_text != "":
        tooltip_content = custom_text

func _process(_delta):
    if tracked_resource and tracked_resource.has_method("tooltip_template"):
        tooltip_content = tracked_resource.tooltip_template()
    textlabel.text = tooltip_content
