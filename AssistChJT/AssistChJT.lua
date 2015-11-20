AssistChJT={
	AssistChJTTitle="[TF九天逍遥助手]-",
	bFrameOpened = false,
	clrbagIndex=16,
	pveeqIndex=10,
	IsAddMoney=false,
	AMStep=0,
	_nNpcID=0,
	_nShopID=0,
	_jtID=0,
	IsAssistChJT=false,
	szTempCon=nil,
	szSecCon=nil,
	CloseAfterD=false,
	JTTabType=5,   
	JTIndex=5284,
	PveLv="435",	
	PvpLv="435",
	tPveXF={
		["310破军"]="310",		
		["435定国"]="435",		
		["515秦风"]="515",		
		["555朔雪"]="555",	
		["595霜天"]="595",		
	},	
	tPvpXF={
		["230蚩灵"]="230",		
		["270南皇"]="270",		
		["325破军"]="325",		
		["435定国"]="435",		
		["515秦风"]="515",		
		["555朔雪"]="555",	
		["595霜天"]="595",		
	},
	tFlyChNew={
		["TQL"]="传送到天泣林（限制等级90）",	
		["YSSQ"]="传送到阴山圣泉（限制等级90）",	
		["FKCY"]="传送到梵空禅院（限制等级90）",	
		["YXSX"]="传送到引仙水榭（限制等级90）",	
		["WSSY"]="传送到微山书院（限制等级15）",		
		["TQLh"]="传送到英雄天泣林（限制等级90）",	
		["YSSQh"]="传送到英雄阴山圣泉（限制等级90）",	
		["FKCYh"]="传送到英雄梵空禅院（限制等级90）",	
		["YXSXh"]="传送到英雄引仙水榭（限制等级90）",	
		["WSSYh"]="传送到英雄微山书院（限制等级90）",	
		["PTXL"]="传送到永王行宫·仙侣庭园（限制等级95）",		
		["PTHY"]="传送到永王行宫·花月别院（限制等级95）",		
		["YXXL"]="传送到英雄永王行宫·仙侣庭园（限制等级95）",			
		["YXHY"]="传送到英雄永王行宫·花月别院（限制等级95）",		
		["BHXL"]="传送到帮会永王行宫·仙侣庭园（限制等级95）",		
		["BHHY"]="传送到帮会永王行宫·花月别院（限制等级95）",		
		["C1XL"]="传送到10人挑战永王行宫·仙侣庭园（限制等级95）",	
		["C2XL"]="传送到25人挑战永王行宫·仙侣庭园（限制等级95）",	
		["C1HY"]="传送到10人挑战永王行宫·花月别院（限制等级95）",	
		["C2HY"]="传送到25人挑战永王行宫·花月别院（限制等级95）",			
		["LuoYZL"]="传送到洛阳·战乱（推荐等级80）",	 
		["ChAn"]="传送到长安·战乱（推荐等级85）",						 
		["DXC"]="传送到稻香村(若地图人数已满请多试几次)",					
		["LuoY"]="传送到洛阳",	
		["YaZh"]="传送到扬州",	
		["ChDu"]="传送到成都",					
		["CY"]="传送到纯阳",				
		["WH"]="传送到万花",		
		["TC"]="传送到天策",	 
		["SL"]="传送到少林",
		["QX"]="传送到七秀",			 
		["CJ"]="传送到藏剑",			 	 
		["WD"]="传送到五毒",		
		["GB"]="传送到丐帮",				
		["MJ"]="传送到明教",				
		["TM"]="传送到唐门",				
		["CC"]="传送到苍云",				
		["CGM"]="传送到长歌门",		 	
	},
	tRoleType={"成男","女子","3号体型","4号体型","小男孩","小女孩",},
	tMPCh={
		["TC"]="加入天策并获得技能",
		["CY"]="加入纯阳并获得技能",
		["WH"]="加入万花并获得技能",
		["XX"]="加入七秀并获得技能",
		["SL"]="加入少林并获得技能",
		["CJ"]="加入藏剑并获得技能",
		["WD"]="加入五毒并获得技能",
		["TM"]="加入唐门并获得技能",
		["MJ"]="加入明教并获得技能",
		["GB"]="加入丐帮并获得技能",
		["CC"]="加入苍云并获得技能",
		["CG"]="加入长歌门并获得技能",
	},
	tPVECh = {	--{ 310, 435, 515, 555, 595 }
		["Any"]="",
		["750"]="获取750紫色PVE装备",		
		["850"]="获取850紫色PVE装备",		
		["310"]="获取310品PVE装备",	
		["435"]="获取435品PVE装备",	
		["515"]="获取515品PVE装备（临时表现）",	
		["555"]="获取555紫色PVE装备",	
		["595"]="获取595紫色PVE装备",		
	},
	tPVPCh = {		
		["Any"]="",	
		["850"]="获取850紫色PVP装备",		
		["930"]="获取930紫色PVP装备",		
		["230"]="获取230品PVP装备",		
		["270"]="获取270品PVP装备",		
		["325"]="获取325品PVP装备",		
		["435"]="获取435品PVP装备",				
		["515"]="获取515品PVP装备",		
		["555"]="获取555紫色PVP装备",	
		["595"]="获取595紫色PVP装备",			
	},	
	tYijiMenuCh = {
		["Button_CCHT"]="传送璨翠海厅（限制等级90）",	--放外面了无力吐槽
	--	["Button_28to90"]="我已满28级，我要升到90级",			 
		["Button_HorseBag"]="获得马匹，背包",
		["Button_FuZhu"]="获得辅助物品",
		["Button_FZ90"]="获得90级新增辅助物品",
		["Button_FZ95"]="获得95级新增辅助物品",
		["Button_XYCL"]="获得稀有材料",
		["Button_ColorStone"]="获得五彩石",
		["Button_tMP"]="选择门派并升到90级",			--一会90，一会95，一会又90，有完没完！！
		["Button_tPVE"]="获得门派相应PVE装备",			--二级
		["Button_tPVP"]="获得门派相应PVP装备",			--二级
		["Button_tFly"]="传送去其它地图",			--二级
		["Button_ZYHQ"]="加入浩气盟 ",
		["Button_ZYER"]="加入恶人谷 ",
		["Button_ZYZL"]="加入中立 ",		--没错这里就是有一个神奇欠揍的空格！！！    
		["Button_ClrBag"]="删除所有装备",
		["Button_MPDX"]="重归大侠号",
		["Button_Friend"]="增加好感度",
		["Button_MiJi"]="学习门派对应秘笈",
		["Button_XiuWei"]="获得修为",
		["Button_Money50"]="增加帮会资金到50万",
		["Button_TMJG"]="获取唐门专用子弹",
	},	
	tBtnUnDXC={"Button_MiJi","Button_XYCL","Button_ZYHQ","Button_ZYER","Button_FuZhu","Button_FZ90","Button_FZ95","Button_ColorStone","Button_ClrBag","Button_ZYZL","Button_MPDX","Button_AddMoney"},
	tBtnUnable = {"Button_FlyCGM"},	
	tBtnFemaleUn = {"Button_MPSL","Button_MPCG",},
	tBtnHanziUn = {"Button_MPXX",},
	tBtnBoyUn = {"Button_MPWD","Button_MPTM","Button_MPMJ","Button_MPCG",},	--WD
	tMPBoyEn={"SL","XX","GB","TC","CY","WH","CJ","CC"},	 --CG
	tMPFemaleEn={"TC","CY","WH","XX","CJ","WD","TM","MJ","GB","CC"},	--CG
	tMPHanziEn={"TC","CY","WH","SL","CJ","WD","TM","MJ","GB","CC","CG"},
	--MPFlag=0,
}
AssistChJT.tErJiTable = {  
	["Button_Fly"]={AssistChJT.tYijiMenuCh["Button_tFly"], AssistChJT.tFlyChNew,},	--"传送去其它地图"
	["Button_MP"]={AssistChJT.tYijiMenuCh["Button_tMP"], AssistChJT.tMPCh,}, 	--"选择门派并升到90级",
	["Button_PVE"]={AssistChJT.tYijiMenuCh["Button_tPVE"],AssistChJT.tPVECh,}, 	-- "获得门派相应PVE装备"
	["Button_PVP"]={AssistChJT.tYijiMenuCh["Button_tPVP"], AssistChJT.tPVPCh,},	--"获得门派相应PVP装备"
}
AssistChJT.tRoleBtn = {[2]= AssistChJT.tBtnFemaleUn,[6]= AssistChJT.tBtnFemaleUn,[1]= AssistChJT.tBtnHanziUn,[5]= AssistChJT.tBtnBoyUn,}
AssistChJT.tMPEn = {[2]= AssistChJT.tMPFemaleEn,[6]= AssistChJT.tMPFemaleEn,[1]= AssistChJT.tMPHanziEn,[5]= AssistChJT.tMPBoyEn,}
 

 function AssistChJT.OnMouseEnter()		
	local szName = this:GetName()
	local szType = this:GetType()
	if szName=="Text_MPDX" then 
			local szSce=GetClientPlayer().GetScene().szDisplayName
			if szSce~="稻香村"	then TF.ShowTip("该功能只能在稻香村使用")  
			else
				str = "按住Ctrl，回归大侠。" 
				TF.ShowTip(str,163)
			end
		return 
	end

	if szType == "WndButton" and szName ~="Button_Close" then
