extends Node2D
const wires = preload("res://wires.tscn")
const coffeepath = preload("res://paper.tscn")
var endpath = load("res://ending.tscn")
var talkable = false
var player = null
var OGPlayerCamPos = null
var printer1 = true
var takeable = false
@onready var boss = get_parent().get_node("Boss")

@export var dialogue1: DialogueResource
@export var dialogue2: DialogueResource
@export var dialogue3: DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameController.bossfinal:
		GameController.bossfinal = false
		var PlayerCam = player.get_node("Camera2D")
		OGPlayerCamPos = PlayerCam.position
		GameController.PlayerMove = false
		var tween = create_tween()
		tween.tween_property(PlayerCam,"global_position",boss.global_position,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
		DialogueManager.show_dialogue_balloon(dialogue3)
		await DialogueManager.dialogue_ended
		get_tree().change_scene_to_packed(endpath)
	if GameController.PrinterFix:
		PrinterDo()
	if Input.is_action_just_pressed("interact") and takeable:
		takeable = false
		GameController.showinteract = false
		$AnimatedSprite2D.frame = 0
		var coffee = coffeepath.instantiate()
		#GameController.boss3 = true
		coffee.global_position.y -= 125
		player.add_child(coffee)
		await get_tree().create_timer(1.5).timeout
		var PlayerCam = player.get_node("Camera2D")
		OGPlayerCamPos = PlayerCam.position
		GameController.PlayerMove = false
		var tween = create_tween()
		tween.tween_property(PlayerCam,"global_position",boss.global_position,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
		DialogueManager.show_dialogue_balloon(dialogue2)
		await DialogueManager.dialogue_ended
		var tweena = create_tween()
		tweena.tween_property(PlayerCam,"position",OGPlayerCamPos,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
		GameController.PlayerMove = true
		GameController.Shreddable = true
		#GameController.nvm = false

func PrinterDo():
	GameController.PrinterFix = false
	$AnimatedSprite2D.play("default")
	await $AnimatedSprite2D.animation_finished
	takeable = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	if body.is_in_group("Player"):
		if printer1:
			var PlayerCam = body.get_node("Camera2D")
			OGPlayerCamPos = PlayerCam.position
			GameController.PlayerMove = false
			var tween = create_tween()
			tween.tween_property(PlayerCam,"global_position",global_position,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
			DialogueManager.show_dialogue_balloon(dialogue1)
			await DialogueManager.dialogue_ended
			printer1 = false
			var wirgame = wires.instantiate()
			#wirgame.position = position
			add_child(wirgame)
			#GameController.PlayerMove = true
		if GameController.PrinterFix:
			AudioController.pri()
			$AnimatedSprite2D.play("default")
			await $AnimatedSprite2D.animation_finished
			takeable = true
			GameController.showinteract = true
			GameController.PrinterFix = false
			#var PlayerCam = body.get_node("Camera2D")
			#OGPlayerCamPos = PlayerCam.position
			#GameController.PlayerMove = false
			#var tween = create_tween()
			#tween.tween_property(PlayerCam,"global_position",global_position,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
			#DialogueManager.show_dialogue_balloon(dialogue2)
			#await DialogueManager.dialogue_ended
			#printer1 = false
			#var wirgame = wires.instantiate()
			#add_child(wirgame)
			
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var PlayerCam = body.get_node("Camera2D")
		var tween = create_tween()
		#GameController.PlayerMove = false
		tween.tween_property(PlayerCam,"position",OGPlayerCamPos,0.25).set_trans(Tween.TRANS_SPRING) #PlayerCam.global_position = global_position
