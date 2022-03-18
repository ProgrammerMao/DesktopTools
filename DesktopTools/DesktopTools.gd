extends Control

#系统时间
var time = 0
var hour = 0
var minute = 0
var second = 0
var year = 0
var month = 0
var day = 0
var weekday = 0

#设置
var self_start = 0
var transparency = 0.0

#随机数
var random = RandomNumberGenerator.new()

#按钮
var scaling_num = 1
var positive_num = 1
var tool_num = 0
var setupschoose_num = 0
var toolbox_num = 1
var setups_num = 1
var about_num = 1

#检测
var setup = false
var toolbox = false
var about = false

#时间
var time_judgement = false
var time_minute = 0
var time_second = 0
var time_new = 0
var time_old = 0

#其他
var handoff = 0
var screen = OS.get_screen_size().x
var window = OS.window_size.x

#文件
var file_path = "C://ProgramData//DesktopTools//" #导出发布
#var file_path = "res://DesktopTools//" #编辑器调试
var file_data = file_path + "data.json"
var data = {"transparency" : 75,
			"self_start" : 0,
			"number_under" : 1,
			"number_upper" : 35,
			"search_engine" : 0,
			"handoff" : 0,
			"translation_current" : 1,
			"translation_target" : 0,
			"corner" : 1
			}

func _ready(): #开始
	get_viewport().transparent_bg = true
	#读取
	var file = File.new()
	var err = file.open(file_data,File.READ)
	if err == OK:
		data = parse_json(file.get_as_text())
	else:
		save()
	$"设置/透明度/内容".value = data.transparency #透明度
	$"设置/开机启动/选择".selected = data.self_start #开机启动
	$"设置/人数/下限".value = data.number_under #人数下限
	$"设置/人数/上限".value = data.number_upper #人数上限
	$"设置/搜索引擎/选择".selected = data.search_engine #搜索引擎
	handoff = data.handoff #切换
	$"设置/翻译引擎/翻译/当前".selected = data.translation_current #当前
	$"设置/翻译引擎/翻译/目标".selected = data.translation_target #目标
	$"设置/边角形状/选择".selected = data.corner #圆角
	
	file.close()
	
	handoff()
	transparency() #透明度
	self_start() #开机启动
	tools() #工具选择
	corner()

func _process(delta): #主循环
	if OS.window_position.x != screen - window - 25 or OS.window_position.y !=  25:
		OS.window_position.x = screen - window - 25
		OS.window_position.y =  25
	
	
	#获取时间
	time = OS.get_datetime()
	hour = time.hour
	minute = time.minute
	second = time.second
	year = time.year 
	month = time.month
	day = time.day
	weekday = time.weekday
	
	#限制
	OS_time()
	
	#保存与应用
	if $"设置/透明度/内容".value != data.transparency: #透明度
		data.transparency = $"设置/透明度/内容".value
		transparency()
		save()
	
	if $"设置/开机启动/选择".selected != data.self_start: #开机启动
		data.self_start = $"设置/开机启动/选择".selected
		self_start()
		save()
	
	if $"设置/边角形状/选择".selected != data.corner: #边角形状
		data.corner = $"设置/边角形状/选择".selected
		corner()
		save()
	
	#功能
	if $"工具箱/选择".selected != tool_num: #工具选择
		tool_num = $"工具箱/选择".selected
		tools()
	
	
	if $"设置/人数/下限".value != data.number_under: #人数下限
		if $"设置/人数/下限".value >= $"设置/人数/上限".value:
			$"设置/人数/下限".value = $"设置/人数/上限".value - 1
		data.number_under = $"设置/人数/下限".value
		save()
	
	if $"设置/人数/上限".value != data.number_upper: #人数上限
		data.number_upper = $"设置/人数/上限".value
		save()
	
	if $"设置/搜索引擎/选择".selected != data.search_engine: #搜索引擎
		data.search_engine = $"设置/搜索引擎/选择".selected
		$"搜索框/输入".placeholder_text = $"设置/搜索引擎/选择".text
		save()
	
	if handoff != data.handoff:
		data.handoff = handoff
		handoff()
		save()
	
	if $"设置/翻译引擎/翻译/当前".selected != data.translation_current or $"设置/翻译引擎/翻译/目标".selected != data.translation_target:
		data.translation_current = $"设置/翻译引擎/翻译/当前".selected
		data.translation_target = $"设置/翻译引擎/翻译/目标".selected
		save()