--Unable
		if not this:IsEnabled() then
			local szSce=GetClientPlayer().GetScene().szDisplayName
			if szSce~="稻香村"	and szName~="Button_HorseBag" and  szName~="Button_XiuWei"  and szName~="Button_Friend" and  szName~="Button_TMJG"  and  szName~="Button_Money50"  and not string.find(szName,"Button_Set")  and not string.find(szName,"Button_Fly") then TF.ShowTip("该功能只能在稻香村使用") return end			
			if szName=="Button_FlyCGM" then TF.ShowTip("暂未开放，连书院都没了") return end
 
			local player=GetClientPlayer()
			tBtnUn2=AssistChJT.tRoleBtn[player.nRoleType]
			for i = 1, #tBtnUn2 do
				if szName==tBtnUn2[i] then 
					if  szName=="Button_MPCG" or (player.nRoleType==5 and szName=="Button_MPWD") then 
						TF.ShowTip("暂不可通过九天入该门派\n请亲至该门派掌门处入门") 
					else
						TF.ShowTip("该门派暂时不收"..AssistChJT.tRoleType[player.nRoleType]) 
					end
				return 
				end
			end	
			if string.find(szName,"Button_MP") then	TF.ShowTip("请先重归大侠号")   return	end 
			if string.find(szName,"Button_PVE") then TF.ShowTip("请先入门派")   return		end  
			if string.find(szName,"Button_PVP") then TF.ShowTip("请先入门派和阵营")   return	end	 
		end
