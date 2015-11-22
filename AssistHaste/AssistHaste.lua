AssistHaste={
	LastGrade=5,
	bFrameOpened=false,
	tPre={
		["1.5G"]={0,1.5,1},
		["MJYP"]={52,1,1},
		["QCTJ"]={60,1.5,1},
		["BXXZ"]={50,2.4375,3},
		["BXYS"]={50,3,3},
		["NXHX"]={0,3,3},
		["NXLL"]={0,2.5,5},
		["HJYM"]={50,1.5,1},
		["HJKX"]={50,5,5},
		["QGKX"]={50,3.125,5},		
		["NHJZ"]={0,1.25,1},
		["NHCZ"]={0,3,1},
		["QLCZ"]={0,2.75,1},
		["NHTZ"]={0,2,1},
		["JZTZ"]={0,1.75,1},
		["NDZW"]={0,5,5},
		["NJZW"]={0,4.8125,7},
		["TLJD"]={0,1.5,1},	
		["TMBY"]={0,2.5,5},
		["JYDP"]={0,1.5,1},
		["CJYF"]={51,1.5,1},	
		["CJXZ"]={51,1.25,1},		
		["CGZ"]={51,3,3},
		["ZCZ"]={51,3,6},
		["CGG"]={51,1.5,1},	 
		["GYG"]={51,3,1},			
	},
}
 
  
function AssistHaste.SetPre(which)
	local ui=TF.UI(Station.Lookup("Normal/AssistHaste"))
	ui:Fetch("Edit_ExA"):Text(AssistHaste.tPre[which][1])
	ui:Fetch("Edit_DutiaoS"):Text(AssistHaste.tPre[which][2])
	ui:Fetch("Edit_Hip"):Text(AssistHaste.tPre[which][3])
	AssistHaste.CalRes(unpack(AssistHaste.tPre[which]))
end

function AssistHaste.SetPreEx(ex)
	local ui=TF.UI(Station.Lookup("Normal/AssistHaste"))
	ui:Fetch("Edit_ExA"):Text(ex)
	AssistHaste.CalRes(ex)
end

AssistHaste.OnFrameKeyDown = function()
	if GetKeyName(Station.GetMessageKey()) == "Esc" then
		AssistHaste._OpenWindow()
		return 1
	end
	return 0
end

function AssistHaste.OnMouseLeave()
	local szName = this:GetName()
	local szType = this:GetType()
	HideTip()
end

function AssistHaste.OnLButtonClick()
	local szName = this:GetName()
	local frame = Station.Lookup("Normal/AssistHaste")
	if szName == "Button_Close" then
		if not frame then	return	end
		frame:Hide() 
		AssistHaste.bFrameOpened = false	
	end
end
  
function AssistHaste.EditChange(szName,szText)
	local  ui = TF.UI(Station.Lookup("Normal/AssistHaste"))
	if szName=="Edit_DutiaoS" then 
		dutiao =szText
		dutiao = tonumber(dutiao)	
		if dutiao and dutiao>10 then dutiao=10 ui:Fetch("Edit_DutiaoS"):Text(10) end
	elseif  szName=="Edit_Hip" then 
		hip = szText
		hip = tonumber(hip)
		if hip==0 then hip=1 ui:Fetch("Edit_Hip"):Text(1)   end	--防除0
		if hip and hip>10 then hip=10  ui:Fetch("Edit_Hip"):Text(10)  end	
	elseif szName=="Edit_ExA" then 
		ExA = szText
		ExA = tonumber(ExA)	
		if ExA and ExA>255 then ExA=255  ui:Fetch("Edit_ExA"):Text(255)  end		
	end
	if not dutiao and not hip and not ExA then return end
	AssistHaste.CalRes(ExA,dutiao,hip)
end
 
