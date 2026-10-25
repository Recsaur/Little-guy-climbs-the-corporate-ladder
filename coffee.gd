extends Node2D
const coffee = preload("res://coffeegot.tscn")
@onready var sprite = $AnimatedSprite2D
var interactable = false
var spriteog:Vector2 = Vector2.ZERO
var ShakeStrength = 0.0
var takeable = false
var player = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spriteog = sprite.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ShakeStrength > 0.0:
		sprite.position = spriteog + Vector2(randf_range(-ShakeStrength,ShakeStrength),randf_range(-ShakeStrength,ShakeStrength))
	if Input.is_action_just_pressed("interact") and interactable:
		GameController.showinteract = false
		ShakeStrength += 1
		AudioController.wat()
		$AnimatedSprite2D.play("default")
		await $AnimatedSprite2D.animation_finished
		ShakeStrength -= 1
		takeable = true
		GameController.showinteract = true
		interactable = false
		#$AnimatedSprite2D.frame = 1
	if Input.is_action_just_pressed("interact") and takeable:
		GameController.showinteract = false
		takeable = false
		sprite.frame = 0
		var coffee = coffee.instantiate()
		GameController.boss2 = true
		coffee.global_position.y -= 125
		player.add_child(coffee)
		GameController.coftask = false
		
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not takeable and GameController.coftask:
		interactable = true
		GameController.showinteract = true
		player = body
	pass # Replace with function body.
