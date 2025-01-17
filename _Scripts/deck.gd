extends Node2D

#var playerDeck = ["Attack", "Attack", "Attack", "Attack", "Defend", "Defend", "Defend", "Defend", "Potion_LVL1", "Super_Knight"]
var playerDeck = ["Attack", "Attack", "Defend", "Potion_LVL1", "Super_Knight"]
var playerDiscard = []
var cardDataRef
const CARD_SCENE = "res://_Scenes/card.tscn"
var numCards
var deckPadding = 200 #padding for deck and discard piles
var screenW
@onready var plyrHand = $"../PlayerHand"
@onready var txtLbl = $RichTextLabel
@onready var discardPile =$"../../Discard"
@onready var cardMNGR = $"../../../CardManager"
@onready var playerRef = $"../Character"

func drawCard():
	var card_drawn = playerDeck[0]
	playerDeck.erase(card_drawn)
	playerDiscard.append(card_drawn)#THIS MIGHT NOT BE THE BEST WAY TO DO THIS?
	txtLbl.text = str(playerDeck.size())
	cardDataRef = preload("res://_Scripts/CardDatabase.gd")
	
	var cardOBJ = preload(CARD_SCENE)
	var newCard = cardOBJ.instantiate()
	newCard.energyCost = cardDataRef.CARDS[card_drawn][0]
	newCard.cardType = cardDataRef.CARDS[card_drawn][1]
	newCard.cardValue = cardDataRef.CARDS[card_drawn][2]
	
	newCard.get_node("Energy").text = str(newCard.energyCost)
	if newCard.cardType == "Damage" or newCard.cardType == "Shield":
		newCard.get_node("Value").show()
		newCard.get_node("Value").text = str(newCard.cardValue)
	cardMNGR.add_child(newCard)
	newCard.name = "Card_" + newCard.cardType
	plyrHand.addCardToHand(newCard)
	newCard.get_node("AnimationPlayer").play("card_flip")
	#var timeToWait = rng.randf_range(0.1, 0.5)

func playCard(pCard):
	playerRef.playerEnergy -= pCard.energyCost
	playerRef.updateEnergy()
	match pCard.cardType:
		"Heal": cardMNGR.useHealthPotion(pCard)
		"Damage": cardMNGR.attackEnemy(pCard)
		"Shield": cardMNGR.shieldPlayer(pCard)
	
	discardCard(pCard)
	
func discardCard(pCard):
	discardPile.get_node("Count").text = str(int(discardPile.get_node("Count").text) + 1)
			
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenW = get_viewport_rect().size.x
	#self.position = Vector2(deckPadding, self.position.y)
	#discardPile.position = Vector2((screenW - deckPadding), self.position.y)
	txtLbl.text = str(playerDeck.size())
	playerDeck.shuffle()