func OS_time(): #时间显示
	var time_h_m_s = ""
	var time_y_m_d_w = ""
	
	if hour < 10: #时
		time_h_m_s += "0" + String(hour)
	else:
		time_h_m_s += String(hour)
	
	if minute < 10:#分
		time_h_m_s += ":0" + String(minute)
	else:
		time_h_m_s += ":" + String(minute)
	
	if second < 10: #秒
		time_h_m_s += ":0" + String(second)
	else:
		time_h_m_s += ":" + String(second)
	
	
	time_y_m_d_w += String(year) + "年" #年
	
	if month < 10: #月
		time_y_m_d_w += String(month) + "月"
	else:
		time_y_m_d_w += String(month) + "月"
	
	if day < 10: #日
		time_y_m_d_w += String(day) + "日"
	else:
		time_y_m_d_w += String(day) + "日"
	
	#星期
	if weekday == 1: #星期一
		time_y_m_d_w += " 星期一"
	if weekday == 2: #星期二
		time_y_m_d_w += " 星期二"
	if weekday == 3: #星期三
		time_y_m_d_w += " 星期三"
	if weekday == 4: #星期四
		time_y_m_d_w += " 星期四"
	if weekday == 5: #星期五
		time_y_m_d_w += " 星期五"
	if weekday == 6: #星期六
		time_y_m_d_w += " 星期六"
	if weekday == 0: #星期日
		time_y_m_d_w += " 星期日"
	
	$"时间/时 分 秒".text = time_h_m_s
	$"时间/年 月 日 星期".text = time_y_m_d_w
	time_h_m_s = ""
	time_y_m_d_w = ""

func _on_setups_pressed(): #设置
	var size_x = 0
	var size_y = 0
	setups_num += 1
	if setups_num % 2 == 0:
		size_x = 0
		setup = true
		if toolbox == true:
			size_y = 150 + 184 -1
		else:
			size_y = 150 - 1
	else:
		size_x = (250 + 25) * 1
		setup = false
		if toolbox == true:
			size_y = 100
		else:
			size_y = -80
		if about == true:
			about = false
			_on_about_pressed()
	$"设置".rect_position.y = size_y
	$"设置".rect_position.x = size_x
	OS.window_size.y = size_y + 215

func _on_toolbox_pressed(): #工具箱
	var size_x = 0
	var size_y = 0
	toolbox_num += 1
	if toolbox_num % 2 == 0:
		size_x = 0
		toolbox = true
		size_y  = 125 + 24
	else:
		size_x = (250 + 25) * 2
		toolbox = false
		if setup == true:
			size_y = 185
		else:
			size_y = -35
	$"工具箱".rect_position.y = size_y
	$"工具箱".rect_position.x = size_x
	if setup == true:
		setups_num += 1
		_on_setups_pressed()
		if about == true:
			about_num += 1
			_on_about_pressed()
	else:
		OS.window_size.y = size_y + 160

