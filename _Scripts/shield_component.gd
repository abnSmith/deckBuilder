extends Node2D
const DAMAGENUMB = "res://_Scenes/floating_number.tscn"

@export var healthComp : HealthComponent
@onready var shieldBar = $Shield
@onready var shieldLbl = $Shield/Shield_Lbl
var currentShield : int

	
func addShield(pShield):
	currentShield += pShield
	updateShieldVisuals()#update what the healthbar and label show	
	spawnNumber(("+" + str(pShield)))
	
func subtractShield(pShield):
	currentShield -= pShield
	if currentShield < 0:
		healthComp.subtractHealth(absi(currentShield))
		currentShield = 0 #sets health to 0
		
	updateShieldVisuals()#update what the healthbar and label show	
	spawnNumber(("-" + str(pShield)))

func updateShieldVisuals():
	shieldBar.value = currentShield
	shieldLbl.text = str(currentShield)	
	
func spawnNumber(pNum):
	var numbOBJ = preload(DAMAGENUMB)
	var newNumb = numbOBJ.instantiate()
	newNumb.get_node("Label").text = pNum
	self.add_child(newNumb)
	var xPos = randi_range(-30,30)
	newNumb.position = Vector2(xPos, -20)	