--Enable		
		if  szName =="Button_AddMoney" then
			TF.ShowTip("打开商人按此键刷金\n将清空背包！\n藏剑丐帮单暗器稍慢")
		end
		yjFlag=0
		for szBtnName,_ in pairs(AssistChJT.tYijiMenuCh) do 	
			if szName == szBtnName then 
				str = AssistChJT.tYijiMenuCh[szBtnName]		--szFirCon
				TF.ShowTip(str,35)	
				if szName == "Button_ClrBag" then str="按住Ctrl，清空背包。" TF.ShowTip(str,163)
				elseif szName == "Button_ZYZL" then str="按住Ctrl，回归中立。"  TF.ShowTip(str,163)
				end
				yjFlag=1
				break
			end
		end
		
		if szName=="Button_PVEAny" then 
			szName="Button_PVE".. AssistChJT.PveLv			
		elseif szName=="Button_PVPAny" then 
			szName="Button_PVP".. AssistChJT.PvpLv
		end
		if yjFlag==0 then 
			for szBtnGrp,_ in pairs(AssistChJT.tErJiTable) do 
				if string.find(szName,szBtnGrp) then		
					t = AssistChJT.tErJiTable[szBtnGrp][2]
					local x1,y1=string.find(szName,szBtnGrp)  
					szEJName = string.sub(szName,y1+1)
					str = t[szEJName]	 				--szSecCon
					TF.ShowTip(str,35)	
					break
				end
			end	
		end
		
	end
end

function AssistChJT.OnMouseLeave()
	local szName = this:GetName()
	local szType = this:GetType()
	HideTip()
end

function AssistChJT.openJT()
	player=GetClientPlayer()
	if player.bOnHorse then	OutputMessage("MSG_ANNOUNCE_RED","骑乘状态不能使用【九天·逍遥】")  return end
	local dwBox, dwX=GetItemPosByItemTypeIndex(AssistChJT.JTTabType,AssistChJT.JTIndex)		
	if not dwBox then OutputMessage("MSG_ANNOUNCE_RED","背包中没有【九天·逍遥】，扔在仓库了吗？")	end
	OnUseItem(dwBox, dwX, GetUIItemBox(dwBox, dwX, true))  
end

  AssistChJT.OnOpenWindow=function()
	if AssistChJT.IsAddMoney then AssistChJT._jtID=arg0 end
	--nIdx=arg0
	if not AssistChJT.IsAssistChJT then return end
	fr=Station.Lookup("Normal/DialoguePanel")  
	if fr and fr:IsVisible() then
	local nType,nID,nIdx,aInfo=fr.dwTargetType, fr.dwTargetId, fr.dwIndex,fr.aInfo
	    if aInfo then
			for i=1,#aInfo,1 do 		
				if aInfo[i].name == "$" and aInfo[i].context==AssistChJT.szTempCon  then    --nFirId=aInfo[i].attribute.id 
					GetClientPlayer().WindowSelect(nIdx,aInfo[i].attribute.id)	
					if not AssistChJT.szSecCon then 
						OutputMessage("MSG_ANNOUNCE_YELLOW", aInfo[i].context.."\n")
						AssistChJT.IsAssistChJT=false
						Station.Lookup("Normal/DialoguePanel"):Hide() 
					end
					break     
				elseif  aInfo[i].name == "$" and  aInfo[i].context==AssistChJT.szSecCon then
					GetClientPlayer().WindowSelect(nIdx,aInfo[i].attribute.id)	
					OutputMessage("MSG_ANNOUNCE_YELLOW", aInfo[i].context.."\n")
					AssistChJT.IsAssistChJT=false 
					AssistChJT.szSecCon=nil
					Station.Lookup("Normal/DialoguePanel"):Hide() 
					if 	AssistChJT.CloseAfterD then	Station.Lookup("Topmost/AssistChJT"):Hide()  AssistChJT.CloseAfterD=false end
				end
			end	
		end
	end
 end
 
 RegisterEvent("OPEN_WINDOW",AssistChJT.OnOpenWindow)
  