func _on_scaling_pressed(): #缩放
	scaling_num += 1
	if scaling_num % 2 == 0:
		if $"设置/边角形状/选择".selected == 1:
			$"标题/边角/圆角".visible = false
			$"标题/边角/缩放圆角".visible = true
		OS.set_window_mouse_passthrough($"标题/缩放/穿透".curve.get_baked_points())
		$"标题/缩放/缩放".rect_position.x = 22
		$"标题/缩放/缩放".rect_position.y = 22
		$"标题/缩放/缩放".rect_rotation = 180
		$"标题/工具箱".visible = false
	else:
		if $"设置/边角形状/选择".selected == 1:
			$"标题/边角/圆角".visible = true
			$"标题/边角/缩放圆角".visible = false
		OS.set_window_mouse_passthrough([])
		$"标题/缩放/缩放".rect_position.x = 2
		$"标题/缩放/缩放".rect_position.y = 2
		$"标题/缩放/缩放".rect_rotation = 0
		$"标题/工具箱".visible = true

func save(): #保存
	#创建
	var create = Directory.new()
	if not create.dir_exists(file_data.get_base_dir()):
		create.make_dir_recursive(file_data.get_base_dir())
	
	#保存
	var file = File.new()
	file.open(file_data,File.WRITE)
	file.store_line(to_json(data))
	file.close()

func _on_quit_pressed(): #退出
	get_tree().quit()

func self_start(): #开机启动
	self_start = $"设置/开机启动/选择".selected
	OS.execute("cmd", ["start cmd -v runas -Args /c reg delete HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\run /v DesktopTools /f"],true,[])
	if self_start == 0:
		OS.execute("cmd", ["start cmd -v runas -Args /c reg add HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\run /v DesktopTools /t REG_SZ /d " + OS.get_executable_path().replace("/","\\")],true,[])

func transparency(): #透明度
	transparency = float($"设置/透明度/内容".value) / 100
	$"标题".color.a = transparency
	$"标题/缩放".color.a = transparency
	$"标题/设置".color.a = transparency
	$"标题/工具箱".color.a = transparency
	$"时间".color.a = transparency
	$"工具箱".color.a = transparency
	$"设置".color.a = transparency
	$"关于".color.a = transparency
	$"搜索框".color.a = transparency
	$"搜索框/切换引擎".color.a = transparency
	$"搜索框/前往".color.a = transparency
	$"标题/边角".modulate.a = transparency
	$"搜索框/圆角".modulate.a = transparency
	$"工具箱/边角".modulate.a = transparency
	$"设置/边角".modulate.a = transparency
	$"关于/边角".modulate.a = transparency

func corner(): #边角形状
	if $"设置/边角形状/选择".selected == 0: #直角
		$"标题/边角/直角".rect_size.x = 12
		$"标题/边角/圆角".visible = false
		
		$"标题/缩放".rect_size.x = 24
		$"标题/边角/圆角".visible = false
		
		$"搜索框/切换引擎".rect_size.x = 24
		$"搜索框/前往".rect_size.x = 24
		$"搜索框/圆角".visible = false
		
		$"工具箱/边角/圆角".visible = false
		$"工具箱/边角/直角".visible = true
		
		$"设置/边角/圆角".visible = false
		$"设置/边角/直角".visible = true
		
		$"关于/边角/圆角".visible = false
		$"关于/边角/直角".visible = true
		
	if $"设置/边角形状/选择".selected == 1: #圆角
		$"标题/边角/直角".rect_size.x = 0
		$"标题/边角/圆角".visible = true
		
		$"标题/缩放".rect_size.x = 0
		$"标题/边角/圆角".visible = true
		
		$"搜索框/切换引擎".rect_size.x = 0
		$"搜索框/前往".rect_size.x = 0
		$"搜索框/圆角".visible = true
		
		$"工具箱/边角/圆角".visible = true
		$"工具箱/边角/直角".visible = false
		
		$"设置/边角/圆角".visible = true
		$"设置/边角/直角".visible = false
		
		$"关于/边角/圆角".visible = true
		$"关于/边角/直角".visible = false

func handoff(): #搜索框
	if handoff == 0:
		_on_translation_pressed()
	else:
		_on_search_pressed()

