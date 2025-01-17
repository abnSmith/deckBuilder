extends Node2D
var actCard
var screenSize
var cardSize: Vector2
var hoveringOnCard
var playableCard
@onready var playerHandRef = $"../CanvasLayer/BottomLeft_CNTRL/PlayerHand"
@onready var playerDeckRef = $"../CanvasLayer/BottomLeft_CNTRL/Deck"
@onready var playerRef = $"../CanvasLayer/BottomLeft_CNTRL/Character"
@onready var enemyMNGR = $"../CanvasLayer/EnemyManager"

const PLAYCOLOR = Vector4(255, 255, 255, 255)
const CLICKCOLOR = Vector4(39, 0, 27, 255)
func _ready() -> void:
	screenSize = get_viewport_rect().size
	await  get_tree().create_timer(0.5).timeout
	for i in range(5):
		playerDeckRef.drawCard()
		await  get_tree().create_timer(0.2).timeout#let each card come in at a time interval to make it visually interesting if theres more then one
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if actCard:
		if !cardSize: #if i dont have the card size info
			cardSize.x = actCard.get_node("CardImg").texture.get_width()/2 -6
			cardSize.y = actCard.get_node("CardImg").texture.get_height()/2 -10

		var mouse_POS = get_global_mouse_position()
		#utilizes card size so the full card stays on screen
		actCard.position = Vector2(clamp(mouse_POS.x, cardSize.x, (screenSize.x - cardSize.x)), clamp(mouse_POS.y, cardSize.y, (screenSize.y -cardSize.y)))
		var cardY = actCard.position.y + cardSize.y
		if cardY < (screenSize.y/2):#if card is above the middlepoint of the screen it becomes playable
			actCard.get_node("CardImg").material.set_shader_parameter("outlineCLR", PLAYCOLOR)
			playableCard = actCard
				
		else:
			actCard.get_node("CardImg").material.set_shader_parameter("outlineCLR", CLICKCOLOR)
			playableCard = null
		
func _input(event):
	if event.is_action_pressed("mouseClick_LEFT"):
		actCard = check_for_card()
		if actCard:startDrag()
	if event.is_action_released("mouseClick_LEFT"):
		stopDrag()
		
func startDrag():
	actCard.scale = Vector2(1, 1) 
	
func stopDrag():
	if actCard: actCard.scale = Vector2(1.05, 1.05)
	if playerRef.playerEnergy < actCard.energyCost: playableCard = null
	if playableCard: 
		playerHandRef.removeCardFromHand(playableCard)
		playerDeckRef.playCard(playableCard)
		playableCard.queue_free()
		
	else: playerHandRef.addCardToHand(actCard)
	playableCard = null
	actCard = null
	
func connectCardSGN(pCard):#connects the signals from the card obj to the card manager obj
	pCard.connect("card_ENTER", onEnter_CARD)
	pCard.connect("card_EXIT", onExit_CARD)

func onEnter_CARD(pCard):#onHover of card
	if !hoveringOnCard:
		hoveringOnCard = true
		highlightCard(pCard, true)
	
func onExit_CARD(pCard):#on exit of card
	if !actCard:
		highlightCard(pCard, false)
		var newACTCard = check_for_card()
		if newACTCard: highlightCard(newACTCard, true)
		else: hoveringOnCard = false

func highlightCard(pCard, isHovered):#effect for hovering on the card
	if isHovered:
		pCard.scale = Vector2(1.05, 1.05)
		pCard.z_index = 2
		pCard.get_node("CardImg").material.set_shader_parameter("width", 2.0)
		pCard.get_node("CardImg").material.set_shader_parameter("outlineCLR", CLICKCOLOR)
	else:
		pCard.scale = Vector2(1.0, 1.00)
		pCard.z_index = 1
		pCard.get_node("CardImg").material.set_shader_parameter("width", 0.0)
		
		
func check_for_card():#raycast function to figure out which card is being pressed
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:#if we have a result
		var highest_z_card = result[0].collider.get_parent()
		#if we are hovering over more then one card
		for i in range(1, result.size()):
			var currCard = result[i].collider.get_parent()
			if currCard.z_index > highest_z_card.z_idex:
				highest_z_card = currCard
				
		return highest_z_card#
	return null
	
func useHealthPotion(pCard):
	var newHP = randi_range(pCard.cardValue[0], pCard.cardValue[1]) + playerRef.healingMod
	#if playerRef.playerHealth != playerRef.startingHealth: playerRef.changeHealth(newHP, true)
	playerRef.healthComponent.addHealth(newHP)

func attackEnemy(pCard):
	enemyMNGR.currEnemies[0].healthComponent.subtractHealth(pCard.cardValue)

func shieldPlayer(pCard):
	playerRef.shieldComponent.addShield(pCard.cardValue)
	
