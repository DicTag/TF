-- 预设数据来自 AutoChat——原作者：华契@电六国色天香  枪戗跄锵强@壮哉我大唯满侠 
 
 
AutoDiag = { 
	IsOn = false,
	SingleOn=false,
	ADTitle="[TF自动对话选择]-",
--	TempStr=nil,
--	Iron=false,
IronHave=nil,
IronCh={
[1]=0,
[2]=1,
[3]=1,
[4]=1,
[5]=2,
[6]=3,
[7]=4,
[8]=4,
[9]=5,
[10]=6,
},

	tDiagCustom={},
	tDiagMulti = {
		"一百五十金这样的小钱，我会在乎么？给我出来！", --天工甲人
		"获取梨园服饰","小钟","竹子","十三根",
		"高山流水",	--苏雨鸾 wh门派
		"剑者，心之道也","剑随心至，便成招","以心为剑，以剑为心",  "天下万物，均可为剑","花鸟鱼石，无不为招","万物相通，万法自然", --梵空禅院的 剑诀
		"程邈，秦",  "汉黄门令史史游", "汲冢书", "后汉左中郎将蔡邕", "古文，黄帝史仓颉所造",	--铁笔划银钩	
		"别怕，马上就能逃离这里了。",
		"运功击裂金蛋宝箱",
		"骗子，你以为这是私服呢！右键点他名字，举报他",
		"ekey.xoyo.com/jx3",	--玲珑阁主 
		"每30秒更换一次动态密码，每个动态密码只能使用一次",
		"立刻冻结帐号，并拨打客服电话",
		"登录金山西山居官方淘宝旗舰店购买（xishanju.taobao.com），等待快递送上门",
		"以上都可","以上都是常见的诈骗方式","以上都是常见的被盗方式","以上三种都可以","以上三种，全部都有",	"以上描述都正确","以上方式都可以",	"以上都可以处理（每3个月只能申请1次）",	--5
		"保护交易，交易时需要输入动态密码",
		"继续答题",
		"塞班（Symbian）版本的手机",
		"叫外卖吃",
		"获得隐元会的委托",
		"交出宝物饶你不死",
		"伤势如何",
		"传送到帮会领地",	-- 无效
		"进入帮会领地",	"离开帮会领地",
		--"多谢",
		"老板娘，给我份活干吧！",
		"多谢大师教诲",
		"小的帮你去问问！",
		"这……小的帮您把话带回去！",
		"这……十两银子也不少了，小的帮你回复白老大去！",
		"白老大息怒喜怒，小的再帮您去问问！",
		"尽管发问",
		"我想用激活码",
		"这……十两银子也不少了，小的帮你回复白老大去！",
		"我确定参加",
		"我也要尽一份绵薄之力，区区30金尚不放在眼里",
		"故人有要事相托，找慧痴大师商榷",
		"从来处来，向去处去",
		"心指所向，意为心故",
		"那我们出发吧",
		"好吧，我们还是回去吧",
		"大总管，我是来献贡的，请看这幅美人图。",
		--美人图
		"送我到后殿货场那里去吧。",		"是的，我确定，请送我过去。",	--贾公 中途失败传送
		"阁下莫非是位高人……",		"……果然是高人！",	--孟庄元
		"哦……这位高僧好饭量……",		"佛爷你是否需要些吃的东西？","烤鸡和烧鹅都来点？","好的，我这就去……",		
		"的确十分可气……","维护军威，自然愿意。",	--裘大嘴
		"一声号令，众人拜服，厉害！","威武雄壮！宫大将军统兵有方！","我对大将军您的景仰有如滔滔江水连绵不绝，又有如黄河泛滥一发不可收拾！",	--宫威 
		"倾国倾城……","我愿意给你画像。","瓜子脸","不画雀斑","婀娜多姿","杨柳细腰","三寸金莲","雪白",				
		"多谢老太爷......","多谢老前辈......",
		"这位将军何故叹息不止？",	--张山石 
	},

}

RegisterCustomData("AutoDiag.IsOn")
RegisterCustomData("AutoDiag.SingleOn") 
RegisterCustomData("AutoDiag.tDiagCustom")
 