function AssistHaste.OnFrameCreate()

	local  ui = TF.UI(Station.Lookup("Normal/AssistHaste"))
	nX,nY=ui:Append("Text", { txt = "加速阈值查询", x = 320, y = 20, font = 203 }):Pos_()	
	nX,nY=ui:Append("Text", { txt = "时间/间隔", x = 35, y = 59,  font = 185}):Pos_()
	nX,_=ui:Append("WndEdit", "Edit_DutiaoS", { x = 120, y = 59,  limit = 7, w = 50, h = 28 }):Change(function(szText) AssistHaste.EditChange("Edit_DutiaoS",szText) end)
	:Text("1.5"):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "跳数 ", x = 210, y = 59, font = 185 }):Pos_()	
	nX,_=ui:Append("WndEdit", "Edit_Hip", { x = 255, y = 59,  limit = 2, w = 50, h = 28 }):Change(function(szText) AssistHaste.EditChange("Edit_Hip",szText) end)
	:Text("1"):ASize():Pos_()	
	nX,nY=ui:Append("Text", { txt = "额外加速率", x = 35, y = 109, font = 185 }):Pos_()	
	nX,_=ui:Append("WndEdit", "Edit_ExA", { x = 120, y = 109,  limit = 3, w = 50, h = 28 }):Change(function(szText) AssistHaste.EditChange("Edit_ExA",szText) end)
	:Text("0"):ASize():Pos_()

	nX,nY=ui:Append("Text", { txt = "新妆玳弦 2.4375s 3跳；纳精醉舞 4.8125s 7跳；", x = 355, y = 49,}):Pos_()	
	nX,nY=ui:Append("Text", { txt = "青歌快雪 3.125s 5跳", x = 355, y = 74,}):Pos_()		
	nX,nY=ui:Append("Text", { txt = "无加速", x = 220, y = 105, }):Click(function()  AssistHaste.SetPreEx(0) end):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "1%×5  枕上 梦歌 蚕心 ", x = nX+18, y = 105, }):Click(function()  AssistHaste.SetPreEx(50) end):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "2%×3  太极", x = nX+20, y = 105, }):Click(function()  AssistHaste.SetPreEx(60) end):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "2%×5  妙镜", x = nX+20, y = 105, }):Click(function()  AssistHaste.SetPreEx(105) end):ASize():Pos_()	
	nX,nY=ui:Append("Text", { txt = "5% 如风 沁心 凝绝 碎冰", x = 220, y = 130, }):Click(function()  AssistHaste.SetPreEx(51) end):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "5% 红尘", x = nX+20, y = 130, }):Click(function()  AssistHaste.SetPreEx(52) end):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "10% 毒手", x =nX+20, y = 130, }):Click(function()  AssistHaste.SetPreEx(102) end):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "20% 聚精凝神", x =nX+20, y = 130, }):Click(function()  AssistHaste.SetPreEx(204) end):ASize():Pos_()	
