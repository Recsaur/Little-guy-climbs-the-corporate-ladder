extends Line2D
@onready var tip_sprite = $"../Sprite2D"
var sprite_offset: float = 7
var joint_count = 12
var segment_length = 25
var smooth_speed = 50.0
var click_radius = 40.0

var is_dragging: bool = false
var points_list: Array[Vector2] = []

func _ready():
	joint_mode = LineJointMode.LINE_JOINT_ROUND
	begin_cap_mode = LineCapMode.LINE_CAP_ROUND
	end_cap_mode = LineCapMode.LINE_CAP_ROUND
	
	if points.size() > 1:
		points_list.resize(points.size())
		for i in range(points.size()):
			points_list[i] = points[i]
		
		joint_count = points_list.size()
		var total_dist = 0.0
		for i in range(1, joint_count):
			total_dist += points_list[i].distance_to(points_list[i-1])
		segment_length = total_dist / (joint_count - 1)
	else:
		clear_points()
		for i in range(joint_count):
			points_list.append(Vector2(0, i * segment_length))
		points = points_list
	
	update_sprite_transform()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var local_mouse = to_local(get_global_mouse_position())
				var tip_position = points_list[-1]
				if local_mouse.distance_to(tip_position) < click_radius:
					is_dragging = true
					GameController.HoldingRoot = true
					get_viewport().set_input_as_handled()
			else:
				is_dragging = false
				GameController.HoldingRoot = false

func _process(delta):
	if is_dragging:
		points_list[-1] = to_local(get_global_mouse_position())
	
	for i in range(joint_count - 2, -1, -1):
		var target = points_list[i + 1]
		var current = points_list[i]
		var direction = (current - target).normalized()
		if direction == Vector2.ZERO: direction = Vector2.DOWN
		
		var desired_pos = target + direction * segment_length
		points_list[i] = points_list[i].lerp(desired_pos, smooth_speed * delta)
	
	points_list[0] = Vector2.ZERO
	
	for i in range(1, joint_count):
		var target = points_list[i - 1]
		var current = points_list[i]
		var direction = (current - target).normalized()
		if direction == Vector2.ZERO: direction = Vector2.DOWN
		
		points_list[i] = target + direction * segment_length
	points = points_list
	
	update_sprite_transform()

func update_sprite_transform():
	if tip_sprite and points_list.size() > 1:
		var tip_pos = points_list[-1]
		var prev_pos = points_list[-2]
		var look_direction = tip_pos - prev_pos
		var wire_angle = look_direction.angle()
		
		tip_sprite.global_rotation = wire_angle + global_rotation
		
		var offset_vector = Vector2.from_angle(wire_angle) * sprite_offset
		var final_local_pos = tip_pos + offset_vector + Vector2(1.5, 0)
		
		tip_sprite.global_position = to_global(final_local_pos)
