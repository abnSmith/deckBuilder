extends Node2D

const ENEMYOBJ = "res://_Scenes/enemy.tscn"
const DAMAGENUMB = "res://_Scenes/floating_number.tscn"
var enemyDict
var screenSize
var currEnemies = []
var dmgNumbers
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawnEnemy(pType):
	enemyDict = preload("res://_Scripts/EnemyDatabase.gd")
	var enemyOBJ = preload(ENEMYOBJ)
	var newEnemy = enemyOBJ.instantiate()
	self.add_child(newEnemy)
	newEnemy.name = "Card_" + pType
	newEnemy.healthComponent.maxHealth = enemyDict.FIRSTFLOOR_ENEMIES[pType][0]
	newEnemy.healthComponent.currentHealth = enemyDict.FIRSTFLOOR_ENEMIES[pType][0]
	
	newEnemy.healthComponent.healthBar.set_max(enemyDict.FIRSTFLOOR_ENEMIES[pType][0])
	newEnemy.healthComponent.healthBar.value = enemyDict.FIRSTFLOOR_ENEMIES[pType][0]
	newEnemy.position = Vector2(int(screenSize.x/2), 400)
	currEnemies.append(newEnemy)
	
	
