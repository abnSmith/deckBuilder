extends Node2D
var actCard
var screenSize

func _ready() -> void:
	screenSize = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if actCard:
		var mouse_POS = get_global_mouse_position()
		actCard.position = Vector2(clamp(mouse_POS.x, 0, screenSize.x), clamp(mouse_POS.y, 0, screenSize.y))
	

func _input(event):
	if event.is_action_pressed("mouseClick_LEFT"):
		#print("CLICKED")
		actCard = check_for_card()	
	if event.is_action_released("mouseClick_LEFT"):
		#print("RELEASED")
		actCard = null

func check_for_card():#raycast function to figure out which card is being pressed
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result:return result[0].collider.get_parent()#if we get a result(are clicking on a card get its collider parent(the card obj)
	return null
	
