extends CanvasLayer
var red = false
var yellow = false
var green = false
var blue = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(red,blue,green,yellow)
	if red and blue and green and yellow:
		print("YAHU")
		GameController.PlayerMove = true
		GameController.PrinterFix = true
		queue_free()




func _on_red_area_entered(area: Area2D) -> void:
	print("RERRWE")
	print(area.get_groups())
	if area.is_in_group(&"red"):
		red = true
		print("YAHOO")

func _on_red_area_exited(area: Area2D) -> void:
	if area.is_in_group(&"red"):
		red = false


func _on_yellow_area_entered(area: Area2D) -> void:
	if area.is_in_group(&"yellow"):
		yellow = true


func _on_yellow_area_exited(area: Area2D) -> void:
	if area.is_in_group(&"yellow"):
		yellow = false


func _on_green_area_entered(area: Area2D) -> void:
	if area.is_in_group(&"green"):
		green = true


func _on_green_area_exited(area: Area2D) -> void:
	if area.is_in_group(&"green"):
		green = false


func _on_blue_area_entered(area: Area2D) -> void:
	if area.is_in_group(&"blue"):
		blue = true


func _on_blue_area_exited(area: Area2D) -> void:
	if area.is_in_group(&"blue"):
		blue = false
