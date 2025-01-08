extends Node2D

var playerDeck = ["Attack", "Attack", "Attack", "Attack", "Defend", "Defend", "Defend", "Defend", "Potion_LVL1", "Super_Knight"]
var playerDiscard = []
var cardDataRef
const CARD_SCENE = "res://_Scenes/card.tscn"
var numCards
var pilePadding = 200 #padding for deck and discard piles
var rng = RandomNumberGenerator.new()
var screenW
@onready var plyrHand = $"../PlayerHand"
@onready var txtLbl = $RichTextLabel
@onready var discardPile = $"../Discard"

func drawCard():
	var card_drawn = playerDeck[0]
	playerDeck.erase(card_drawn)
	txtLbl.text = str(playerDeck.size())
	cardDataRef = preload("res://_Scripts/CardDatabase.gd")
	
	var cardOBJ = preload(CARD_SCENE)
	print(card_drawn)
	var newCard = cardOBJ.instantiate()
	newCard.get_node("Energy").text = str(cardDataRef.CARDS[card_drawn][0])
	if cardDataRef.CARDS[card_drawn].size() > 2:
		newCard.get_node("Value").show()
		newCard.get_node("Value").text = str(cardDataRef.CARDS[card_drawn][2])
		
		
	$"../CardManager".add_child(newCard)
	newCard.name = "Card"
	$"../PlayerHand".addCardToHand(newCard)
	newCard.get_node("AnimationPlayer").play("card_flip")
	#var timeToWait = rng.randf_range(0.1, 0.5)
	
func discardCard(pCard):
	discardPile.get_node("Count").text = str(int(discardPile.get_node("Count").text) + 1)		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenW = get_viewport_rect().size.x
	self.position = Vector2(pilePadding, self.position.y)
	discardPile.position = Vector2((screenW - pilePadding), self.position.y)
	txtLbl.text = str(playerDeck.size())
	playerDeck.shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
