extends Node2D

signal card_ENTER
signal card_EXIT
var initPOS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#this connects all cards when theyre made
	get_parent().connectCardSGN(self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	emit_signal("card_ENTER", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("card_EXIT", self)
	
