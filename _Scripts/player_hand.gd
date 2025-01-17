extends Node2D

const HANDCNT = 5
const CARD_SCENE = "res://_Scenes/card.tscn"
const CARDW = 200
const HANDY = 890
var playerHand = []
var centerScreenX 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centerScreenX = get_viewport().size.x/ 2
	

func addCardToHand(pCard):
	if pCard not in playerHand:
		playerHand.insert(0, pCard)
		updateHandPOS()
	else:
		animateCardToPOS(pCard, pCard.initPOS)
	
func updateHandPOS():
	for i in range(playerHand.size()):
		#get cards position based on index in arr
		var newPOS = Vector2(calcCardPOS(i), HANDY)
		var card = playerHand[i]
		card.initPOS =  newPOS
		animateCardToPOS(card, newPOS)

func animateCardToPOS(pCard, pPOS):
	var tween = get_tree().create_tween()
	tween.tween_property(pCard, "position", pPOS, 0.25)
	
func calcCardPOS(pIndex):
	var totalW = (playerHand.size() -1) * CARDW
	var x_offset = centerScreenX + pIndex* CARDW - totalW/ 2
	return x_offset
	
func removeCardFromHand(pCard):
	if pCard in playerHand:
		playerHand.erase(pCard)
		updateHandPOS()
	pass
	