local tTargDeny = {	--禁用自动对话的npc
	"九天·逍遥",
	"小二哥",
	"神秘老者",
	"郭语成",
	"西直门吹雪","陆小鸡","萎小宝","炸金花婆婆","丁宇姗","罗万海","甘英琪", --梵空禅院
	
}
local tDiagDeny = {
	"我不干了！我要用身上的碎银换取奖励！",	
	"我想离开此地",	--防止被传出副本。。
	"离开永王行宫",
        "我要进行据点贸易",
        "出售货物",
	"轩辕社有什么委托吗？",
	"了解军阵相关事宜",
	"......厉害，告辞",	"......的确，告辞",	"多谢。",	--美人图子环节完成
	"请送我去见贾公",
	"查看详细规则",
	"我想要了解赛马规则",
	"进入试炼之地",
	"请教我马上轻功",
	"我准备好跟踪梁笑堂了",
	"了解海誓山盟和鹊翎",
	"是的，快送我去主楼与她汇合",
	"请问科举考试的规则如何？",
	"原图忘记了，我要重来",
	"大总管，请再给我一个【乾坤劫道罗盘】吧。",
}
 

function AutoDiag.OpenDialog() 
--arg0 : dwIndex标号
--arg1 : szText文本
--arg2 : dwTargetType目标类型，见枚举型[[TARGET]]				-- 3 npc  4 player...  5 doodad  6 item
--arg3 : dwTargetID目标ID

	local page = Station.Lookup("Normal/DialoguePanel")
	h=page:Lookup("","")
	h:RemoveItem("ADAddEntr")
	
	if not AutoDiag.IsOn then return end

	local tar=GetClientPlayer()
	if arg2==TARGET.NPC then tar=GetNpc(arg3)
	elseif arg2==TARGET.DOODAD then tar=GetDoodad(arg3)
	elseif arg2==TARGET.ITEM then tar=GetItem(arg3)	
	--elseif arg2~=TARGET.PLAYER then Output(arg2,arg3) tar.szName="无目标" --不做处理			--天工甲人、小钟竹子十三根 、离开帮会领地 、九天
	end

	for _,v in pairs(tTargDeny) do
		if tar.szName == v then   
			TF.Debug("拒绝自动对话，请手动选择",AutoDiag.ADTitle) 
			return  
		end 
	end

	dwIndex,szContext = arg0,arg1

	if string.find(szContext,"<T%$") then TF.Debug("拼图拒绝自动选择",AutoDiag.ADTitle)  return end  
	for k,v in pairs(tDiagDeny) do
		if string.find(szContext,v,1) then  TF.Debug("拒绝自动对话，请手动选择",AutoDiag.ADTitle)  return end	 
	end
	
	local AD_nCount=-1
	local ReplaceCont= string.gsub(szContext, "<%$C?",  function () AD_nCount=AD_nCount+1   return AD_nCount   end)
	--TF.Debug(tar.szName..AD_nCount.."\n"..ReplaceCont.."\n"..dwIndex,AutoDiag.ADTitle)

	if tar.szName=="白轩藏画" then
		tQuestList=GetClientPlayer().GetQuestTree()
		for k,v in pairs(tQuestList) do	--k 任务大类
			for j=1,#v do 
				QuestID=GetClientPlayer().GetQuestID(v[j])
				if QuestID==8247 then 		--画之试
					QInfo=GetClientPlayer().GetQuestTraceInfo(QuestID)	
					nNeed=QInfo["quest_state"][1]["need"]	
					nhave=QInfo["quest_state"][1]["have"]			 
					if nNeed==7 and AD_nCount==6  and nhave<7 then  
						GetClientPlayer().WindowSelect(dwIndex,nhave)	
						local szTTT= string.match(ReplaceCont,nhave.." (.-)>")	
						TF.Sysmsg("遍历："..tostring(nhave+1)..szTTT,AutoDiag.ADTitle)
						return
					end
				end	
			end
		end
	end	
 
	if tar.szName=="铸剑台" then
		nID=AutoDiag.IronCh[AutoDiag.IronHave]
		GetClientPlayer().WindowSelect(dwIndex,nID) 
	end
	
	if AD_nCount==0 then		--单选项
		if AutoDiag.SingleOn then
			TF.Debug("单项选择",AutoDiag.ADTitle)
			GetClientPlayer().WindowSelect(dwIndex,0)
		end
	elseif AD_nCount>0  then	 	--多选 <$C  或 -1 无选项 
		for _,v in pairs(AutoDiag.tDiagMulti) do	--预设多选
			local id=string.match(ReplaceCont,"(%d+) "..v)	
			if id then 
				local nID=tonumber(id)  	TF.Debug("多选："..v,AutoDiag.ADTitle)
				GetClientPlayer().WindowSelect(dwIndex,nID)	--aInfo[i].attribute.id 这样的话两个for循环- - 
				return    
			end 
		end
		for _,v in pairs(AutoDiag.tDiagCustom) do	--custom...
			local id=string.match(ReplaceCont,"(%d+) "..v)	
			if id then 
				local nID=tonumber(id)  	TF.Debug("多选："..v,AutoDiag.ADTitle)
				GetClientPlayer().WindowSelect(dwIndex,nID)	 
				return   
			end 
		end
		--无预设：添加选项
 		ui = TF.UI(page)
		ui:Append("Text", "ADAddEntr",{ txt = "增加自动对话选项", x =260, y = 35, font = 187 }):Click(function() AutoDiag.AddNewDiag(AD_nCount,ReplaceCont) end):ASize()	
	--else TF.Debug("无选项",AutoDiag.ADTitle)  --count=-1
	end
