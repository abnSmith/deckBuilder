extends Node2D


@onready var numbTXT = $RichTextLabel
@onready var animationPLYR = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationPLYR.play("floatingNumber")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	self.queue_free()
