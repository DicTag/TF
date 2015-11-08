JLTL={
JL_On=false,
TL_On=false,
JLCount=0,		
TLCount=0,		
JLIdx=19458,
TLIdx=19459,
JLTitle="[TF自动吃精力]-",
TLTitle="[TF自动吃体力]-",
MsgHorseFlag=0,
MoveFlag=0,
fTimeStamp=0,
}

function JLTL.JLSwitch()
local p=GetClientPlayer()
	JLTL.JL_On= not JLTL.JL_On
	if JLTL.JL_On then
		JLTL.MsgHorseFlag=0	JLTL.MoveFlag=0	
		JLTL.JLCount=(p.nMaxStamina-p.nCurrentStamina)/30
		JLTL.JLCount=math.ceil(JLTL.JLCount)    
		JLTime=JLTL.JLCount*15
		if JLTime>0 then JLTime=JLTime-10 end	
		JLMin=math.floor(JLTime/60)
		JLSec=JLTime%60
		OutputMessage("MSG_SYS",JLTL.JLTitle.."开启\n")
		OutputMessage("MSG_SYS",JLTL.JLTitle.."满精力需"..JLTL.JLCount.."颗【佳·回元餐】,预计用时"..JLMin.."分"..JLSec.."秒（延时会有误差\n")
		OutputMessage("MSG_SYS",JLTL.JLTitle.."请确认不在骑乘状态或战斗状态\n")
	else
		OutputMessage("MSG_SYS",JLTL.JLTitle.."关闭\n")
		p.StopCurrentAction()		
	end
end

function JLTL.TLSwitch()
local p=GetClientPlayer()
	JLTL.TL_On= not JLTL.TL_On
	if JLTL.TL_On then
		JLTL.MsgHorseFlag=0	JLTL.MoveFlag=0	
		JLTL.TLCount=math.ceil((p.nMaxThew-p.nCurrentThew)/32)			
		TLTime=JLTL.TLCount*15
		if TLTime>0 then TLTime=TLTime-10 end	
		TLMin=math.floor(TLTime/60)
		TLSec=TLTime%60
		OutputMessage("MSG_SYS",JLTL.TLTitle.."开启\n")
		OutputMessage("MSG_SYS",JLTL.TLTitle.."满体力需"..JLTL.TLCount.."颗【佳·转神餐】,预计用时"..TLMin.."分"..TLSec.."秒（延时会有误差\n")
		OutputMessage("MSG_SYS",JLTL.TLTitle.."请确认不在骑乘状态或战斗状态\n")
	else
		OutputMessage("MSG_SYS",JLTL.TLTitle.."关闭\n")
		p.StopCurrentAction()		
	end
end


function JLTL.OnFrameBreathe()

if GetLogicFrameCount() < JLTL.fTimeStamp then return end
	if GetLogicFrameCount()%8==0 then

		local player = GetClientPlayer()		
		if JLTL.JL_On then 
			dwIndex=JLTL.JLIdx 
			if player.nMaxStamina == player.nCurrentStamina then  TF.Alert("精力已满 自动吃药关闭", function() end, "Yes")  
			JLTL.JL_On=false return end
		elseif  JLTL.TL_On then 
			dwIndex=JLTL.TLIdx
			if  player.nMaxThew == player.nCurrentThew then  TF.Alert("体力已满 自动吃药关闭", function() end, "Yes")    
			JLTL.TL_On=false return end			
		else return end	
		if player.bOnHorse then			
			if JLTL.MsgHorseFlag==0 then TF.Alert("不能在骑乘状态吃药，下马后自动继续", function() end, "Yes") JLTL.MsgHorseFlag=1 end 
			return	
		else JLTL.MsgHorseFlag=0	--Output("notOnHorse")
		end
		if player.bFightState then end	 
		if player.nMoveState~=MOVE_STATE.ON_STAND and player.nMoveState~=MOVE_STATE.ON_SIT then   
			if JLTL.MoveFlag==0 then TF.Alert("【自动精力体力】请站好或坐下，会自动继续", function() end, "Yes") JLTL.MoveFlag=1 end 
			return	
		else JLTL.MoveFlag=0	 
		end		
		if player.GetOTActionState()~=0 then --[==[JLTL.Error("OTPrepareing")]==] return end		
		JLTL.Eat(dwIndex)

	end
end

function JLTL.Eat(dwIndex)
	--Output("遍历频率")			
	local dwBox, dwX=GetItemPosByItemTypeIndex(5,dwIndex)		
	if not dwBox then 	
		if dwIndex==JLTL.JLIdx then OutputMessage("MSG_ANNOUNCE_RED","没有精力药了，请确认背包中有【佳·回元餐】")
		TF.Alert("自动吃药已关闭\n没有精力药了，请确认背包中有【佳·回元餐】", function() end, "Yes")
		JLTL.JL_On=false
		else OutputMessage("MSG_ANNOUNCE_RED","没有体力药了，请确认背包中有【佳·转神餐】") 			
		TF.Alert("自动吃药已关闭\n没有体力药了，请确认背包中有【佳·转神餐】", function() end, "Yes")
		JLTL.TL_On=false
		end
	else
		player=GetClientPlayer()
		item = player.GetItem(dwBox, dwX)
		local _,NeedCD,_,_=player.GetItemCDProgress(item.dwID)
		if NeedCD==0 then		
			OnUseItem(dwBox,dwX)					
		elseif  NeedCD>90 then     
		JLTL.fTimeStamp=GetLogicFrameCount()+NeedCD

		end
	end
end

 
Wnd.OpenWindow("Interface\\TF\\EatJLTL\\JLTL.ini","JLTL")

TF.AddHotKey("JLSwitch", "自动吃精力开关",  JLTL.JLSwitch)
TF.AddHotKey("TLSwitch", "自动吃体力开关",  JLTL.TLSwitch)
 
-------------------------------------
-- 设置界面
-------------------------------------
_JLTL={}
_JLTL.PS = {}

-- init
_JLTL.PS.OnPanelActive = function(frame)
	local ui = TF.UI(frame)
	nX,nY=ui:Append("Text",  { txt = "【功能说明】自动吃精力体力药", x = 0, y = 5 , }):Pos_()
	nX,nY=ui:Append("Text",  { txt = "【使用注意】不要在骑乘状态，建议刷足药挂机", x = 0, y = nY+15 , }):Pos_()	
	nX,nY=ui:Append("Text",  { txt = "回元餐 / 转神餐，因属性压缩，药量和时间增加", x = 0, y = nY+15 , }):Pos_()	
	ui:Append("WndCheckBox", "CheckBox_JLOn",{ txt ="自动吃精力开启", x = 5, y = nY+20, checked =  JLTL.JL_On}):Click(function(bChecked)  JLTL.JL_On = bChecked  end)
	_,nY=ui:Append("WndCheckBox", "CheckBox_TLOn",{ txt ="自动吃体力开启", x = 210, y = nY+20, checked =  JLTL.TL_On }):Click(function(bChecked)  JLTL.TL_On= bChecked  end):Pos_()
	_,nY=ui:Append("WndButton", "Button_SetJLHotK", { txt = "设置快捷键", x = 25, y = nY+15 , font = 185, }):Size(120, 28):Click(function() HotkeyPanel_Open("【体服专用插件集】") end):Pos_()
--	ui:Append("Text", { txt =  "By 微雨凭阑" , x = 340, y =340, font = 205 })
end
 
	
---------------------------------------------------------------------
-- 注册事件、初始化
---------------------------------------------------------------------
-- add to TF panel
TF.RegisterPanel("自动精力体力", 3721, "自动工具", _JLTL.PS)