function AssistChJT.OnLButtonClick()
	local szName = this:GetName()
	
	if szName=="Text_MPDX" then szName="Button_MPDX" end
	
	local frame = Station.Lookup("Topmost/AssistChJT")
	if szName == "Button_Close" then
		if not frame then	return	end
		frame:Hide()
		AssistChJT.bFrameOpened=false		
		return
	elseif szName=="Button_AddMoney" then 
		if not AssistChJT.IsAddMoney then AssistChJT.MoneyInitial() end 
		AssistChJT.StartRefresh()
		return
	end
 
 	yjFlag = 0				
	if szName == "Button_ClrBag" and not  IsCtrlKeyDown() --[=[and not AssistChJT.IsClrBag]=]then 
		TF.Alert("若确认清空背包，请按住Ctrl，同时按下【清空背包】按钮。", function() end, "Yes")   return
	elseif szName == "Button_ZYZL" and not IsCtrlKeyDown() then 
		TF.Alert("若确认回归中立，请按住Ctrl，同时按下【中 立】按钮。", function() end, "Yes") return 
	elseif szName == "Button_MPDX" and not IsCtrlKeyDown() then 
		TF.Alert("若确认回归大侠，请按住Ctrl，同时按下【大 侠】。", function() end, "Yes")	return 
 	else	
		for szBtnName,_ in pairs(AssistChJT.tYijiMenuCh) do
			if szName == szBtnName then 
				AssistChJT.szTempCon=AssistChJT.tYijiMenuCh[szBtnName]
				AssistChJT.IsAssistChJT=true				
				AssistChJT.openJT()
				yjFlag=1
				break
			end
		end 
	end
 
	if szName=="Button_PVEAny" then 
		szName="Button_PVE".. AssistChJT.PveLv	
	elseif szName=="Button_PVPAny" then 
		szName="Button_PVP".. AssistChJT.PvpLv
	end
	
	if yjFlag==0 then 
		for szBtnGrp,_ in pairs(AssistChJT.tErJiTable) do 
			if string.find(szName,szBtnGrp) then		
				AssistChJT.szTempCon=AssistChJT.tErJiTable[szBtnGrp][1]	
				t = AssistChJT.tErJiTable[szBtnGrp][2]
				if szBtnGrp=="Button_Fly" then AssistChJT.CloseAfterD=true end
				local x1,y1=string.find(szName,szBtnGrp)  
				szEJName = string.sub(szName,y1+1)
				AssistChJT.szSecCon = t[szEJName]	 
				AssistChJT.IsAssistChJT=true
				AssistChJT.openJT()				
				break
			end
		end
	end 
 end
	
 function AssistChJT.BtnUnable(szName)
	local f=Station.Lookup("Topmost/AssistChJT")
	local btn=f:Lookup(szName)
	if btn then btn:Enable(false) end
 end
 
 function AssistChJT.BtnEnable(szName)
	local f=Station.Lookup("Topmost/AssistChJT")
	local btn=f:Lookup(szName)
	if btn then btn:Enable(1) end
 end
 
