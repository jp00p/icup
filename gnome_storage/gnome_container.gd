extends Resource
class_name GnomeContainer

@export var container_name : String = "Default container"
@export var storage_size : int = 5
@export var cost : int = 1

func _init(n:String=container_name, s:int=storage_size, c:int=cost):
    container_name=n
    storage_size=s
    cost=c
