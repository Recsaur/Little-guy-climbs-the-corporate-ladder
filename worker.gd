extends CharacterBody2D

@onready var WorkerSprite = $Sprite2D
const SPEED = 650.0
const JUMP_VELOCITY = -550.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction and GameController.PlayerMove:
		SpriteWobble()
		velocity.x = direction * SPEED
	else:
		var tween = create_tween()
		tween.tween_property(WorkerSprite,"rotation_degrees",0,0.25)
		#WorkerSprite.rotation = move_toward(rotation_degrees, 0, 1)
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func SpriteWobble():
	var tween = create_tween()
	tween.tween_property(WorkerSprite,"rotation_degrees",randi_range(-25,25),0.25)
	#WorkerSprite.global_rotation_degrees
