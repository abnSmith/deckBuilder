extends Node2D
const DAMAGENUMB = "res://_Scenes/floating_number.tscn"

var playerCharacterRef
@onready var healthComponent : HealthComponent = $HealthComponent
@onready var shieldComponent = $ShieldComponent
@onready var energyLBL = $EnergyContainer/RichTextLabel
var character = "Kinght" #this will eventually be filled in dynamically
var startingDMG: int #base character damage based on chosen character 
var playerDMG:int #active character damage(so if there is level ups etc)
var playerEnergy:int = 3
var healingMod:int #players healing based on character
var screenSize

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size
	playerCharacterRef = preload("res://_Scripts/CharacterDatabase.gd")
	var actCharacter = playerCharacterRef.CHARACTERS[character]
	healthComponent.maxHealth = actCharacter[0]
	healthComponent.currentHealth = actCharacter[0]
	healthComponent.healthBar.set_max(actCharacter[0])
	healthComponent.updateHealthVisuals()
	shieldComponent.currentShield = 0
	shieldComponent.updateShieldVisuals()

	#self.position = Vector2(screenSize.x/2, screenSize.y - 200)
	playerCharacterRef = preload("res://_Scripts/CharacterDatabase.gd")
	startingDMG =actCharacter[2]
	healingMod = actCharacter[3]
	playerDMG = startingDMG
	energyLBL.text = "[center]" + str(playerEnergy) + "[center]"

func updateEnergy():
	energyLBL.text = "[center]" + str(playerEnergy) + "[center]"
	
			
