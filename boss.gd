extends Node2D
var talkable = false
var player = null
var OGPlayerCamPos = null

@export var dialogue1: DialogueResource
@export var dialogue2: DialogueResource
@export var dialogue3: DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("interact") and talkable:
		#print("pressed")
		#var PlayerCam = player.get_node("Camera2D")
		#var tween = create_tween()
		#tween.tween_property(PlayerCam,"global_position",global_position,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if GameController.boss1:
			var PlayerCam = body.get_node("Camera2D")
			OGPlayerCamPos = PlayerCam.position
			GameController.PlayerMove = false
			var tween = create_tween()
			tween.tween_property(PlayerCam,"global_position",global_position,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
			DialogueManager.show_dialogue_balloon(dialogue1)
			await DialogueManager.dialogue_ended
			GameController.coftask = true
			GameController.boss1 = false
			GameController.PlayerMove = true
			
		if GameController.boss2:
			GameController.boss2 = false
			var PlayerCam = body.get_node("Camera2D")
			OGPlayerCamPos = PlayerCam.position
			GameController.PlayerMove = false
			var tween = create_tween()
			tween.tween_property(PlayerCam,"global_position",global_position,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
			DialogueManager.show_dialogue_balloon(dialogue2)
			await DialogueManager.dialogue_ended
			body.get_node("Coffee").queue_free()
			GameController.nvm = true
			GameController.boss1 = false
			GameController.PlayerMove = true
			
		if GameController.boss3:
			GameController.boss3 = false
			var PlayerCam = body.get_node("Camera2D")
			OGPlayerCamPos = PlayerCam.position
			GameController.PlayerMove = false
			var tween = create_tween()
			tween.tween_property(PlayerCam,"global_position",global_position,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
			DialogueManager.show_dialogue_balloon(dialogue3)
			await DialogueManager.dialogue_ended
			body.get_node("watercup").queue_free()
			#GameController.nvm = false
			#GameController.boss1 = false
			#GameController.PlayerMove = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var PlayerCam = body.get_node("Camera2D")
		var tween = create_tween()
		#GameController.PlayerMove = false
		tween.tween_property(PlayerCam,"position",OGPlayerCamPos,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