end

function AutoDiag.AddNewDiag(AD_nCount,ReplaceCont)
	AutoDiag._ShowRes()
	local fr=Station.Lookup("Normal/AddPreDiag")
	local ui = TF.UI(fr)
	ui:Append("Text", {txt="增加自动对话选项",x=40,y=5, font=205})
	local nEnd,nY=1,42
	for i=0,AD_nCount do
		szTxt=string.match(ReplaceCont,"%d+ (.-)>",nEnd)
		_,nEnd=string.find(ReplaceCont,"%d+ .->",nEnd)
		_,nY=ui:Append("Text",szTxt,  { txt =szTxt , x = 40, y = nY , }):Click(function() table.insert(AutoDiag.tDiagCustom,this:GetName()) TF.Sysmsg("增加自动对话选项： "..this:GetName(),AutoDiag.ADTitle) end):ASize():Pos_()
		nY=nY+10
	end
	ui:Append("Text",  { txt = "移除预设选项", x = 40, y = nY+20 ,font=205 }):Click(AutoDiag.RemoveData):ASize()
	_,nY=ui:Append("Text", { txt = "关闭", x =200, y = nY+20, font = 205 }):Click(function() 				 
	Station.Lookup("Normal/AddPreDiag"):Destroy()
	end):ASize():Pos_()
	fr:Lookup("","Image_SideMId"):SetSize(420,nY+15)
	fr:SetSize(420,nY+15)
	fr:SetDragArea(0,0,420,nY+15)
end

function AutoDiag.RemoveData()
	AutoDiag._ShowRes()
	local fr=Station.Lookup("Normal/AddPreDiag")
	local  ui = TF.UI(fr)
	ui:Append("Text", {txt="按住Ctrl选择某一项可删除，误删不能恢复!",x=5,y=5, font=205})
	local nX,nY=12,36
	for i=1,#AutoDiag.tDiagCustom do
		_,nY=ui:Append("Text", "Pos"..i, { txt =AutoDiag.tDiagCustom[i] , x = nX, y = nY , }):Click(function()	
			if not IsCtrlKeyDown() then return end
			nPos=tostring(string.match(this:GetName(),"Pos(%d+)"))
			table.remove(AutoDiag.tDiagCustom,nPos) 
			AutoDiag.RemoveData()
			end):ASize():Pos_()
		nY=nY+4
		end
	_,nY=ui:Append("Text", { txt = "关闭", x =200, y = nY+15, font = 205 }):Click(function() 				 
	Station.Lookup("Normal/AddPreDiag"):Destroy()
	end):ASize():Pos_()
	fr:Lookup("","Image_SideMId"):SetSize(420,nY+15)
	fr:SetSize(420,nY+15)
	fr:SetDragArea(0,0,420,nY+15)
end
 
 
function AutoDiag.SthHp()
-- if arg1==QUEST_EVENT_TYPE.SET_QUEST_VALUE then end
	AutoDiag.IronHave=arg3
end

TF.RegisterEvent("QUEST_DATA_UPDATE", AutoDiag.SthHp)

