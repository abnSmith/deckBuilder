extends Node2D
@onready var startFight_timer = $startFightTimer
@onready var enemyMNGR = $CanvasLayer/EnemyManager

var screenSize
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size
	#healthBar.position = Vector2(screenSize/2, healthBar.position.y)
	#shieldBar.position = Vector2(screenSize/2, shieldBar.position.y)
	startFight_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_fight_timer_timeout() -> void:
	enemyMNGR.spawnEnemy("Slime")
