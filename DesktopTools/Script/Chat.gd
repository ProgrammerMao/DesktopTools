extends LineEdit

func _input(event):
	release(event)

func release(event:InputEvent):
	var result = false
	if event.is_action_pressed("Enter"):
		result = true
		if operate == true:
			_on_send_pressed()
	if event is InputEventMouseButton:
		if is_inside(event.position):
			if event.button_index == BUTTON_LEFT and event.pressed:
				grab_focus()
				operate = true
				
		else:
			result = true
			operate = false
	if result:
		release_focus()

func is_inside(checkpos: Vector2):
	var global_rect:Rect2 = get_global_rect()
	return global_rect.has_point(checkpos)

var operate = false


func _on_send_pressed(): #发送
	pass


func _on_client_pressed(): #客户端
	pass


func _on_sever_pressed(): #服务端
	pass