function AutoDiag.Switch()
	if AutoDiag.IsOn then
		AutoDiag.IsOn = false
		TF.Sysmsg("关闭",AutoDiag.ADTitle)
	else
		AutoDiag.IsOn = true
		TF.Sysmsg("开启",AutoDiag.ADTitle)
	end
end

function AutoDiag._ShowRes()
	local frame = Station.Lookup("Normal/AddPreDiag")
	if frame then
		frame:Destroy()
	end
		frame = Wnd.OpenWindow("Interface\\TF\\AutoDiag\\AddPreDiag.ini","AddPreDiag")
		frame:Show() 
		frame:EnableDrag(1)
		frame:SetDragArea(0,0,420,300)
end
 
AddPreDiag={}
AddPreDiag.OnFrameKeyDown= function()
	if GetKeyName(Station.GetMessageKey()) == "Esc" then
		Station.Lookup("Normal/AddPreDiag"):Destroy()
		return 1
	end
	return 0
end



RegisterEvent("OPEN_WINDOW",AutoDiag.OpenDialog)

 TF.AppendPlayerMenu(function()
	return {
		szOption ="开启自动对话", bCheck = true,
		bChecked = AutoDiag.IsOn,  
		fnAction = function()  AutoDiag.IsOn = not AutoDiag.IsOn end,
		}		
end) 
 
TF.AppendPlayerMenu( { bDevide = true }) 

TF.AddHotKey("AutoDiag", "自动对话开关",  AutoDiag.Switch)
 
-------------------------------------
-- 设置界面
-------------------------------------
_AutoDiag={}
_AutoDiag.PS = {}

-- init
_AutoDiag.PS.OnPanelActive = function(frame)
	local ui = TF.UI(frame)
	-- feature
	_,nY=ui:Append("Text",  { txt = "【功能说明】", x = 0, y = 5 , }):Pos_()
	_,nY=ui:Append("Text", { x = 5, y = nY+12, w = 500, h = 40, multi = true }):Align(0, 0):Text("1.单项则自动选择；2.预设的常用多项自动选择"):Pos_()
	nX,_=ui:Append("WndCheckBox", "Check_bAutoDiag",{ txt ="自动对话总开关", x = 5, y = nY+20, checked = AutoDiag.IsOn}):Click(function(bChecked) AutoDiag.IsOn = bChecked  ui:Fetch("Check_bAutoSing"):Enable(bChecked)  end):Pos_()  
	_,nY=ui:Append("WndButton", "Button_SetADHotK", { txt = "设置快捷键", x = nX, y = nY+20 , font = 185, }):Size(120, 28):Click(function() HotkeyPanel_Open("【体服专用插件集】") end):Pos_()
	_,nY=ui:Append("WndCheckBox", "Check_bAutoSing",{ txt ="1、单项则自动选择（以下情况请手动关闭 ", x = 5, y = nY+12, checked = AutoDiag.SingleOn}):Click(function(bChecked) AutoDiag.SingleOn = bChecked  end):Pos_()
	_,nY=ui:Append("Text", { x = 15, y = nY+10, w = 500, h = 40, multi = true }):Align(0, 0):Text("		需要看任务剧情时；有些NPC的单项对话会引起麻烦(如传送/对话中断/死循环/无法交接任务等"):Pos_()	
	nX,_=ui:Append("Text",  { txt = "2、常用多项：", x = 30, y = nY+30 , }):Pos_()
	_,nY=ui:Append("WndButton", "Button_SetADHotK", { txt = "移除预设选项", x = nX, y = nY+30 , font = 185, }):Size(130, 28):Click(AutoDiag.RemoveData):Pos_()
	_,nY=ui:Append("Text", { x = 15, y = nY+10, w = 500, h = 40, multi = true }):Align(0, 0):Text("		如需新增预设选项，在遇到无预设的多选项对话时，在对话页面右上角会有[增加自动对话选项]点击后选择需要保存的条目即可"):Pos_()	
--	ui:Append("Text", { txt =  "By 微雨凭阑" , x = 340, y =340, font = 205 })
end
 
	
---------------------------------------------------------------------
-- 注册事件、初始化
---------------------------------------------------------------------
-- add to TF panel
TF.RegisterPanel("自动对话选择", 2586, "自动工具", _AutoDiag.PS)	 