function AssistChJT.OnFrameCreate()
	local  ui = TF.UI(Station.Lookup("Topmost/AssistChJT"))
	ui:Append("Text", { txt = "九天逍遥助手", x = 315, y = 30, font = 203 })	 
	ui:Append("Text", { txt = "通  用：", x = 27, y = 70, font = 185 })		
	nX,_=ui:Append("WndButton", "Button_HorseBag", { txt = "获取马包", x = 90, y = 70 }):Size(80, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_ClrBag", { txt = "清空背包", x = nX+10, y = 70, font=27 }):Size(80, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_Friend", { txt = "加好感度", x = nX+10, y = 70}):Size(80, 28):Pos_()		
	nY=nY+12
	nX,_=ui:Append("WndButton", "Button_XiuWei", { txt = "获得修为", x = 90, y = nY }):Size(80, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_MiJi", { txt = "学习秘籍", x = nX+10, y = nY}):Size(80, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_TMJG", { txt = "唐门机关", x = nX+10, y = nY}):Size(80, 28):Pos_()			
 	nY=nY+12
	nX,_=ui:Append("WndButton", "Button_ColorStone", { txt = "五彩石", x = 90, y = nY }):Size(80, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_XYCL", { txt = "稀有材料", x = nX+10, y = nY}):Size(80, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_AddMoney", { txt = "自动刷金", x = nX+10, y = nY, font=205 }):Size(80, 28):Pos_()			

	nY=nY+12	
	ui:Append("Text", { txt = "配  装：", x = 27, y = nY, font = 185 }):Pos_()
	nX,_=ui:Append("WndButton", "Button_FuZhu", { txt = "辅 助", x = 90, y = nY }):Size(80, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_FZ90", { txt = "90辅助", x = nX+10, y = nY }):Size(80, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_FZ95", { txt = "95辅助", x = nX+10, y = nY}):Size(80, 28):Pos_()	
	
	nY=nY+12	
	ui:Append("Text", { txt = "阵  营：", x = 27, y = nY, font = 185 }):Pos_()
	nX,_=ui:Append("WndButton", "Button_ZYZL", { txt = "中 立", x = 90, y = nY , font=27 }):Size(80, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_ZYHQ", { txt = "浩气盟", x = nX+10, y = nY }):Size(80, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_ZYER", { txt = "恶人谷", x = nX+10, y = nY}):Size(80, 28):Pos_()	
	
	nY=nY+12		
	nX,_=ui:Append("Text","Text_MPDX", { txt = "[大 侠]", x = 27, y = nY, font = 205 }):Click(function() 
		AssistChJT.OnLButtonClick()
	end):Hover(function() AssistChJT.OnMouseEnter()  end,function() HideTip() end):Pos_()
	nX,_=ui:Append("WndButton", "Button_MPTC", { txt = "天策", x = 90, y = nY }):Size(50, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_MPCY", { txt = "纯阳", x = nX+20, y = nY}):Size(50, 28):Pos_()		
	nX,_=ui:Append("WndButton", "Button_MPWH", { txt = "万花", x = nX+20, y = nY}):Size(50, 28):Pos_()			
	nX,nY=ui:Append("WndButton", "Button_MPWD", { txt = "五毒", x = nX+20, y = nY, }):Size(50, 28):Pos_()
	nY=nY+12	
	nX,_=ui:Append("WndButton", "Button_MPTM", { txt = "唐门", x = 90, y = nY }):Size(50, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_MPMJ", { txt = "明教", x = nX+20, y = nY}):Size(50, 28):Pos_()		
	nX,_=ui:Append("WndButton", "Button_MPGB", { txt = "丐帮", x = nX+20, y = nY}):Size(50, 28):Pos_()			
	nX,nY=ui:Append("WndButton", "Button_MPCJ", { txt = "藏剑", x = nX+20, y = nY, }):Size(50, 28):Pos_()
	nY=nY+12
	nX,_=ui:Append("WndButton", "Button_MPCC", { txt = "苍云", x = 90, y = nY }):Size(50, 28):Pos_()		
	nX,_=ui:Append("WndButton", "Button_MPSL", { txt = "少林", x = nX+20, y = nY }):Size(50, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_MPXX", { txt = "七秀", x = nX+20, y = nY }):Size(50, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_MPCG", { txt = "长歌", x = nX+20, y = nY}):Size(50, 28):Pos_()
	
	nY=nY+12	
	ui:Append("Text", { txt = "PVE装", x = 27, y = nY, font = 185 }):Pos_()
	nX,_=ui:Append("WndButton", "Button_PVE750", { txt = "750", x = 90, y = nY }):Size(50, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_PVE850", { txt = "850", x = nX+20, y = nY }):Size(50, 28):Pos_()	
--[[     nX,_=ui:Append("WndEdit", "Edit_Name", { x = nX+20, y = nY, limit = 3, w = 50, h = 25 } ):Pos_() ]]
	nX,_ = ui:Append("WndComboBox", "Combo_PveLv", { x = nX + 20, y = nY, w = 82, h = 25 })
	:Text("435定国"):Menu(function()
		local m0, tPveLv = {}, { "310破军", "435定国", "515秦风", "555朔雪", "595霜天",}
		for i=1,#tPveLv do
			table.insert(m0, {
				szOption = tPveLv[i],
				fnAction = function()
					szPveLv=AssistChJT.tPveXF[tPveLv[i]]
					ui:Fetch("Combo_PveLv"):Text(tPveLv[i])
					AssistChJT.PveLv=szPveLv
				end
			})
		end
		return m0
	end):Pos_()
	nX,nY=ui:Append("WndButton", "Button_PVEAny", { txt = "PVE", x = nX, y = nY }):Size(40, 28):Pos_()
	
	nY=nY+12	
	ui:Append("Text", { txt = "PVP装", x = 27, y = nY, font = 185 }):Pos_()	
	nX,_=ui:Append("WndButton", "Button_PVP850", { txt = "850", x = 90, y = nY, }):Size(50, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_PVP930", { txt = "930", x = nX+20, y = nY}):Size(50, 28):Pos_()			
	nX,_ = ui:Append("WndComboBox", "Combo_PvpLv", { x = nX + 20, y = nY, w = 82, h = 25 })
	:Text("435定国"):Menu(function()
		local m0, tPvpLv = {}, {"230蚩灵","270南皇","325破军","435定国","515秦风","555朔雪","595霜天",}
		for i=1,#tPvpLv do
			table.insert(m0, {
				szOption = tPvpLv[i],
				fnAction = function()
					szPvpLv=AssistChJT.tPvpXF[tPvpLv[i]]
					ui:Fetch("Combo_PvpLv"):Text(tPvpLv[i])
					AssistChJT.PvpLv=szPvpLv
				end
			})
		end
		return m0
	end):Pos_()
	nX,nY=ui:Append("WndButton", "Button_PVPAny", { txt = "PVP", x = nX, y = nY }):Size(40, 28):Pos_()
	
	nY=nY+12	
	ui:Append("Text", { txt = "帮  会：", x = 27, y = nY, font = 185 }):Pos_()
	nX,_=ui:Append("WndButton", "Button_Money50", { txt = "50万", x = 90, y = nY }):Size(50, 28):Pos_()	
	
	nY=70
	nX,_=ui:Append("Text", { txt = "主 城：", x = 395, y = nY, font = 192 }):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyDXC", { txt = "稻香村", x = 455, y = nY }):Size(75, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_FlyChAn", { txt = "长安*", x = nX+16, y = nY }):Size(75, 28):Pos_()
	nX,nY=ui:Append("WndButton", "Button_CCHT", { txt = "瞿塘峡", x = nX+16, y = nY }):Size(75, 28):Pos_()
	nY=nY+12
	nX,_=ui:Append("WndButton", "Button_FlyChDu", { txt = "成都", x = 455, y = nY }):Size(75, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyYaZh", { txt = "扬州", x = nX+16, y = nY }):Size(75, 28):Pos_()	
	nX, nY =ui:Append("WndButton", "Button_FlyLuoY", { txt = "洛阳", x = nX+16, y = nY }):Size(75, 28):Pos_()
	
--[[ 	
	nY=nY+12
	nY=nY+18
	nX,_=ui:Append("WndButton", "Button_FlyTQL", { txt = "天泣", x = 400, y = nY }):Size(56, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_FlyYSSQ", { txt = "圣泉", x = nX+10, y = nY }):Size(56, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyFKCY", { txt = "禅院", x = nX+10, y = nY}):Size(56, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyYXSX", { txt = "水榭", x = nX+10 , y = nY}):Size(56, 28):Pos_()
	nX,nY=ui:Append("WndButton", "Button_FlyWSSY", { txt = "书院", x = nX+10, y = nY}):Size(56, 28):Pos_()	
	nY=nY+12
	nX,_=ui:Append("WndButton", "Button_FlyTQLh", { txt = "天泣H", x = 400, y = nY }):Size(56, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_FlyYSSQh", { txt = "圣泉H", x = nX+10, y = nY }):Size(56, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyFKCYh", { txt = "禅院H", x = nX+10, y = nY}):Size(56, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyYXSXh", { txt = "水榭H", x = nX+10, y = nY}):Size(56, 28):Pos_()
	nX,nY=ui:Append("WndButton", "Button_FlyWSSYh", { txt = "书院H", x = nX+10, y = nY}):Size(56, 28):Pos_()	
 ]]
	nY=nY+32
	nX,_=ui:Append("Text", { txt = "团 本：", x = 395, y = nY, font = 192 }):Pos_()
--[[ 	nX,_=ui:Append("WndButton", "Button_FlyPTXL", { txt = "仙侣", x = 400, y = nY }):Size(56, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_FlyBHXL", { txt = "仙侣B", x = nX+10, y = nY }):Size(56, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyYXXL", { txt = "仙侣H", x = nX+10, y = nY}):Size(56, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyC1XL", { txt = "仙侣10挑战", x = nX+10, y = nY }):Size(56, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_FlyC2XL", { txt = "仙侣25挑战", x = nX+10, y = nY}):Size(56, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyPTHY", { txt = "花月", x = 400, y = nY+12}):Size(56, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_FlyBHHY", { txt = "花月B", x = nX+10, y = nY+12}):Size(56, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyYXHY", { txt = "花月H", x = nX+10, y = nY+12}):Size(56, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyC1HY", { txt = "花月10挑战", x = nX+10, y = nY+12}):Size(56, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_FlyC2HY", { txt = "花月25挑战", x = nX+10, y = nY+12}):Size(56, 28):Pos_()	 ]]
	nX,_=ui:Append("WndButton", "Button_FlyC1XL", { txt = "仙侣10挑战", x = 455, y = nY }):Size(120, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_FlyC2XL", { txt = "仙侣25挑战", x = nX+20, y = nY}):Size(120, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyC1HY", { txt = "花月10挑战", x = 455, y = nY+12}):Size(120, 28):Pos_()	
	nX,nY=ui:Append("WndButton", "Button_FlyC2HY", { txt = "花月25挑战", x = nX+20, y = nY+12}):Size(120, 28):Pos_()	
	nY=nY+32
	nX,_=ui:Append("Text", { txt = "门 派：", x = 395, y = nY, font = 192 }):Pos_()
	nX,_=ui:Append("WndButton", "Button_FlyCY", { txt = "纯阳", x = 455, y = nY }):Size(50, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_FlyWH", { txt = "万花", x = nX+20, y = nY }):Size(50, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyTC", { txt = "天策", x = nX+20, y = nY }):Size(50, 28):Pos_()		
	nX,nY=ui:Append("WndButton", "Button_FlySL", { txt = "少林", x = nX+20, y = nY }):Size(50, 28):Pos_()	
	nY=nY+12
	nX,_=ui:Append("WndButton", "Button_FlyQX", { txt = "七秀", x =455, y = nY }):Size(50, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_FlyCJ", { txt = "藏剑", x = nX+20, y = nY }):Size(50, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyWD", { txt = "五毒", x =  nX+20, y = nY }):Size(50, 28):Pos_()		
	nX,nY=ui:Append("WndButton", "Button_FlyTM", { txt = "唐门", x = nX+20, y = nY}):Size(50, 28):Pos_()		
	nY=nY+12
	nX,_=ui:Append("WndButton", "Button_FlyMJ", { txt = "明教", x = 455, y = nY }):Size(50, 28):Pos_()
	nX,_=ui:Append("WndButton", "Button_FlyGB", { txt = "丐帮", x = nX+20, y = nY }):Size(50, 28):Pos_()	
	nX,_=ui:Append("WndButton", "Button_FlyCC", { txt = "苍云", x = nX+20, y = nY }):Size(50, 28):Pos_()		
	nX,nY=ui:Append("WndButton", "Button_FlyCGM", { txt = "长歌", x = nX+20, y = nY}):Size(50, 28):Pos_()	
	nY=nY+30
	nX,_=ui:Append("Text", { txt = "五 小：", x = 395, y = nY, font = 192 }):Pos_()
	nX,nY=ui:Append("Text", { txt = "已死，有事烧纸←_←", x = nX, y = nY, font = 194 }):Pos_()	
 end
--Output(Station.GetMouseOverWindow():GetTreePath())

function AssistChJT.OnFrameBreathe()

 	if GetLogicFrameCount() % 8~= 0  then return end
	if AssistChJT.IsAddMoney then AssistChJT.SellAnQi() end

--Output("呼吸")
	local player = GetClientPlayer()
	if not player then return end
	local Sce=player.GetScene()
	if not Sce then return end
	local szSce=Sce.szDisplayName
	
	if AssistChJT.tBtnUnable then 
		for i = 1, #AssistChJT.tBtnUnable	do	AssistChJT.BtnUnable(AssistChJT.tBtnUnable[i])	end 
	end
--Output("检查地图")	
	if szSce~="稻香村"	then 			
		for i = 1, #AssistChJT.tBtnUnDXC	do	AssistChJT.BtnUnable(AssistChJT.tBtnUnDXC[i])	end 
		for szName,_ in pairs(AssistChJT.tMPCh)	do AssistChJT.BtnUnable("Button_MP"..szName)	end 	
		for szName,_ in pairs(AssistChJT.tPVECh)  do	AssistChJT.BtnUnable("Button_PVE"..szName)	end 	
		for szName,_ in pairs(AssistChJT.tPVPCh)  do	AssistChJT.BtnUnable("Button_PVP"..szName)	end 
	else	 
		for i = 1, #AssistChJT.tBtnUnDXC	do	AssistChJT.BtnEnable(AssistChJT.tBtnUnDXC[i])	end
		local t=AssistChJT.tMPEn[GetClientPlayer().nRoleType]
		for i = 1,#t do	AssistChJT.BtnEnable("Button_MP"..t[i])	end	
		for szName,_ in pairs(AssistChJT.tPVECh)  do	AssistChJT.BtnEnable("Button_PVE"..szName)	end	
		for szName,_ in pairs(AssistChJT.tPVPCh)  do	AssistChJT.BtnEnable("Button_PVP"..szName)	end
		
		--Output("检查门派")		
		if GetClientPlayer().dwForceID~=0	then 	--Output("非大侠：禁门派 有PVE")
			for szMP,_ in pairs(AssistChJT.tMPCh)		do	AssistChJT.BtnUnable("Button_MP"..szMP)	end	
			for szPVE,_ in pairs(AssistChJT.tPVECh)	do	AssistChJT.BtnEnable("Button_PVE"..szPVE)	end			
		else 	--Output("大侠 可入门派 无装备")
			local t=AssistChJT.tMPEn[GetClientPlayer().nRoleType]
			for i = 1,#t do	AssistChJT.BtnEnable("Button_MP"..t[i])	end
			for szPVE,_ in pairs(AssistChJT.tPVECh)	do	AssistChJT.BtnUnable("Button_PVE"..szPVE)	end
			for szPVP,_ in pairs(AssistChJT.tPVPCh)	do	AssistChJT.BtnUnable("Button_PVP"..szPVP)	end
		end
		--Output("检查阵营")		
		if  GetClientPlayer().nCamp==0	then	--Output("中立 无pvp")
			for szPVP,_ in pairs(AssistChJT.tPVPCh)	do	AssistChJT.BtnUnable("Button_PVP"..szPVP)	end
		elseif GetClientPlayer().dwForceID~=0 then 	--Output("阵营非大侠 有pvp")
			for szPVP,_ in pairs(AssistChJT.tPVPCh)	do	AssistChJT.BtnEnable("Button_PVP"..szPVP)	end
		end
	end 

end
  
function AssistChJT._OpenWindow()
	local frame = Station.Lookup("Topmost/AssistChJT")
	if frame then
		if frame:IsVisible() then
			frame:Hide() AssistChJT.bFrameOpened = false
		else
			frame:Show() AssistChJT.bFrameOpened = true
		end
	else
		frame = Wnd.OpenWindow("Interface\\TF\\AssistChJT\\AssistChJT.ini","AssistChJT")
		frame:Show() AssistChJT.bFrameOpened = true
 
		local player=GetClientPlayer()
		tBtnUn2=AssistChJT.tRoleBtn[player.nRoleType]
		for i = 1, #tBtnUn2 do   
			AssistChJT.BtnUnable(tBtnUn2[i])
		end
	end
end
 
 AssistChJT.OnFrameKeyDown = function()
	if GetKeyName(Station.GetMessageKey()) == "Esc" then
		AssistChJT._OpenWindow()
		return 1
	end
	return 0
end
 
 function AssistChJT.OnOpenShop()
	AssistChJT._nNpcID, AssistChJT._nShopID = arg4, arg0
end
 
function AssistChJT.MoneyInitial()
	AssistChJT.openJT() 
	fr=Station.Lookup("Normal/DialoguePanel")  
	if not fr or not fr:IsVisible() then return end 
	local nType,nID,nIdx,aInfo=fr.dwTargetType, fr.dwTargetId, fr.dwIndex,fr.aInfo
	--AssistChJT.clrbagIndex=16
	if 	aInfo[37]["context"]~="删除所有装备" then   -- aInfo[3]["name"]=="G" and 
		for i=1,#aInfo,1 do 	
			if aInfo[i].name == "$" and aInfo[i].context== "删除所有装备"  then   
				AssistChJT.clrbagIndex=aInfo[i].attribute.id  
				break
			end   
		end
	end
	--AssistChJT.pveeqIndex=10
	if	aInfo[25]["context"]~="获得门派相应PVE装备" then
		for i=1,#aInfo,1 do 	
			if aInfo[i].name == "$" and aInfo[i].context== "获得门派相应PVE装备"  then   
				AssistChJT.pveeqIndex=aInfo[i].attribute.id  
				break
			end   
		end
	end		
end

function AssistChJT.StartRefresh()
    local player = GetClientPlayer()
   if not AssistChJT.IsAddMoney then
		TF.Sysmsg("开始刷钱",AssistChJT.AssistChJTTitle)		 
		AssistChJT.IsAddMoney=true
		nDistance=GetCharacterDistance(player.dwID,AssistChJT._nNpcID)/64 
		if nDistance>6 or nDistance<0 then	--非法数据	--or AssistChJT._nShopID==0
			TF.Alert("找商人打开商店一次，再按自动刷金。\n刷金时保证在商人交互距离内(6尺！)", function() end, "Yes")
			AssistChJT.IsAddMoney=false
			TF.Sysmsg("关闭刷钱",AssistChJT.AssistChJTTitle)	
			return
		end
		if AssistChJT._nShopID=="UI_OME_SHOP_RESPOND" then
			TF.Alert("身上0G且开启了自动修装时，勿找【杂货商】！\n请在稻香村找【小吃商】王婆婆\n否则干扰参数无法自动售卖",function() end,"Yes")
			AssistChJT.IsAddMoney=false
			TF.Sysmsg("关闭刷钱",AssistChJT.AssistChJTTitle)	
			return
		end
		AssistChJT.openJT() 
   else
		AssistChJT.IsAddMoney=false
		TF.Sysmsg("关闭刷钱",AssistChJT.AssistChJTTitle)		
   end
end

function AssistChJT.SellAnQi()
   local player = GetClientPlayer()
   	fr=Station.Lookup("Normal/DialoguePanel")  
	if not fr or not fr:IsVisible() then return end 
	local nType,nID,nIdx,aInfo=fr.dwTargetType, fr.dwTargetId, fr.dwIndex,fr.aInfo
	
	nGold=player.GetMoney()["nGold"]
	if nGold>970000 then  
		TF.Alert("金钱上限。自动刷金关闭\n",function() end, "Yes")   --溢出警告！！！  
		TF.Sysmsg("关闭刷钱",AssistChJT.AssistChJTTitle)	
			player.WindowSelect(nIdx, AssistChJT.clrbagIndex)
		AssistChJT.IsAddMoney=false  
	return end
	
	if AssistChJT.AMStep==1 then
		player.WindowSelect(AssistChJT._jtID, AssistChJT.clrbagIndex) 	-- clrbag    
	elseif AssistChJT.AMStep==2 then		
		player.WindowSelect(AssistChJT._jtID, AssistChJT.pveeqIndex) 	 
	elseif  AssistChJT.AMStep==3 or AssistChJT.AMStep==4 then 
		if aInfo[11]["context"]=="获取435品PVE装备" then player.WindowSelect(AssistChJT._jtID, 4)	end 
	elseif AssistChJT.AMStep==5 then 	
	AssistChJT.AMStep=0 
		for i = 1, 5 do
			local dwBox = INVENTORY_INDEX.PACKAGE + i - 1
			local dwSize = player.GetBoxSize(dwBox) - 1
			for dwX = 0, dwSize do
				local item = GetPlayerItem(player, dwBox, dwX)
				local nCount = 1
				if item.nUiId>=55797 and item.nUiId<=55802 then					
					SellItem(AssistChJT._nNpcID, AssistChJT._nShopID, dwBox, dwX, nCount)	--若0G自动修装，ShopID不能正常获取！
				end
			end
			AssistChJT.openJT() 
		end
	end
	AssistChJT.AMStep=AssistChJT.AMStep+1
end

 
RegisterEvent("SHOP_OPENSHOP", AssistChJT.OnOpenShop)
 
 
TF.AppendPlayerMenu(function()
	return {
		szOption ="九天逍遥助手", bCheck = true,
		bChecked = AssistChJT.bFrameOpened, 
		fnAction = AssistChJT._OpenWindow,
		}
end)
 
 

TF.AddHotKey("XYZSOM", "九天逍遥助手面板", AssistChJT._OpenWindow)

-------------------------------------
-- 设置界面
-------------------------------------
_AssistChJT={}
_AssistChJT.PS = {}

-- init
_AssistChJT.PS.OnPanelActive = function(frame)
	local ui = TF.UI(frame)
	-- feature
	nX,_=ui:Append("WndButton", "Button_OpJTPanel", { txt = "打开面板", x = 0, y = 5 , }):Size(80, 28):Click(function() AssistChJT._OpenWindow() end):Pos_()
	_,nY=ui:Append("WndButton", "Button_SetJTHotK", { txt = "设置快捷键", x = nX+10, y = 5 , font = 185, }):Size(120, 28):Click(function() HotkeyPanel_Open("【体服专用插件集】") end):Pos_()	
	_,nY=ui:Append("Text", { txt =  "【功能说明】" , x = 0, y = nY+14, }):Pos_()
	_,nY=ui:Append("Text", { txt =  "【1】快速选择[九天·逍遥]功能，告别滚动条" , x = 0, y = nY+12, }):Pos_()
	_,nY=ui:Append("Text", { txt =  "【2】自动刷金" , x = 0, y = nY+12, }):Pos_()
--	ui:Append("Text", { txt =  "By 微雨凭阑" , x = 340, y =340, font = 205 })
end

 
---------------------------------------------------------------------
-- 注册事件、初始化
---------------------------------------------------------------------
-- add to TF panel
TF.RegisterPanel("九天逍遥助手", 637, "辅助工具", _AssistChJT.PS)