------------------------------------------------------------------------------------------------
--冰心枕上50/万花梦歌50/奶毒蚕心 五七万50；如风51/沁心凝绝51/唐门聚精凝神204
--5%  面版为4.98%，实际为51点，cj如风51/cg沁心凝绝51  --田螺连弩急骤  改成加破防了
--1%×5层 实际面版显示0.98%～4.88%加速率，0.98*10.24=10.0352，4.88*10.24=49.9712，实际上是先有整数的加速率值算近似的加速率， 一层10点额外加速率值，五层50点。 10*5
--明教红尘月破描述为5%，面版为5.08%加速率。实际为52点额外加速率值。
--毒经毒手蝎心描述为10%，面版为9.96%加速率。实际为102点额外加速率值。
--惊羽穷尽九泉浮光掠影，29.98%，307点额外加速率值，已经超过上限了。改成追命读条减半1.5s
--唐门聚精凝神心无旁骛，都是20.02%加速率，实际为205点额外加速率值。--鲸鱼9流风吹雪闪避，已经找不到了
--实测95版本。。19.92% 应该是204。。。
--气纯太极无极，描述2%，面板1.95%，三层5.86%。实际为一层20点，三层60点额外加速率。 20*3
------------------------------------------------------------------------------------------------
	nY=185	
	nX, _ =ui:Append("Text", { txt = "时间", x = 64, y = nY, font = 185 }):Pos_()
	nX, _ =ui:Append("Text", { txt = "加速率", x = 146, y = nY, font = 185 }):Pos_()
	nX, _ =ui:Append("Text", { txt = "加速等级", x = 250, y = nY, font = 185 }):Pos_()	
	nX, _ =ui:Append("Text", { txt = "预    设", x = 520, y = nY, font = 185 }):Hover(function() str = "默认满读条秘籍"  TF.ShowTip(str) end):ASize():Pos_()	
	nX,nY=ui:Append("Text", { txt = "1.5sGCD、彼针、冰蚕、蝎心、...", x = 380, y = nY+35, }):Click(function()  AssistHaste.SetPre("1.5G") end):ASize():Pos_()
	nY=nY+15
	nX, _ =ui:Append("Text", { txt = "红尘月破", x = 380, y = nY, }):Click(function()  AssistHaste.SetPre("MJYP") end):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "气纯太极", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("QCTJ") end):ASize():Pos_()	
	nY=nY+15
	nX, _ =ui:Append("Text", { txt = "枕上新妆", x = 380, y =nY, }):Click(function()  AssistHaste.SetPre("BXXZ") end):ASize():Pos_()
	nX, _ =ui:Append("Text", { txt = "枕上玉素", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("BXYS") end):ASize():Pos_()	
	nX, _ =ui:Append("Text", { txt = "奶秀回雪", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("NXHX") end):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "奶秀玲珑", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("NXLL") end):ASize():Pos_()	
	nY=nY+15
	nX, _ =ui:Append("Text", { txt = "梦歌阳明",  x = 380, y =nY, }):Click(function()  AssistHaste.SetPre("HJYM") end):ASize():Pos_()	
	nX, _ =ui:Append("Text", { txt = "梦歌快雪",  x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("HJKX") end):ASize():Pos_()
	nX, _ =ui:Append("Text", { txt = "青歌快雪",  x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("QGKX") end,"有梦歌"):ASize():Pos_()	
	nX,nY=ui:Append("Text", { txt = "奶花局针",  x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("NHJZ") end):ASize():Pos_()	
	nY=nY+15
	nX, _ =ui:Append("Text", { txt = "奶花长针",  x = 380, y = nY, }):Click(function()  AssistHaste.SetPre("NHCZ") end):ASize():Pos_()
	nX, _ =ui:Append("Text", { txt = "青律长针",  x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("QLCZ") end):ASize():Pos_()
	nX, _ =ui:Append("Text", { txt = "奶花提针",  x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("NHTZ") end):ASize():Pos_()	
	nX,nY=ui:Append("Text", { txt = "竭沢提针",  x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("JZTZ") end):ASize():Pos_()		
	nY=nY+15
	nX, _ =ui:Append("Text", { txt = "奶毒醉舞", x = 380, y = nY, }):Click(function()  AssistHaste.SetPre("NDZW") end):ASize():Pos_()
	nX,nY=ui:Append("Text", { txt = "纳精醉舞", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("NJZW") end):ASize():Pos_()
	nY=nY+15
 	nX, _ =ui:Append("Text", { txt = "唐门暴雨", x = 380, y = nY, }):Click(function()  AssistHaste.SetPre("TMBY") end):ASize():Pos_()
	nX, _ =ui:Append("Text", { txt = "惊羽夺魄", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("JYDP") end):ASize():Pos_()
	nX, nY =ui:Append("Text", { txt ="天罗蚀肌", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("TLJD") end):ASize():Pos_()	
	nY=nY+15
 	nX, _ =ui:Append("Text", { txt = "如风云飞", x = 380, y = nY, }):Click(function()  AssistHaste.SetPre("CJYF") end):ASize():Pos_()
	nX, nY =ui:Append("Text", { txt = "如风夕照", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("CJXZ") end):ASize():Pos_()
	nY=nY+15
 	nX, _ =ui:Append("Text", { txt = "长歌：徵", x = 380, y = nY, }):Click(function()  AssistHaste.SetPre("CGZ") end,"有沁心/凝绝"):ASize():Pos_()
	nX, _ =ui:Append("Text", { txt = "争簇：徵", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("ZCZ") end,"有沁心/凝绝"):ASize():Pos_()	
 	nX, _ =ui:Append("Text", { txt = "长歌：宫", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("CGG") end,"有沁心/凝绝"):ASize():Pos_()
	nX, nY =ui:Append("Text", { txt = "广雅：宫", x = nX+25, y = nY, }):Click(function()  AssistHaste.SetPre("GYG") end,"有沁心"):ASize():Pos_()	
end
  
function AssistHaste._OpenWindow()
	local frame = Station.Lookup("Normal/AssistHaste")
	if frame then
		if frame:IsVisible() then
			frame:Hide() AssistHaste.bFrameOpened = false
		else
			frame:Show() AssistHaste.bFrameOpened = true
		end
	else
		frame = Wnd.OpenWindow("Interface\\TF\\AssistHaste\\AssistHaste.ini","AssistHaste")
		frame:Show() AssistHaste.bFrameOpened = true
	end
end
 
   
 function AssistHaste.CalRes(ExA,dutiao,hip)
	dutiao = tonumber(dutiao) 
	if dutiao == nil then return end
	hip = tonumber(hip) or 1
	ExA=tonumber(ExA) or 0

	local page = Station.Lookup("Normal/AssistHaste/Wnd_ResWnd")
	if page then  
		h=page:Lookup("","")
		for i=1,AssistHaste.LastGrade do
			h:RemoveItem("d"..i)
			h:RemoveItem("ATime"..i)
			h:RemoveItem("RateA"..i)
			h:RemoveItem("RateB"..i)
			h:RemoveItem("NeedA"..i)		
			h:RemoveItem("NeedB"..i)				
		end
	end

	local  ui2 = TF.UI(page)
	local OriFr=dutiao/hip*16
	local MaxFr=math.floor(OriFr/1.249)
	local grade=OriFr-MaxFr
	
	nY=35

	AssistHaste.LastGrade=grade
	for i=1,grade do
		local mid=OriFr/(OriFr-i+1)*1024-1024 
		if mid==math.ceil(mid) then TotA=mid+1 else TotA=math.ceil(mid) end  
		if TotA<ExA then  NeedA=0  else    NeedA=math.ceil((TotA-ExA)*54.782/10.24) end	 
		if TotA<ExA then  NeedB=0  else    NeedB=math.ceil((TotA-ExA)*47.174/10.24) end	--47.174
		local ATime=hip*(OriFr-i)/16
		ATime=string.format("%.2f", ATime) 
	--	if NeedA<10 then NeedA="    "..NeedA  elseif NeedA<1000 then NeedA="  "..NeedA  end
	--	if NeedB<10 then NeedB="    "..NeedB  elseif NeedB<1000 then NeedB="  "..NeedB  end 
		RateA=NeedA/54.782
		szRateA=string.format("%.2f", RateA)
		RateB=NeedB/47.174
		szRateB=string.format("%.2f", RateB)	--.."%"
		nX, _ =ui2:Append("Text","d"..i,{ txt = i , x = 30, y = nY, align = 1 }):ASize():Pos_()
		nX, _ =ui2:Append("Text","ATime"..i, { txt = ATime.."s", x = 65, y = nY, font=101, align = 1 }):ASize():Pos_()
		nX, _ =ui2:Append("Text","RateA"..i, { txt = szRateA, x = 128, y = nY,  font=109, align = 1 }):ASize():Pos_()		
		nX, _ =ui2:Append("Text", "RateB"..i,{ txt = szRateB, x = 187, y = nY, font=101, align = 1 }):ASize():Pos_()			
		nX, _ =ui2:Append("Text", "NeedA"..i,{ txt = NeedA, x = 244, y = nY, font=109, align = 1 }):ASize():Pos_()
		nX, _ =ui2:Append("Text", "NeedB"..i,{ txt = NeedB, x = 296, y = nY, font=101, align = 1 }):ASize():Pos_()
		
		nY=nY+30 
		end
		
	end
 
TF.AppendPlayerMenu(function()
	return {
		szOption ="加速查询助手", bCheck = true,
		bChecked = AssistHaste.bFrameOpened, 
		fnAction = AssistHaste._OpenWindow,
		}
end)
 TF.AppendPlayerMenu( { bDevide = true }) 

 
TF.AddHotKey("AssistHasteQ", "加速阈值查询面板", AssistHaste._OpenWindow)

-------------------------------------
-- 设置界面
-------------------------------------
_AssistHaste={}
_AssistHaste.PS = {}

-- init
_AssistHaste.PS.OnPanelActive = function(frame)
	local ui = TF.UI(frame)
	-- feature
	nX,_=ui:Append("WndButton", "Button_OpAcPanel", { txt = "打开面板", x = 0, y = 5 , }):Size(80, 28):Click(function() AssistHaste._OpenWindow() end):Pos_()
	_,nY=ui:Append("WndButton", "Button_SetAHHotK", { txt = "设置快捷键", x = nX+10, y = 5 , font = 185, }):Size(120, 28):Click(function() HotkeyPanel_Open("【体服专用插件集】") end):Pos_()	
	_,nY=ui:Append("Text", { txt =  "【功能说明】" , x = 0, y = nY+14, }):Pos_()
	_,nY=ui:Append("Text", { txt =  "【1】95年代新加速阈值查询（已预制各职业常用方案" , x = 0, y = nY+12, }):Pos_()
--	ui:Append("Text", { txt =  "By 微雨凭阑" , x = 340, y =340, font = 205 })
end

 
---------------------------------------------------------------------
-- 注册事件、初始化
---------------------------------------------------------------------
-- add to TF panel
TF.RegisterPanel("加速查询助手", 6495, "辅助工具", _AssistHaste.PS)