#工具箱
func tools(): #工具选择
	if $"工具箱/选择".selected == 0: #系统快捷键
		$"工具箱/系统快捷键".visible = true
		$"工具箱/随机学号".visible = false
		$"工具箱/计时器".visible = false
	
	if $"工具箱/选择".selected == 1: #随机序号
		$"工具箱/系统快捷键".visible = false
		$"工具箱/随机学号".visible = true
		$"工具箱/计时器".visible = false
		
	if $"工具箱/选择".selected == 2: #计时器
		$"工具箱/系统快捷键".visible = false
		$"工具箱/随机学号".visible = false
		$"工具箱/计时器".visible = true

func _on_cleanmgr_pressed(): #磁盘清理
	OS.shell_open("Cleanmgr")
func _on_snippingtool_pressed(): #截图工具
	OS.shell_open("SnippingTool")
func _on_calc_pressed(): #计算器
	OS.shell_open("Calc")
func _on_notepad_pressed(): #记事本
	OS.shell_open("Notepad")
func _on_cmd_pressed(): #命令行
	OS.shell_open("cmd")
func _on_regedit_pressed(): #注册表
	OS.shell_open("regedit")

func _on_random_pressed(): #随机序号
	random.randomize()
	$"工具箱/随机学号/显示".text = String(random.randi_range($"设置/人数/下限".value,$"设置/人数/上限".value))

func _on_positive_pressed(): #计时器-开始/暂停
	positive_num += 1
	if positive_num % 2 == 0:
		time_judgement = true
		$"工具箱/计时器".text = "暂停"
		$"工具箱/计时器/归零".disabled = true
	else:
		time_judgement = false
		$"工具箱/计时器".text = "继续"
		$"工具箱/计时器/归零".disabled = false

func _on_zero_pressed(): #归零
	time_judgement = false
	time_minute = 0
	time_second = 0
	time_new = 0
	time_old = 0
	positive_num = 1
	$"工具箱/计时器".text = "开始"
	$"工具箱/计时器/分".text = "00"
	$"工具箱/计时器/秒".text = "00"
	$"工具箱/计时器/归零".disabled = true

func _on_positive_timeout(): #正计时
	if time_judgement == true:
		time_new += 1
		if time_new - time_old == 20: #秒
			time_old = time_new
			time_second += 1
		
		if time_second == 60: #分
			time_minute += 1
			time_second = 0
		
		if time_minute < 10: #分
			$"工具箱/计时器/分".text = "0" + String(time_minute)
		else:
			$"工具箱/计时器/分".text = String(time_minute)
		
		if time_second < 10: #秒
			$"工具箱/计时器/秒".text = "0" + String(time_second)
		else:
			$"工具箱/计时器/秒".text = String(time_second)

func _on_join_pressed():
	pass # Replace with function body.

#关于
func _on_about_pressed(): #关于
	var size_x = 0
	var size_y = 0
	about_num += 1
	if about_num % 2 == 0:
		size_x = 0
		about = true
		if toolbox == true:
			size_y = 125 + 184 + 24
		else:
			size_y = 125 + 24
	else:
		size_x = (250 + 25) * 3
		about = false
		if toolbox == true:
			size_y = 185
		else:
			size_y = 125
	$"关于".rect_position.y = size_y
	$"关于".rect_position.x = size_x

func _on_home_pressed(): #我的主页
	OS.shell_open("https://space.bilibili.com/490604782")

func _on_github_pressed():
	OS.shell_open("https://github.com/ProgrammerMao/DesktopTools/releases")

#搜索框
func _on_translation_pressed(): #搜索
	$"搜索框/切换引擎/搜索".visible = true
	$"搜索框/切换引擎/翻译".visible = false
	$"搜索框/输入".placeholder_text = " 搜索"
	handoff = 0

func _on_search_pressed(): #翻译
	$"搜索框/切换引擎/搜索".visible = false
	$"搜索框/切换引擎/翻译".visible = true
	$"搜索框/输入".placeholder_text = " 翻译"
	handoff = 1

