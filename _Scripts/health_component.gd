extends Node2D
class_name HealthComponent

const DAMAGENUMB = "res://_Scenes/floating_number.tscn"

@export var playerChar : bool 
@export var maxHealth: int
@onready var healthBar = $Health
@onready var healthLbl = $Health/Health_Lbl
@onready var deathTimer = $Timer
var currentHealth : int

func _ready() -> void:
	if playerChar:
		healthLbl.show()
			
func addHealth(pHealth):
	var addedHealth : int = pHealth
	currentHealth += addedHealth
	if currentHealth > maxHealth: #player cant heal over max health
		addedHealth = pHealth - (currentHealth - maxHealth)#get how much the player heals up to max
		currentHealth = maxHealth #sets new health to max health
	
	updateHealthVisuals()#update what the healthbar and label show	
	spawnNumber(("+" + str(addedHealth)))
	
func subtractHealth(pHealth):
	var subtractedHealth : int = pHealth
	currentHealth -= subtractedHealth
	if currentHealth <= 0:
		currentHealth = 0 #sets health to 0
		deathTimer.start()
	updateHealthVisuals()#update what the healthbar and label show	
	spawnNumber(("-" + str(subtractedHealth)))

func updateHealthVisuals():
	healthBar.value = currentHealth
	if playerChar:healthLbl.text = str(currentHealth) + "/" + str(maxHealth)	
	
func spawnNumber(pNum):
	var numbOBJ = preload(DAMAGENUMB)
	var newNumb = numbOBJ.instantiate()
	newNumb.get_node("Label").text = pNum
	self.add_child(newNumb)
	var xPos = randi_range(-30,30)
	newNumb.position = Vector2(xPos, -20)	

func _on_timer_timeout() -> void:
	if playerChar: get_tree().reload_current_scene()
	else: self.queue_free()
