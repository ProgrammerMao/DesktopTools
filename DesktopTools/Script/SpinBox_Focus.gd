extends SpinBox
var _l:LineEdit
func _ready() -> void:
	_get_line_edit()
func _get_line_edit():
	for c in get_children():
		if c is LineEdit:
			_l = c
			break
	assert(is_instance_valid(_l))
func _input(event):
	release(event)
func release(event:InputEvent):
	var result = false
	if event.is_action_pressed("Enter"):
		result = true
	if event is InputEventMouseButton:
		if is_inside(event.position):
			if event.button_index == BUTTON_LEFT and event.pressed:
				_l.grab_focus()
		else:
			result = true
	if result:
		_l.release_focus()
func is_inside(checkpos: Vector2):
	var global_rect:Rect2 = get_global_rect()
	return global_rect.has_point(checkpos)
