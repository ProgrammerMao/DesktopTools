extends LineEdit

func _input(event):
	release(event)

func release(event:InputEvent):
	var result = false
	if event.is_action_pressed("Enter"):
		result = true
		if operate == true:
			_on_go_pressed()
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

var URL = ""
var operate = false

onready var search_engine = get_parent().get_parent().get_node("设置/工具箱设置/搜索引擎/选择")
onready var translation_engine = get_parent().get_parent().get_node("设置/工具箱设置/翻译引擎/选择")
onready var content = get_parent().get_node("输入")
onready var search = get_parent().get_parent().get_node("搜索框/切换引擎/搜索")
onready var translation = get_parent().get_parent().get_node("搜索框/切换引擎/翻译")
onready var current = get_parent().get_parent().get_node("设置/工具箱设置/翻译引擎/翻译/当前")
onready var target = get_parent().get_parent().get_node("设置/工具箱设置/翻译引擎/翻译/目标")

func _on_go_pressed():
	#搜索
	if search.visible == true:
		if search_engine.selected == 0: #百度
			URL = "https://www.baidu.com/s?wd="
		if search_engine.selected == 2: #必应
			URL = "https://cn.bing.com/search?q="
		if search_engine.selected == 2: #B站
			URL = "https://search.bilibili.com/all?keyword="
		if search_engine.selected == 3: #华为
			URL = "https://petalsearch.com/search?query="
		if search_engine.selected == 4: #谷歌
			URL = "https://www.google.com.hk/search?q="
	#翻译
	else:
		if translation_engine.selected == 0: #百度翻译
			URL = "https://fanyi.baidu.com/"
			print(current.selected)
			#当前
			if current.selected == 0: #中文
				URL += "#zh/"
			if current.selected == 1: #英语
				URL += "#en/"
			if current.selected == 2: #日语
				URL += "#jp/"
			
			#目标
			if target.selected == 0: #中文
				URL += "zh/"
			if target.selected == 1: #英语
				URL += "en/"
			if target.selected == 2: #日语
				URL += "jp/"
		
		if translation_engine.selected == 1: #谷歌翻译
			URL = "https://translate.google.cn/?sl="
			
			#当前
			if current.selected == 0: #中文
				URL += "zh-CN&t="
			if current.selected == 1: #英语
				URL += "en&t="
			if current.selected == 2: #日语
				URL += "ja&tl="
			
			#目标
			if target.selected == 0: #中文
				URL += "zh-CN&text="
			if target.selected == 1: #英语
				URL += "en&text="
			if target.selected == 2: #日语
				URL += "ja&text="
	
	OS.shell_open(URL + content.text.replace("+","%2B").replace(" ","%20").replace("=","%3D"))
	content.text = ""

