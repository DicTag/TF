 --
-- TF插件集、常用函数库、UI 界面组件
--
 
---------------------------------------------------------------------
-- 本地函数和变量
---------------------------------------------------------------------
 local _TF = {
	bFrameOpened=false,
	szTitle="体服专用插件集",
	szShort="[体服插件] ",
	dwVersion= 0x2030100,		--版本号维护
	szBuildDate="20151201",	--更新日期维护
	szIniFile = "Interface\\TF\\0TF_Base\\TF.ini",
	tClass = {"所有功能","辅助工具","自动工具","界面增强","插件信息"},	--All,tTool,Auto,UI,Info
	tItem = { {}, {}, {}, {}, {} },
	tMenu={},
	tMenuTrace = {},
	tHotkey={},
	tDelayCall = {},
	tBreatheCall = {},
	tCustomUpdateCall = {},
	tTempTarget = {},
	nDebug = 1,
	tAnchor={},
	tRequest={},
	aDoodad = {},	
	tEvent = {},	
}	
 
 
-------------------------------------
-- 设置面板开关、初始化
-------------------------------------
 -- open
_TF.OpenPanel = function()
	local frame = Station.Lookup("Normal/TF") or Wnd.OpenWindow(_TF.szIniFile, "TF") 
	frame:Show()
	frame:BringToTop()
	return frame
end

-- close
_TF.ClosePanel = function()
	local frame = Station.Lookup("Normal/TF")
	if frame then 
		frame:Hide()
	end
end
  
-- toggle
_TF.TogglePanel = function()
	if _TF.frame and _TF.frame:IsVisible() then
		_TF.ClosePanel()
	else
		_TF.OpenPanel()
	end
end

-- initlization   
_TF.Init = function()
	local pFrame = Player_GetFrame()
	local hFrame = _TF.OpenPanel("TF")
	-- button	
	local button = pFrame:Lookup("TF_Button")
	if not button then
		button = hFrame:Lookup("Btn_Menu")
		button:SetName("TF_Button")
		button:ChangeRelation(pFrame, true, true)
		button.OnMouseEnter = function()
			local nX, nY = this:GetAbsPos()
			local nW, nH = this:GetSize()
			local szTip = GetFormatText("<" .. _TF.szTitle .. ">\n", 101) .. GetFormatText("单击打开功能设置界面!\n我的ID：  "..UI_GetClientPlayerID(), 106)
			OutputTip(szTip, 400, {nX, nY, nW, nH})
		end
		button.OnLButtonClick =  _TF.TogglePanel
		button.OnRButtonClick =  _TF.TogglePanel
		button:Show()
	end
	--  hide
	hFrame:Hide()
	--热键 快捷键设置
	Hotkey.AddBinding("TF_MenuToggle","主设置界面开关", "【体服专用插件集】",_TF.TogglePanel, nil)
	for _, v in ipairs(_TF.tHotkey) do
		Hotkey.AddBinding(v.szName, v.szTitle, "", v.fnAction, nil)
	end

end  

 
-------------------------------------
-- 杂项本地函数
-------------------------------------
-- handle event
_TF.EventHandler = function(szEvent)
	local tEvent = _TF.tEvent[szEvent]
	if tEvent then
		for k, v in pairs(tEvent) do
			local res, err = pcall(v)
			if not res then
				TF.Debug("EVENT#" .. szEvent .. "." .. k .." ERROR: " .. err)
			end
		end
	end
end


_TF.UpdateAnchor = function(frame)
	local a = _TF.tAnchor
	if not IsEmpty(a) then
		frame:SetPoint(a.s, 0, 0, a.r, a.x, a.y)
	else
		frame:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
	end
end

 -- register conflict checker
_TF.RegisterConflictCheck = function(fnAction)
	_TF.tConflict = _TF.tConflict or {}
	table.insert(_TF.tConflict, fnAction)
end
-------------------------------------
-- 更新设置面板界面
-------------------------------------
-- update scrollbar
_TF.UpdateListScroll = function()
	local handle, scroll = _TF.hList, _TF.hScroll
	local w, h = handle:GetSize()
	local wA, hA = handle:GetAllItemSize()
	local nStep = math.ceil((hA - h) / 10)
	scroll:SetStepCount(nStep)
	if nStep > 0 then
		scroll:Show()
		scroll:GetParent():Lookup("Btn_Up"):Show()
		scroll:GetParent():Lookup("Btn_Down"):Show()
	else
		scroll:Hide()
		scroll:GetParent():Lookup("Btn_Up"):Hide()
		scroll:GetParent():Lookup("Btn_Down"):Hide()
	end
end

-- updae detail content
_TF.UpdateDetail = function(i, data)
	local win = TF.UI.Fetch(_TF.frame, "Wnd_Detail")
	if win then win:Remove() end
	if not data then
		data = {}
		if TF_About then			
			if not i then	-- default
				data.fn = {
					OnPanelActive = TF_About.OnPanelActive,
					GetAuthorInfo = TF_About.GetAuthorInfo,
				}
			elseif TF_About.OnTaboxCheck then	-- switch
				data.fn = {
					OnPanelActive = function(frame) TF_About.OnTaboxCheck(frame, i, _TF.tClass[i]) end,
					GetAuthorInfo = TF_About.GetAuthorInfo
				}
			end
		end
	end
	win = TF.UI.Append(_TF.frame, "WndActionWindow", "Wnd_Detail")
	win:Size(_TF.hContent:GetSize()):Pos(_TF.hContent:GetRelPos())
	if type(data.fn) == "table" then
		local szInfo = ""
		if data.fn.GetAuthorInfo then
			szInfo = "-- by " .. data.fn.GetAuthorInfo() .. " --"
		end
		_TF.hTotal:Lookup("Text_Author"):SetText(szInfo)
		if data.fn.OnPanelActive then
			data.fn.OnPanelActive(win:Raw())
			win.handle:FormatAllItemPos()
		end
		win.fnDestroy = data.fn.OnPanelDeactive
	end
end

-- create menu item
_TF.NewListItem = function(i, data, dwClass)		--扩展自用ui图片  string提供图片路径
	local handle = _TF.hList
	local item = TF.UI.Append(handle, "BoxButton", "Button_" .. i)
	if type(data.dwIcon)=="number" then 
		item:Icon(data.dwIcon):Text(data.szTitle):Click(function()
			_TF.UpdateDetail(dwClass, data)
		end, true, true)
	elseif type(data.dwIcon)=="string" then
		item:File(data.dwIcon):Text(data.szTitle):Click(function()
			_TF.UpdateDetail(dwClass, data)
		end, true, true)
	end
	return item
end

-- update menu list
_TF.UpdateListInfo = function(nIndex)
	local nX, nY = 0, 14
	_TF.hList:Clear()
	_TF.hScroll:ScrollHome()
	_TF.UpdateDetail(nIndex)
	for k, v in ipairs(_TF.tItem[nIndex]) do
		local item = _TF.NewListItem(k, v, nIndex)
		item:Pos(nX, nY)
		nY = nY + 50
	end
	_TF.UpdateListScroll()
end

-- update tab list
_TF.UpdateTabBox = function(frame)
	local nX, nY, first = 25, 52, nil
	for k, v in ipairs(_TF.tClass) do
		if table.getn(_TF.tItem[k]) > 0 then
			local tab = frame:Lookup("TabBox_" .. k)
			if not tab then
				tab = TF.UI.Append(frame, "WndTabBox", "TabBox_" .. k, { group = "Nav" })
			else
				tab = TF.UI.Fetch(tab)
			end
			tab:Text(v):Pos(nX, nY):Click(function(bChecked)
				if bChecked then
					_TF.UpdateListInfo(k)
				end
			end):Check(false)
			if not first then
				first = tab
			end
			local nW, _ = tab:Size()
			nX = nX + math.ceil(nW) + 10
		end
	end
	if first then
		first:Check(true)
	end
end

-------------------------------------
-- 系统 HOOK
-------------------------------------
-- get main menu
_TF.GetPlugMenu = function()
	return {
		szOption = _TF.szTitle,
		fnAction = _TF.TogglePanel,
		bCheck = true,
		bChecked = _TF.frame and _TF.frame:IsVisible(),
		szIcon = 'ui/Image/UICommon/CommonPanel2.UITex',
		nFrame = 105,
		nMouseOverFrame = 106,
		szLayer = "ICON_RIGHT",
		fnClickIcon = _TF.TogglePanel
	}
end
 
 ---------------------------------------------------------------------
-- 全局函数和变量     TF.XXX   
---------------------------------------------------------------------


TF = {
	szTitle = _TF.szTitle,						-- 插件集名称
	szBuildDate = _TF.szBuildDate,		-- 插件更新日期
--	nBuildDate = 0,	-- 整型的更新日期（存入 CustomData）
}
--RegisterCustomData("TF.nBuildDate")
 
TF.GetVersion = function()
	local v = _TF.dwVersion
	local szVersion = string.format("%d.%d.%d", v/0x1000000,
		math.floor(v/0x10000)%0x100, math.floor(v/0x100)%0x100)
	if  v%0x100 ~= 0 then
		szVersion = szVersion .. "b" .. tostring(v%0x100)
	end
	return szVersion, v
end

TF.GetCustomFile = function(szName, szDefault)
	local szPath = "interface\\TFcustom\\" .. szName
	if IsFileExist(szPath) then
		return szPath
	end
	return szDefault
end



TF.AddEnterButton=function(frame,szBtnName,szFile,szBtnTemplate,rpX,rpY,tips,fnClick)		
	if frame and frame:IsVisible() then
		local btn=frame:Lookup(szBtnName)
		if not btn then  
			local fx=Wnd.OpenWindow(szFile,"YL_Temp")	
			if fx then													
				fx:Show()
				fx:BringToTop()	 
				local itm=fx:Lookup(szBtnTemplate)
				if itm then
					itm:ChangeRelation(frame,true,true)  
					itm:SetName(szBtnName)
					itm:SetRelPos(rpX,rpY)				 
					itm.OnMouseLeave=function() HideTip() end
					itm.OnMouseEnter=function() TF.ShowTip(tips) end 	
					itm.OnLButtonClick=function()  fnClick() end				 
					itm.OnLButtonHold=function()  fnClick() end				
				end
			end
			Wnd.CloseWindow(fx)
		end
	end
end

 

 -- (void) TF.AddHotKey(string szName, string szTitle, func fnAction)	-- 增加系统快捷键
TF.AddHotKey = function(szName, szTitle, fnAction)
	if string.sub(szName, 1, 3) ~= "TF_" then
		szName = "TF_" .. szName
	end
	table.insert(_TF.tHotkey, { szName = szName, szTitle = szTitle, fnAction = fnAction })
end

-- (string) TF.GetHotKey(string szName, boolean bBracket, boolean bShort)		-- 取得快捷键名称
TF.GetHotKey = function(szName, bBracket, bShort)
	if string.sub(szName, 1, 3) ~= "TF_" then
		szName = "TF_" .. szName
	end
	local nKey, bShift, bCtrl, bAlt = Hotkey.Get(szName)
	local szKey = GetKeyShow(nKey, bShift, bCtrl, bAlt, bShort == true)
	if szKey ~= "" and bBracket then
		szKey = "(" .. szKey .. ")"
	end
	return szKey
end

function TF.GMOW()
	TF.Sysmsg(Station.GetMouseOverWindow():GetTreePath())
end

function TF.ShowTip(str,fontscheme)		
	local nX, nY = this:GetAbsPos()
	local nW, nH = this:GetSize()
	fontscheme=fontscheme or 185		 --101 默认橙色警告  看不清  换成185暗黄
	if not string.find(str,"font=") then		
		str=GetFormatText(str, fontscheme)
	end	
	OutputTip(str, 400, {nX, nY, nW, nH})
end


--Alert 
TF.Alert = function(szMsg, fnAction1,  szSure , fnAction2, szCancel)
	local nW, nH = Station.GetClientSize()
	local tMsg = {
		x = nW / 2, y = nH / 2, szMessage = szMsg, szName = "_JT_Alert",
		{
			szOption = szSure or g_tStrings.STR_HOTKEY_SURE,
			fnAction = fnAction1,
		},
	}
	if fnAction2 or szCancel then 
		table.insert(tMsg,{
			szOption = szCancel or g_tStrings.STR_HOTKEY_CANCEL,
			fnAction = fnAction2,		
		})
	end
	MessageBox(tMsg)
end 

-- (boolean) TF.IsPanelOpened()			-- 判断设置面板是否已打开
TF.IsPanelOpened = function()
	return _TF.frame and _TF.frame:IsVisible()
end

-- (void) TF.OpenPanel()							-- 打开设置面板
-- (void) TF.OpenPanel(string szTitle)		-- 打开名称为 szTitle 的插件或分组设置界面
TF.OpenPanel = function(szTitle)
	_TF.OpenPanel(szTitle ~= nil)
	if szTitle then
		local nClass, nItem = 0, 0
		for k, v in ipairs(_TF.tItem) do
			if _TF.tClass[k] == szTitle then
				nClass = k
			end
			for kk, vv in ipairs(v) do
				if vv.szTitle == szTitle then
					nClass, nItem = k, kk
					break
				end
			end
			if nClass ~= 0 then
				break
			end
		end
		if nClass ~= 0 then
			TF.UI.Fetch(_TF.frame, "TabBox_" .. nClass):Check(true)
			if nItem ~= 0 then
				TF.UI.Fetch(_TF.hList, "Button_" .. nItem):Click()
			end
		end
	end
end
-- (void) TF.ClosePanel()				--  隐藏设置面板
-- (void) TF.ClosePanel(true)		-- 彻底关闭设置面板窗体
TF.ClosePanel = _TF.ClosePanel

-- (void) TF.TogglePanel()			-- 显示/隐藏设置面板
TF.TogglePanel = _TF.TogglePanel
 
-- 往插件集添加一个插件设置按纽及界面
-- (void) TF.RegisterPanel(string szTitle, number dwIcon, string szClass, table fn)
-- szTitle		-- 插件名称
--	dwIcon		-- 图标 ID
--	szClass		-- 分类名称，设为 nil 代表常用
--	fn {			-- 处理函数
--		OnPanelActive = (void) function(WndWindow frame),		-- 设置面板激活时调用，参数为设置画面的窗体对象
--		OnPanelDeactive = (void) function(WndWindow frame),	-- *可选* 设置面板被切出时调用，参数同上
--		OnConflictCheck = (void) function(),								-- *可选* 插件冲突检测函数（每次上线后调用一次）
--		OnPlayerMenu = (table) function(),									-- *可选* 返回附加的头像菜单
--		GetAuthorInfo = (string) function(),									-- *可选* 返回该插件的作者、版权信息
--	}
TF.RegisterPanel = function(szTitle, dwIcon, szClass, fn)
	-- find class
	local dwClass = nil
	if not szClass then
		dwClass = 1
	else
		for k, v in ipairs(_TF.tClass) do
			if v == szClass then
				dwClass = k
			end
		end
		if not dwClass then
			table.insert(_TF.tClass, szClass)
			dwClass = table.getn(_TF.tClass)
			_TF.tItem[dwClass] = {}
		end
	end
	-- check to update
	for _, v in ipairs(_TF.tItem[dwClass]) do
		if v.szTitle == szTitle then
			v.dwIcon, v.fn, dwClass = dwIcon, fn, nil
			break
		end
	end
	-- create new one
	if dwClass then
		table.insert(_TF.tItem[dwClass], { szTitle = szTitle, dwIcon = dwIcon, fn = fn })
	end
	if _TF.frame then
		_TF.UpdateTabBox(_TF.frame)
	end
	if fn and fn.OnConflictCheck then
		_TF.RegisterConflictCheck(fn.OnConflictCheck)
	end
end

-- (table) TF.GetPanelFunc(szTitle)		-- 获取 Hook 某个插件的初始化函数
TF.GetPanelFunc = function(szTitle)
	for k, v in ipairs(_TF.tItem) do
		for kk, vv in ipairs(v) do
			if vv.szTitle == szTitle then
				return vv.fn
			end
		end
	end
end

-- 登记需要临时设为目标的玩家（在非战斗状态会临时切换目标，以获取目标玩家的内功）
-- (void) TF.RegisterTempTarget(number dwID)
-- dwID		-- 需要关注的玩家 ID
TF.RegisterTempTarget = function(dwID)
	table.insert(_TF.tTempTarget, dwID)
end

-- 登记需要添加到头像菜单的项目
-- (void) TF.AppendPlayerMenu(table menu | func fnMenu)
-- menu 		-- 要添加的的菜单项或返回菜单项的函数
TF.AppendPlayerMenu = function(menu)
	table.insert(_TF.tMenu, menu)
end

-- 登记小板手菜单项目
-- (void) TF.AppendTraceMenu(table menu | func fnMenu)
-- menu 		-- 要添加的的菜单项或返回菜单项的函数
TF.AppendTraceMenu = function(menu)
	table.insert(_TF.tMenuTrace, menu)
end

-- 在聊天栏输出一段黄字（只有当前用户可见）
-- (void) TF.Sysmsg(string szMsg[, string szHead])
-- szMsg		-- 要输出的文字内容
--	szHead		-- 输出前缀，自动加上中括号，默认为：海鳗插件
TF.Sysmsg = function(szMsg, szHead, szType)
	szHead = szHead or _TF.szShort
	szType = szType or "MSG_SYS"
	OutputMessage(szType, szHead.. szMsg .. "\n")  --"[" ..    .. "] " 
end

-- 在聊天栏输出调试信息，和 TF.Sysmsg 类似，多了2个用于区分的符号标记
-- (void) TF.Debug(string szMsg[, string szHead])
-- (void) TF.Debug2(string szMsg[, string szHead])
-- (void) TF.Debug3(string szMsg[, string szHead])
TF.Debug = function(szMsg, szHead, nLevel)
	nLevel = nLevel or 1
	if TF_About and TF_About.bDebug and _TF.nDebug >= nLevel then
		if nLevel == 3 then szMsg = "### " .. szMsg
		elseif nLevel == 2 then szMsg = "=== " .. szMsg
		else szMsg = "-- " .. szMsg end
		TF.Sysmsg(szMsg, szHead)
	end
end
TF.Debug2 = function(szMsg, szHead) TF.Debug(szMsg, szHead, 2) end
TF.Debug3 = function(szMsg, szHead) TF.Debug(szMsg, szHead, 3) end

 
-- 注册呼吸循环调用函数
-- (void) TF.BreatheCall(string szKey, func fnAction[, number nTime])
-- szKey		-- 名称，必须唯一，重复则覆盖
-- fnAction	-- 循环呼吸调用函数，设为 nil 则表示取消这个 key 下的呼吸处理函数
-- nTime		-- 调用间隔，单位：毫秒，默认为 62.5，即每秒调用 16次，其值自动被处理成 62.5 的整倍数
TF.BreatheCall = function(szKey, fnAction, nTime)
	local key = StringLowerW(szKey)
	if type(fnAction) == "function" then
		local nFrame = 1
		if nTime and nTime > 0 then
			nFrame = math.ceil(nTime / 62.5)
		end
		_TF.tBreatheCall[key] = { fnAction = fnAction, nNext = GetLogicFrameCount() + 1, nFrame = nFrame }
	else
		_TF.tBreatheCall[key] = nil
	end
end

-- 改变呼吸调用频率
-- (void) TF.BreatheCallDelay(string szKey, nTime)
-- nTime		-- 延迟时间，每 62.5 延迟一帧
TF.BreatheCallDelay = function(szKey, nTime)
	local t = _TF.tBreatheCall[StringLowerW(szKey)]
	if t then
		t.nFrame = math.ceil(nTime / 62.5)
		t.nNext = GetLogicFrameCount() + t.nFrame
	end
end

-- 延迟一次呼吸函数的调用频率
-- (void) TF.BreatheCallDelayOnce(string szKey, nTime)
-- nTime		-- 延迟时间，每 62.5 延迟一帧
TF.BreatheCallDelayOnce = function(szKey, nTime)
	local t = _TF.tBreatheCall[StringLowerW(szKey)]
	if t then
		t.nNext = GetLogicFrameCount() + math.ceil(nTime / 62.5)
	end
end

-- (void) TF.DelayCall(number nDelay, func fnAction)		-- 延迟调用
-- nTime		-- 延迟调用时间，单位：毫秒，实际调用延迟延迟是 62.5 的整倍数
-- fnAction	-- 调用函数
TF.DelayCall = function(nDelay, fnAction)
	local nTime = nDelay + GetTime()
	table.insert(_TF.tDelayCall, { nTime = nTime, fnAction = fnAction })
end

 
-- (table) TF.GetAllDoodad([number nLimit])		-- 获取场景内的所有 DOODAD
-- nLimit -- 个数上限，默认不限
TF.GetAllDoodad = function(nLimit)
	local aDoodad = {}
	for k, _ in pairs(_TF.aDoodad) do
		local p = GetDoodad(k)
		if not p then
			_TF.aDoodad[k] = nil
		else
			table.insert(aDoodad, p)
			if nLimit and #aDoodad == nLimit then
				break
			end
		end
	end
	return aDoodad
end

-- (table) TF.GetAllDoodadID()			-- 获取场景内的 Doodad ID 列表
TF.GetAllDoodadID = function()
	return _TF.aDoodad
end

-- 计算目标与自身的距离
-- (number) TF.GetDistance(KObject tar)
-- (number) TF.GetDistance(number nX, number nY[, number nZ])
-- tar		-- 带有 nX，nY，nZ 三属性的 table 或 KPlayer，KNpc，KDoodad
-- nX		-- 世界坐标系下的目标点 X 值
-- nY		-- 世界坐标系下的目标点 Y 值
-- nZ		-- *可选* 世界坐标系下的目标点 Z 值
TF.GetDistance = function(nX, nY, nZ)
	local me = GetClientPlayer()
	if not me then
		return 0
	elseif not nY and not nZ then
		local tar = nX
		nX, nY, nZ = tar.nX, tar.nY, tar.nZ
	elseif not nZ then
		return math.floor(((me.nX - nX) ^ 2 + (me.nY - nY) ^ 2) ^ 0.5)/64
	end
	return math.floor(((me.nX - nX) ^ 2 + (me.nY - nY) ^ 2 + (me.nZ/8 - nZ/8) ^ 2) ^ 0.5)/64
end

 -- 追加小地图标记
-- (void) TF.UpdateMiniFlag(number dwType, KObject tar, number nF1[, number nF2])
-- dwType	-- 类型，8 - 红名，5 - Doodad，7 - 功能 NPC，2 - 提示点，1 - 队友，4 - 任务 NPC
-- tar			-- 目标对象 KPlayer，KNpc，KDoodad
-- nF1			-- 图标帧次
-- nF2			-- 箭头帧次，默认 48 就行
TF.UpdateMiniFlag = function(dwType, tar, nF1, nF2)
	local nX, nZ = Scene_PlaneGameWorldPosToScene(tar.nX, tar.nY)
	local m = Station.Lookup("Normal/Minimap/Wnd_Minimap/Minimap_Map")
	if m then
		m:UpdataArrowPoint(dwType, tar.dwID, nF1, nF2 or 48, nX, nZ, 16)
	end
end


-- (table) TF.Split(string szFull, string szSep)		-- 根据 szSep 分割字符串 szFull，不支持表达式
TF.Split = function(szFull, szSep)
	local nOff, tResult = 1, {}
	while true do
		local nEnd = StringFindW(szFull, szSep, nOff)
		if not nEnd then
			table.insert(tResult, string.sub(szFull, nOff, string.len(szFull)))
			break
		else
			table.insert(tResult, string.sub(szFull, nOff, nEnd - 1))
			nOff = nEnd + string.len(szSep)
		end
	end
	return tResult
end

-- (string) TF.Trim(string szText)				-- 清除字符串首尾的空白字符
TF.Trim = function(szText)
	if not szText or szText == "" then
		return ""
	end
	return (string.gsub(szText, "^%s*(.-)%s*$", "%1"))
end

-- 注册事件，和系统的区别在于可以指定一个 KEY 防止多次加载
-- (void) TF.RegisterEvent(string szEvent, func fnAction[, string szKey])
-- szEvent		-- 事件，可在后面加一个点并紧跟一个标识字符串用于防止重复或取消绑定，如 LOADING_END.xxx
-- fnAction		-- 事件处理函数，arg0 ~ arg9，传入 nil 相当于取消该事件
--特别注意：当 fnAction 为 nil 并且 szKey 也为 nil 时会取消所有通过本函数注册的事件处理器
TF.RegisterEvent = function(szEvent, fnAction)
	local szKey = nil
	local nPos = StringFindW(szEvent, ".")
	if nPos then
		szKey = string.sub(szEvent, nPos + 1)
		szEvent = string.sub(szEvent, 1, nPos - 1)
	end
	if not _TF.tEvent[szEvent] then
		_TF.tEvent[szEvent] = {}
		RegisterEvent(szEvent, function() _TF.EventHandler(szEvent) end)
	end
	local tEvent = _TF.tEvent[szEvent]
	if fnAction then
		if not szKey then
			table.insert(tEvent, fnAction)
		else
			tEvent[szKey] = fnAction
		end
	else
		if not szKey then
			_TF.tEvent[szEvent] = {}
		else
			tEvent[szKey] = nil
		end
	end
end

-- 取消事件处理函数
-- (void) TF.UnRegisterEvent(string szEvent)
TF.UnRegisterEvent = function(szEvent)
	TF.RegisterEvent(szEvent, nil)
end

-- 注册用户定义数据，支持全局变量数组遍历
-- (void) TF.RegisterCustomData(string szVarPath)
TF.RegisterCustomData = function(szVarPath)
	if _G and type(_G[szVarPath]) == "table" then
		for k, _ in pairs(_G[szVarPath]) do
			RegisterCustomData(szVarPath .. "." .. k)
		end
	else
		RegisterCustomData(szVarPath)
	end
end

-- Role Custom Data 加载后判断比较 nUpdateDate 然后调用 fnAction
-- (void) TF.RegisterCustomUpdater(func fnAction, number nUpdateDate)
TF.RegisterCustomUpdater = function(fnAction, nUpdateDate)
	table.insert(_TF.tCustomUpdateCall, { nDate = nUpdateDate, fnAction = fnAction })
end

--Entrance/Access
 

 _TF.GetPlayerMenu=function()
  	local m0, n = _TF.GetPlugMenu(), 0
	for _, v in ipairs(_TF.tMenu) do
		if type(v) == "function" then
			table.insert(m0, v())
		else
			table.insert(m0, v)
		end
	end
	return { m0 }
 end
 
 _TF.GetPlugMenu=function()
	return  {	 
		szOption ="体服专用插件集", bCheck = true,
		bChecked = _TF.bFrameOpened,
		fnAction = _TF.TogglePanel,
			{ szOption ="v"..TF.GetVersion(), bDisable = true, },	--.._TF.szBuildDate
			{ bDevide = true }
	}
 end

 --头像menu	
   	Player_AppendAddonMenu({ _TF.GetPlayerMenu })
 --侧扳手
	TraceButton_AppendAddonMenu({ _TF.GetPlayerMenu })
  

---------------------------------------------------------------------
-- 本地的 UI 组件对象
---------------------------------------------------------------------
_TF.UI = {}

-------------------------------------
-- Base object class
-------------------------------------
_TF.UI.Base = class()

-- (userdata) Instance:Raw()		-- 获取原始窗体/组件对象
function _TF.UI.Base:Raw()
	if self.type == "Label" then
		return self.txt
	end
	return self.wnd or self.edit or self.self
end

-- (void) Instance:Remove()		-- 删除组件
function _TF.UI.Base:Remove()
	if self.fnDestroy then
		local wnd = self.wnd or self.self
		self.fnDestroy(wnd)
	end
	local hP = self.self:GetParent()
	if hP.___uis then
		local szName = self.self:GetName()
		hP.___uis[szName] = nil
	end
	if self.type == "WndFrame" then
		Wnd.CloseWindow(self.self)
	elseif string.sub(self.type, 1, 3) == "Wnd" then
		self.self:Destroy()
	else
		hP:RemoveItem(self.self:GetIndex())
	end
end

-- (string) Instance:Name()					-- 取得名称
-- (self) Instance:Name(szName)			-- 设置名称为 szName 并返回自身以支持串接调用
function _TF.UI.Base:Name(szName)
	if not szName then
		return self.self:GetName()
	end
	self.self:SetName(szName)
	return self
end

-- (self) Instance:Toggle([boolean bShow])			-- 显示/隐藏
function _TF.UI.Base:Toggle(bShow)
	if bShow == false or (not bShow and self.self:IsVisible()) then
		self.self:Hide()
	else
		self.self:Show()
		if self.type == "WndFrame" then
			self.self:BringToTop()
		end
	end
	return self.self
end

function _TF.UI.Base:ASize()	--文字自动调整大小
	local hnd = self.self
	local nW, nH = hnd:GetSize()   
	if self.type == "Text" or self.type == "Label" then
		nW, nH = self.txt:GetTextExtent()
	end
	hnd:SetSize(nW, nH)
	return self
end

-- (number, number) Instance:Pos()					-- 取得位置坐标				
-- (self) Instance:Pos(number nX, number nY)	-- 设置位置坐标
function _TF.UI.Base:Pos(nX, nY)
	if not nX then
		return self.self:GetRelPos()
	end
	self.self:SetRelPos(nX, nY)
	if self.type == "WndFrame" then
		self.self:CorrectPos()
	elseif string.sub(self.type, 1, 3) ~= "Wnd" then
		self.self:GetParent():FormatAllItemPos()
	end
	return self
end

-- (number, number) Instance:Pos_()			-- 取得右下角的坐标
function _TF.UI.Base:Pos_()
	local nX, nY = self:Pos()
	local nW, nH = self:Size()
	return nX + nW, nY + nH
end

-- (number, number) Instance:CPos_()			-- 取得最后一个子元素右下角坐标
-- 特别注意：仅对通过 :Append() 追加的元素有效，以便用于动态定位
function _TF.UI.Base:CPos_()
	local hP = self.wnd or self.self
	if not hP.___last and string.sub(hP:GetType(), 1, 3) == "Wnd" then
		hP = hP:Lookup("", "")
	end
	if hP.___last then
		local ui = TF.UI.Fetch(hP, hP.___last)
		if ui then
			return ui:Pos_()
		end
	end
	return 0, 0
end

-- (class) Instance:Append(string szType, ...)	-- 添加 UI 子组件
-- NOTICE：only for Handle，WndXXX
function _TF.UI.Base:Append(szType, ...)
	local hP = self.wnd or self.self
	if string.sub(hP:GetType(), 1, 3) == "Wnd" and string.sub(szType, 1, 3) ~= "Wnd" then
		hP.___last = nil
		hP = hP:Lookup("", "")
	end
	return TF.UI.Append(hP, szType, ...)
end

-- (class) Instance:Fetch(string szName)	-- 根据名称获取 UI 子组件
function _TF.UI.Base:Fetch(szName)
	local hP = self.wnd or self.self
	local ui = TF.UI.Fetch(hP, szName)
	if not ui and self.handle then
		ui = TF.UI.Fetch(self.handle, szName)
	end
	return ui
end

-- (number, number) Instance:Align()
-- (self) Instance:Align(number nHAlign, number nVAlign)
function _TF.UI.Base:Align(nHAlign, nVAlign)
	local txt = self.edit or self.txt
	if txt then
		if not nHAlign and not nVAlign then
			return txt:GetHAlign(), txt:GetVAlign()
		else
			if nHAlign then
				txt:SetHAlign(nHAlign)
			end
			if nVAlign then
				txt:SetVAlign(nVAlign)
			end
		end
	end
	return self
end

-- (number) Instance:Font()
-- (self) Instance:Font(number nFont)
function _TF.UI.Base:Font(nFont)
	local txt = self.edit or self.txt
	if txt then
		if not nFont then
			return txt:GetFontScheme()
		end
		txt:SetFontScheme(nFont)
	end
	return self
end

-- (number, number, number) Instance:Color()
-- (self) Instance:Color(number nRed, number nGreen, number nBlue)
function _TF.UI.Base:Color(nRed, nGreen, nBlue)
	if self.type == "Shadow" then
		if not nRed then
			return self.self:GetColorRGB()
		end
		self.self:SetColorRGB(nRed, nGreen, nBlue)
	else
		local txt = self.edit or self.txt
		if txt then
			if not nRed then
				return txt:GetFontColor()
			end
			txt:SetFontColor(nRed, nGreen, nBlue)
		end
	end
	return self
end

-- (number) Instance:Alpha()
-- (self) Instance:Alpha(number nAlpha)
function _TF.UI.Base:Alpha(nAlpha)
	local txt = self.edit or self.txt or self.self
	if txt then
		if not nAlpha then
			return txt:GetAlpha()
		end
		txt:SetAlpha(nAlpha)
	end
	return self
end

-------------------------------------
-- Dialog frame
-------------------------------------
_TF.UI.Frm = class(_TF.UI.Base)

-- constructor
function _TF.UI.Frm:ctor(szName, bEmpty)
	local frm, szIniFile = nil, "interface\\TF\\0TF_Base\\ui\\WndFrame.ini"
	if bEmpty then
		szIniFile = "interface\\TF\\0TF_Base\\ui\\WndFrameEmpty.ini"
	end
	if type(szName) == "string" then
		frm = Station.Lookup("Normal/" .. szName)
		if frm then
			Wnd.CloseWindow(frm)
		end
		frm = Wnd.OpenWindow(szIniFile, szName)
	else
		frm = Wnd.OpenWindow(szIniFile)
	end
	frm:Show()
	if not bEmpty then
		frm:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
		frm:Lookup("Btn_Close").OnLButtonClick = function()
			if frm.bClose then
				Wnd.CloseWindow(frm)
			else
				frm:Hide()
			end
		end
		self.wnd = frm:Lookup("Window_Main")
		self.handle = self.wnd:Lookup("", "")
	else
		self.handle = frm:Lookup("", "")
	end
	self.self, self.type = frm, "WndFrame"
end

-- (number, number) Instance:Size()						-- 取得窗体宽和高
-- (self) Instance:Size(number nW, number nH)	-- 设置窗体的宽和高
-- 特别注意：窗体最小高度为 200，宽度自动按接近取  234/380/770 中的一个
function _TF.UI.Frm:Size(nW, nH)
	local frm = self.self
	if not nW then
		return frm:GetSize()
	end
	local hnd = frm:Lookup("", "")
	-- empty frame
	if not self.wnd then
		frm:SetSize(nW, nH)
		hnd:SetSize(nW, nH)
		return self
	end
	-- fix size
	if nW > 400 then
		nW = 770
		hnd:Lookup("Image_CBg1"):SetSize(385, 70)
		hnd:Lookup("Image_CBg2"):SetSize(384, 70)
		hnd:Lookup("Image_CBg1"):SetFrame(2)
		hnd:Lookup("Image_CBg2"):SetFrame(2)
	elseif nW > 250 then
		nW = 380
		hnd:Lookup("Image_CBg1"):SetSize(190, 70)
		hnd:Lookup("Image_CBg2"):SetSize(189, 70)
		hnd:Lookup("Image_CBg1"):SetFrame(1)
		hnd:Lookup("Image_CBg2"):SetFrame(1)
	else
		nW = 234
		hnd:Lookup("Image_CBg1"):SetSize(117, 70)
		hnd:Lookup("Image_CBg2"):SetSize(117, 70)
		hnd:Lookup("Image_CBg1"):SetFrame(0)
		hnd:Lookup("Image_CBg2"):SetFrame(0)
	end
	if nH < 200 then nH = 200 end
	-- set size
	frm:SetSize(nW, nH)
	frm:SetDragArea(0, 0, nW, 70)
	hnd:SetSize(nW, nH)
	hnd:Lookup("Image_CBg3"):SetSize(8, nH - 160)
	hnd:Lookup("Image_CBg4"):SetSize(nW - 16, nH - 160)
	hnd:Lookup("Image_CBg5"):SetSize(8, nH - 160)
	hnd:Lookup("Image_CBg7"):SetSize(nW - 132, 85)
	hnd:Lookup("Text_Title"):SetSize(nW - 90, 30)
	hnd:FormatAllItemPos()
	frm:Lookup("Btn_Close"):SetRelPos(nW - 35, 15)
	self.wnd:SetSize(nW - 90, nH - 90)
	self.wnd:Lookup("", ""):SetSize(nW - 90, nH - 90)
	-- reset position
	local an = GetFrameAnchor(frm)
	frm:SetPoint(an.s, 0, 0, an.r, an.x, an.y)
	return self
end

-- (string) Instance:Title()					-- 取得窗体标题
-- (self) Instance:Title(string szTitle)	-- 设置窗体标题
function _TF.UI.Frm:Title(szTitle)
	local ttl = self.self:Lookup("", "Text_Title")
	if not szTitle then
		return ttl:GetText()
	end
	ttl:SetText(szTitle)
	return self
end

-- (boolean) Instance:Drag()						-- 判断窗体是否可拖移
-- (self) Instance:Drag(boolean bEnable)	-- 设置窗体是否可拖移
function _TF.UI.Frm:Drag(bEnable)
	local frm = self.self
	if bEnable == nil then
		return frm:IsDragable()
	end
	frm:EnableDrag(bEnable == true)
	return self
end

-- (string) Instance:Relation()
-- (self) Instance:Relation(string szName)	-- Normal/Lowest ...
function _TF.UI.Frm:Relation(szName)
	local frm = self.self
	if not szName then
		return frm:GetParent():GetName()
	end
	frm:ChangeRelation(szName)
	return self
end

-- (userdata) Instance:Lookup(...)
function _TF.UI.Frm:Lookup(...)
	local wnd = self.wnd or self.self
	return self.wnd:Lookup(...)
end


-------------------------------------
-- Window Component
-------------------------------------
_TF.UI.Wnd = class(_TF.UI.Base)

-- constructor
function _TF.UI.Wnd:ctor(pFrame, szType, szName)
	local wnd = nil
	if not szType and not szName then
		-- convert from raw object
		wnd, szType = pFrame, pFrame:GetType()
	else
		-- append from ini file
		local szFile = "interface\\TF\\0TF_Base\\ui\\" .. szType .. ".ini"
		local frame = Wnd.OpenWindow(szFile, "TF_Virtual")
		if not frame then
			return TF.Sysmsg("Unable to open ini file " .. szFile) --("Unable to open ini file [%s]", szFile)
		end
		wnd = frame:Lookup(szType)
		if not wnd then
			TF.Sysmsg("Can not find wnd component " .. szType) --("Can not find wnd component [%s]", szType)
		else
			wnd:SetName(szName)
			wnd:ChangeRelation(pFrame, true, true)
		end
		Wnd.CloseWindow(frame)
	end
	if wnd then
		self.type = szType
		self.edit = wnd:Lookup("Edit_Default")
		self.handle = wnd:Lookup("", "")
		self.self = wnd
		if self.handle then
			self.txt = self.handle:Lookup("Text_Default")
		end
		if szType == "WndTrackBar" then
			local scroll = wnd:Lookup("Scroll_Track")
			scroll.nMin, scroll.nMax, scroll.szText = 0, scroll:GetStepCount(), self.txt:GetText()
			scroll.nVal = scroll.nMin
			self.txt:SetText(scroll.nVal .. scroll.szText)
			scroll.OnScrollBarPosChanged = function()
				this.nVal = this.nMin + math.ceil((this:GetScrollPos() / this:GetStepCount()) * (this.nMax - this.nMin))
				if this.OnScrollBarPosChanged_ then
					this.OnScrollBarPosChanged_(this.nVal)
				end
				self.txt:SetText(this.nVal .. this.szText)
			end
		end
	end
end

-- (number, number) Instance:Size()
-- (self) Instance:Size(number nW, number nH)
function _TF.UI.Wnd:Size(nW, nH)
	local wnd = self.self
	if not nW then
		local nW, nH = wnd:GetSize()
		if self.type == "WndRadioBox" or self.type == "WndCheckBox" or self.type == "WndTrackBar" then
			local xW, _ = self.txt:GetTextExtent()
			nW = nW + xW + 5
		end
		return nW, nH
	end
	if self.edit then
		wnd:SetSize(nW + 2, nH)
		self.handle:SetSize(nW + 2, nH)
		self.handle:Lookup("Image_Default"):SetSize(nW + 2, nH)
		self.edit:SetSize(nW, nH)
	else
		wnd:SetSize(nW, nH)
		if self.handle then
			self.handle:SetSize(nW, nH)
			if self.type == "WndButton" or self.type == "WndTabBox" then
				self.txt:SetSize(nW, nH)
			elseif self.type == "WndComboBox" then
				self.handle:Lookup("Image_ComboBoxBg"):SetSize(nW, nH)
				local btn = wnd:Lookup("Btn_ComboBox")
				local hnd = btn:Lookup("", "")
				local bW, bH = btn:GetSize()
				btn:SetRelPos(nW - bW - 5, math.ceil((nH - bH)/2))
				hnd:SetAbsPos(self.handle:GetAbsPos())
				hnd:SetSize(nW, nH)
				self.txt:SetSize(nW - math.ceil(bW/2), nH)
			elseif self.type == "WndCheckBox" then
				local _, xH = self.txt:GetTextExtent()
				self.txt:SetRelPos(nW - 20, math.floor((nH - xH)/2))
				self.handle:FormatAllItemPos()
			elseif self.type == "WndRadioBox" then
				local _, xH = self.txt:GetTextExtent()
				self.txt:SetRelPos(nW + 5, math.floor((nH - xH)/2))
				self.handle:FormatAllItemPos()
			elseif self.type == "WndTrackBar" then
				wnd:Lookup("Scroll_Track"):SetSize(nW, nH - 13)
				wnd:Lookup("Scroll_Track/Btn_Track"):SetSize(math.ceil(nW/5), nH - 13)
				self.handle:Lookup("Image_BG"):SetSize(nW, nH - 15)
				self.handle:Lookup("Text_Default"):SetRelPos(nW + 5, math.ceil((nH - 25)/2))
				self.handle:FormatAllItemPos()
			end
		end
	end
	return self
end

-- (boolean) Instance:Enable()
-- (self) Instance:Enable(boolean bEnable)
function _TF.UI.Wnd:Enable(bEnable)
	local wnd = self.edit or self.self
	local txt = self.edit or self.txt
	if bEnable == nil then
		if self.type == "WndButton" then
			return wnd:IsEnabled()
		end
		return self.enable ~= false
	end
	if bEnable then
		wnd:Enable(1)
		if txt and self.font then
			txt:SetFontScheme(self.font)
		end
		self.enable = true
	else
		wnd:Enable(0)
		if txt and self.enable ~= false then
			self.font = txt:GetFontScheme()
			txt:SetFontScheme(161)
		end
		self.enable = false
	end
	return self
end

-- (self) Instance:AutoSize([number hPad[, number vPad] ])
function _TF.UI.Wnd:AutoSize(hPad, vPad)
	local wnd = self.self
	if self.type == "WndTabBox" or self.type == "WndButton" then
		local _, nH = wnd:GetSize()
		local nW, _ = self.txt:GetTextExtent()
		local nEx = self.txt:GetTextPosExtent()
		if hPad then
			nW = nW + hPad + hPad
		end
		if vPad then
			nH = nH + vPad + vPad
		end
		self:Size(nW + nEx + 16, nH)
	elseif self.type == "WndComboBox" then
		local bW, _ = wnd:Lookup("Btn_ComboBox"):GetSize()
		local nW, nH = self.txt:GetTextExtent()
		local nEx = self.txt:GetTextPosExtent()
		if hPad then
			nW = nW + hPad + hPad
		end
		if vPad then
			nH = nH + vPad + vPad
		end
		self:Size(nW + bW + 20, nH + 6)
	end
	return self
end

-- (boolean) Instance:Check()
-- (self) Instance:Check(boolean bCheck)
-- NOTICE：only for WndCheckBox
function _TF.UI.Wnd:Check(bCheck)
	local wnd = self.self
	if wnd:GetType() == "WndCheckBox" then
		if bCheck == nil then
			return wnd:IsCheckBoxChecked()
		end
		wnd:Check(bCheck == true)
	end
	return self
end

-- (string) Instance:Group()
-- (self) Instance:Group(string szGroup)
-- NOTICE：only for WndCheckBox
function _TF.UI.Wnd:Group(szGroup)
	local wnd = self.self
	if wnd:GetType() == "WndCheckBox" then
		if not szGroup then
			return wnd.group
		end
		wnd.group = szGroup
	end
	return self
end

-- (string) Instance:Url()
-- (self) Instance:Url(string szUrl)
-- NOTICE：only for WndWebPage
function _TF.UI.Wnd:Url(szUrl)
	local wnd = self.self
	if self.type == "WndWebPage" then
		if not szUrl then
			return wnd:GetLocationURL()
		end
		wnd:Navigate(szUrl)
	end
	return self
end

-- (number, number, number) Instance:Range()
-- (self) Instance:Range(number nMin, number nMax[, number nStep])
-- NOTICE：only for WndTrackBar
function _TF.UI.Wnd:Range(nMin, nMax, nStep)
	if self.type == "WndTrackBar" then
		local scroll = self.self:Lookup("Scroll_Track")
		if not nMin and not nMax then
			return scroll.nMin, scroll.nMax, scroll:GetStepCount()
		end
		if nMin then scroll.nMin = nMin end
		if nMax then scroll.nMax = nMax end
		if nStep then scroll:SetStepCount(nStep) end
		self:Value(scroll.nVal)
	end
	return self
end

-- (number) Instance:Value()
-- (self) Instance:Value(number nVal)
-- NOTICE：only for WndTrackBar
function _TF.UI.Wnd:Value(nVal)
	if self.type == "WndTrackBar" then
		local scroll = self.self:Lookup("Scroll_Track")
		if not nVal then
			return scroll.nVal
		end
		scroll.nVal = math.min(math.max(nVal, scroll.nMin), scroll.nMax)
		scroll:SetScrollPos(math.ceil((scroll.nVal - scroll.nMin) / (scroll.nMax - scroll.nMin) * scroll:GetStepCount()))
		self.txt:SetText(scroll.nVal .. scroll.szText)
	end
	return self
end

-- (string) Instance:Text()
-- (self) Instance:Text(string szText[, boolean bDummy])
-- bDummy		-- 设为 true 不触发输入框的 onChange 事件
function _TF.UI.Wnd:Text(szText, bDummy)
	local txt = self.edit or self.txt
	if txt then
		if not szText then
			return txt:GetText()
		end
		if self.type == "WndTrackBar" then
			local scroll = self.self:Lookup("Scroll_Track")
			scroll.szText = szText
			txt:SetText(scroll.nVal .. scroll.szText)
		elseif self.type == "WndEdit" and bDummy then
			local fnChanged = txt.OnEditChanged
			txt.OnEditChanged = nil
			txt:SetText(szText)
			txt.OnEditChanged = fnChanged
		else
			txt:SetText(szText)
		end
		if self.type == "WndTabBox" then
			self:AutoSize()
		elseif self.type == "WndCheckBox" or self.type == "WndRadioBox" then
			local nW, nH = txt:GetTextExtent()
			txt:SetSize(nW + 26, nH)
			self.handle:SetSize(nW + 26, nH)
			self.handle:FormatAllItemPos()
		--	x,y=txt:GetRelPos() --自己加的没用
		--	txt:SetRelPos(x+10,y)
		end
	end
	return self
end

-- (boolean) Instance:Multi()
-- (self) Instance:Multi(boolean bEnable)
-- NOTICE: only for WndEdit
function _TF.UI.Wnd:Multi(bEnable)
	local edit = self.edit
	if edit then
		if bEnable == nil then
			return edit:IsMultiLine()
		end
		edit:SetMultiLine(bEnable == true)
	end
	return self
end

-- (number) Instance:Limit()
-- (self) Instance:Limit(number nLimit)
-- NOTICE: only for WndEdit
function _TF.UI.Wnd:Limit(nLimit)
	local edit = self.edit
	if edit then
		if not nLimit then
			return edit:GetLimit()
		end
		edit:SetLimit(nLimit)
	end
	return self
end

-- (self) Instance:Change()			-- 触发编辑框修改处理函数
-- (self) Instance:Change(func fnAction)
-- NOTICE：only for WndEdit，WndTrackBar
function _TF.UI.Wnd:Change(fnAction)
	if self.type == "WndTrackBar" then
		self.self:Lookup("Scroll_Track").OnScrollBarPosChanged_ = fnAction
	elseif self.edit then
		local edit = self.edit
		if not fnAction then
			if edit.OnEditChanged then
				local _this = this
				this = edit
				edit.OnEditChanged()
				this = _this
			end
		else
			edit.OnEditChanged = function()
				if not this.bChanging then
					this.bChanging = true
					fnAction(this:GetText())
					this.bChanging = false
				end
			end
		end
	end
	return self
end

-- (self) Instance:Menu(table menu)		-- 设置下拉菜单
-- NOTICE：only for WndComboBox
function _TF.UI.Wnd:Menu(menu)
	if self.type == "WndComboBox" then
		local wnd = self.self
		self:Click(function()
			local _menu = nil
			local nX, nY = wnd:GetAbsPos()
			local nW, nH = wnd:GetSize()
			if type(menu) == "function" then
				_menu = menu()
			else
				_menu = menu
			end
			_menu.nMiniWidth = nW
			_menu.x = nX
			_menu.y = nY + nH
			PopupMenu(_menu)
		end)
	end
	return self
end

-- (self) Instance:Click()
-- (self) Instance:Click(func fnAction)	-- 设置组件点击后触发执行的函数
-- fnAction = function([bCheck])			-- 对于 WndCheckBox 会传入 bCheck 代表是否勾选
function _TF.UI.Wnd:Click(fnAction)
	local wnd = self.self
	if self.type == "WndComboBox" then
		wnd = wnd:Lookup("Btn_ComboBox")
	end
	if wnd:GetType() == "WndCheckBox" then
		if not fnAction then
			self:Check(not self:Check())
		else
			wnd.OnCheckBoxCheck = function()
				if this.group then
					local uis = this:GetParent().___uis or {}
					for _, ui in pairs(uis) do
						if ui:Group() == this.group and ui:Name() ~= this:GetName() then
							ui.bCanUnCheck = true
							ui:Check(false)
							ui.bCanUnCheck = nil
						end
					end
				end
				fnAction(true)
			end
			wnd.OnCheckBoxUncheck = function()
				if this.group and not self.bCanUnCheck and string.sub(this.group, 1, 1) ~= "-" then
					self:Check(true)
				else
					fnAction(false)
				end
			end
		end
	else
		if not fnAction then
			if wnd.OnLButtonClick then
				local _this = this
				this = wnd
				wnd.OnLButtonClick()
				this = _this
			end
		else
			wnd.OnLButtonClick = fnAction
		end
	end
	return self
end

 
-- (self) Instance:Hover(func fnEnter[, func fnLeave])	-- 设置鼠标进出处理函数
-- fnEnter = function(true)		-- 鼠标进入时调用
-- fnLeave = function(false)		-- 鼠标移出时调用，若省略则和进入函数一样
function _TF.UI.Wnd:Hover(fnEnter, fnLeave)
	local wnd = self.wnd
	if self.type == "WndComboBox" then
		wnd = wnd:Lookup("Btn_ComboBox")
	end
	if wnd then
		fnLeave = fnLeave or fnEnter
		if fnEnter then
			wnd.OnMouseEnter = function() fnEnter(true) end
		end
		if fnLeave then
			wnd.OnMouseLeave = function() fnLeave(false) end
		end
	end
	return self
end
 
-------------------------------------
-- Handle Item
-------------------------------------
 _TF.UI.Item = class(_TF.UI.Base)

-- xml string
_TF.UI.tItemXML = {
	["Text"] = "<text>w=150 h=30 valign=1 font=162 eventid=257 </text>",
	["Image"] = "<image>w=100 h=100 eventid=257 </image>",
	["Box"] = "<box>w=48 h=48 eventid=525311 </box>",
	["Shadow"] = "<shadow>w=15 h=15 eventid=277 </shadow>",
	["Handle"] = "<handle>w=10 h=10</handle>",
	["Label"] = "<handle>w=150 h=30 eventid=257 <text>name=\"Text_Label\" w=150 h=30 font=162 valign=1 </text></handle>",
}

-- construct
function _TF.UI.Item:ctor(pHandle, szType, szName)
	local hnd = nil
	if not szType and not szName then
		-- convert from raw object
		hnd, szType = pHandle, pHandle:GetType()
	else
		local szXml = _TF.UI.tItemXML[szType]
		if szXml then
			-- append from xml
			local nCount = pHandle:GetItemCount()
			pHandle:AppendItemFromString(szXml)
			hnd = pHandle:Lookup(nCount)
			if hnd then hnd:SetName(szName) end
		else
			-- append from ini
			hnd = pHandle:AppendItemFromIni("interface\\TF\\0TF_Base\\ui\\HandleItems.ini","Handle_" .. szType, szName)
		end
		if not hnd then
			return TF.Sysmsg("Unable to append handle item " .. szType)
		end
	end
	if szType == "BoxButton" then
		self.txt = hnd:Lookup("Text_BoxButton")
		self.img = hnd:Lookup("Image_BoxIco")
		hnd.OnItemMouseEnter = function()
			if not this.bSelected then
				this:Lookup("Image_BoxBg"):Hide()
				this:Lookup("Image_BoxBgOver"):Show()
			end
		end
		hnd.OnItemMouseLeave = function()
			if not this.bSelected then
				this:Lookup("Image_BoxBg"):Show()
				this:Lookup("Image_BoxBgOver"):Hide()
			end
		end
	elseif szType == "TxtButton" then
		self.txt = hnd:Lookup("Text_TxtButton")
		self.img = hnd:Lookup("Image_TxtBg")
		hnd.OnItemMouseEnter = function()
			self.img:Show()
		end
		hnd.OnItemMouseLeave = function()
			if not this.bSelected then
				self.img:Hide()
			end
		end
	elseif szType == "Label" then
		self.txt = hnd:Lookup("Text_Label")
	elseif szType == "Text" then
		self.txt = hnd
	elseif szType == "Image" then
		self.img = hnd
	end
	self.self, self.type = hnd, szType
	hnd:SetRelPos(0, 0)
	hnd:GetParent():FormatAllItemPos()
end

-- (number, number) Instance:Size()
-- (self) Instance:Size(number nW, number nH)
function _TF.UI.Item:Size(nW, nH)	 
	local hnd = self.self
	if not nW then
		local nW, nH = hnd:GetSize()
		if self.type == "Text" or self.type == "Label" then
			nW, nH = self.txt:GetTextExtent()
		end
		return nW, nH
	end
	hnd:SetSize(nW, nH)
	if self.type == "BoxButton" then
		local nPad = math.ceil(nH * 0.2)
		hnd:Lookup("Image_BoxBg"):SetSize(nW - 12, nH + 8)
		hnd:Lookup("Image_BoxBgOver"):SetSize(nW - 12, nH + 8)
		hnd:Lookup("Image_BoxBgSel"):SetSize(nW - 1, nH + 11)
		self.img:SetSize(nH - nPad, nH - nPad)
		self.img:SetRelPos(10, math.ceil(nPad / 2))
		self.txt:SetSize(nW - nH - nPad, nH)
		self.txt:SetRelPos(nH + 10, 0)
		hnd:FormatAllItemPos()
	elseif self.type == "TxtButton" then
		self.img:SetSize(nW, nH - 5)
		self.txt:SetSize(nW - 10, nH - 5)
	elseif self.type == "Label" then
		self.txt:SetSize(nW, nH)
	end
	return self
end

-- (self) Instance:Zoom(boolean bEnable)	-- 是否启用点击后放大
-- NOTICE：only for BoxButton
function _TF.UI.Item:Zoom(bEnable)
	local hnd = self.self
	if self.type == "BoxButton" then
		local bg = hnd:Lookup("Image_BoxBg")
		local sel = hnd:Lookup("Image_BoxBgSel")
		if bEnable == true then
			local nW, nH = bg:GetSize()
			sel:SetSize(nW + 11, nH + 3)
			sel:SetRelPos(1, -5)
		else
			sel:SetSize(bg:GetSize())
			sel:SetRelPos(5, -2)
		end
		hnd:FormatAllItemPos()
	end
	return self
end

-- (self) Instance:Select()		-- 激活选中当前按纽，进行特效处理
-- NOTICE：only for BoxButton，TxtButton
function _TF.UI.Item:Select()
	local hnd = self.self
	if self.type == "BoxButton" or self.type == "TxtButton" then
		local hParent, nIndex = hnd:GetParent(), hnd:GetIndex()
		local nCount = hParent:GetItemCount() - 1
		for i = 0, nCount do
			local item = TF.UI.Fetch(hParent:Lookup(i))
			if item and item.type == self.type then
				if i == nIndex then
					if not item.self.bSelected then
						hnd.bSelected = true
						hnd.nIndex = i
						if self.type == "BoxButton" then
							hnd:Lookup("Image_BoxBg"):Hide()
							hnd:Lookup("Image_BoxBgOver"):Hide()
							hnd:Lookup("Image_BoxBgSel"):Show()
							self.txt:SetFontScheme(65)
							local icon = hnd:Lookup("Image_BoxIco")
							local nW, nH = icon:GetSize()
							local nX, nY = icon:GetRelPos()
							icon:SetSize(nW + 8, nH + 8)
							icon:SetRelPos(nX - 3, nY - 5)
							hnd:FormatAllItemPos()
						else
							self.img:Show()
						end
					end
				elseif item.self.bSelected then
					item.self.bSelected = false
					if item.type == "BoxButton" then
						item.self:SetIndex(item.self.nIndex)
						if hnd.nIndex >= item.self.nIndex then
							hnd.nIndex = hnd.nIndex + 1
						end
						item.self:Lookup("Image_BoxBg"):Show()
						item.self:Lookup("Image_BoxBgOver"):Hide()
						item.self:Lookup("Image_BoxBgSel"):Hide()
						item.txt:SetFontScheme(163)
						local icon = item.self:Lookup("Image_BoxIco")
						local nW, nH = icon:GetSize()
						local nX, nY = icon:GetRelPos()
						icon:SetSize(nW - 8, nH - 8)
						icon:SetRelPos(nX + 3, nY + 5)
						item.self:FormatAllItemPos()
					else
						item.img:Hide()
					end
				end
			end
		end
		if hnd.nIndex then
			hnd:SetIndex(nCount)
		end
	end
	return self
end

-- (string) Instance:Text()
-- (self) Instance:Text(string szText)
function _TF.UI.Item:Text(szText)
	local txt = self.txt
	if txt then
		if not szText then
			return txt:GetText()
		end
		txt:SetText(szText)
	end
	return self
end

-- (boolean) Instance:Multi()
-- (self) Instance:Multi(boolean bEnable)
-- NOTICE: only for Text，Label
function _TF.UI.Item:Multi(bEnable)
	local txt = self.txt
	if txt then
		if bEnable == nil then
			return txt:IsMultiLine()
		end
		txt:SetMultiLine(bEnable == true)
	end
	return self
end

-- (self) Instance:File(string szUitexFile, number nFrame)
-- (self) Instance:File(string szTextureFile)
-- (self) Instance:File(number dwIcon)
-- NOTICE：only for Image，BoxButton
function _TF.UI.Item:File(szFile, nFrame)
	local img = nil
	if self.type == "Image" then
		img = self.self
	elseif self.type == "BoxButton" then
		img = self.img
	end
	if img then
		if type(szFile) == "number" then
			img:FromIconID(szFile)
		elseif not nFrame then
			img:FromTextureFile(szFile)
		else
			img:FromUITex(szFile, nFrame)
		end
	end
	return self
end

-- (self) Instance:Type()
-- (self) Instance:Type(number nType)		-- 修改图片类型或 BoxButton 的背景类型
-- NOTICE：only for Image，BoxButton
function _TF.UI.Item:Type(nType)
	local hnd = self.self
	if self.type == "Image" then
		if not nType then
			return hnd:GetImageType()
		end
		hnd:SetImageType(nType)
	elseif self.type == "BoxButton" then
		if nType == nil then
			local nFrame = hnd:Lookup("Image_BoxBg"):GetFrame()
			if nFrame == 16 then
				return 2
			elseif nFrame == 18 then
				return 1
			end
			return 0
		elseif nType == 0 then
			hnd:Lookup("Image_BoxBg"):SetFrame(1)
			hnd:Lookup("Image_BoxBgOver"):SetFrame(2)
			hnd:Lookup("Image_BoxBgSel"):SetFrame(3)
		elseif nType == 1 then
			hnd:Lookup("Image_BoxBg"):SetFrame(18)
			hnd:Lookup("Image_BoxBgOver"):SetFrame(19)
			hnd:Lookup("Image_BoxBgSel"):SetFrame(22)
		elseif nType == 2 then
			hnd:Lookup("Image_BoxBg"):SetFrame(16)
			hnd:Lookup("Image_BoxBgOver"):SetFrame(17)
			hnd:Lookup("Image_BoxBgSel"):SetFrame(15)
		end
	end
	return self
end

-- (self) Instance:Icon(number dwIcon)
-- NOTICE：only for Box，Image，BoxButton
function _TF.UI.Item:Icon(dwIcon)
	if self.type == "BoxButton" or self.type == "Image" then
		self.img:FromIconID(dwIcon)
	elseif self.type == "Box" then
		self.self:SetObjectIcon(dwIcon)
	end
	return self
end

-- (self) Instance:Click()
-- (self) Instance:Click(func fnAction[, boolean bSound[, boolean bSelect] ])	-- 登记鼠标点击处理函数
-- (self) Instance:Click(func fnAction[, table tLinkColor[, tHoverColor] ])		-- 同上，只对文本
function _TF.UI.Item:Click(fnAction, szTip, bSound, bSelect)
	local hnd = self.self
	--hnd:RegisterEvent(0x001)
	if not fnAction then
		if hnd.OnItemLButtonDown then
			local _this = this
			this = hnd
			hnd.OnItemLButtonDown()
			this = _this
		end
	elseif self.type == "BoxButton" or self.type == "TxtButton" then
		hnd.OnItemLButtonDown = function()
			if bSound then PlaySound(SOUND.UI_SOUND, g_sound.Button) end
			if bSelect then self:Select() end
			fnAction()
		end
	else
		hnd.OnItemLButtonDown = fnAction
		-- text link：tLinkColor，tHoverColor
		local txt = self.txt
		if txt then
			local tLinkColor = bSound or { 90, 230, 90 }
			local tHoverColor = bSelect  or { 100, 210, 220 }
			txt:SetFontColor(unpack(tLinkColor))
			if tHoverColor then
				self:Hover(function(bIn)
					if bIn then
						if szTip then TF.ShowTip(szTip) end
						txt:SetFontColor(unpack(tHoverColor))
					else
						txt:SetFontColor(unpack(tLinkColor))
					end
				end,function() HideTip()  txt:SetFontColor(unpack(tLinkColor)) end)
			end
		end	
	end
	return self
end

 

-- (self) Instance:Hover(func fnEnter[, func fnLeave])	-- 设置鼠标进出处理函数
-- fnEnter = function(true)		-- 鼠标进入时调用
-- fnLeave = function(false)		-- 鼠标移出时调用，若省略则和进入函数一样
function _TF.UI.Item:Hover(fnEnter, fnLeave,tLinkColor,tHoverColor)
	local hnd = self.self
	--hnd:RegisterEvent(0x300)
	--fnLeave = fnLeave or fnEnter
	fnLeave=fnLeave or HideTip
	if fnEnter then
		hnd.OnItemMouseEnter = function() 
			fnEnter(true) 
			if not tHoverColor then return end
			local txt = self.txt
			if txt then txt:SetFontColor(unpack(tHoverColor)) end
		end
	end
	if fnLeave then
		hnd.OnItemMouseLeave = function() 
			fnLeave(false) 
			if not tLinkColor then return end
			local txt = self.txt
			if txt then txt:SetFontColor(unpack(tLinkColor)) end
		end
	end
	return self
end
 
---------------------------------------------------------------------
-- 公开的 API：TF.UI.xxx
---------------------------------------------------------------------
TF.UI = {}
 
-- 设置元表，这样可以当作函数调用，其效果相当于 TF.UI.Fetch
setmetatable(TF.UI, { __call = function(me, ...) return me.Fetch(...) end, __metatable = true })

-- 开启一个空的对话窗体界面，并返回 TF.UI 封装对象
-- (class) TF.UI.CreateFrame([string szName, ]table tArg)
-- szName		-- *可选* 名称，若省略则自动编序号
-- tArg {			-- *可选* 初始化配置参数，自动调用相应的封装方法，所有属性均可选
--		w, h,			-- 宽和高，成对出现用于指定大小，注意宽度会自动被就近调节为：770/380/234，高度最小 200
--		x, y,			-- 位置坐标，默认在屏幕正中间
--		title			-- 窗体标题
--		drag			-- 设置窗体是否可拖动
--		close		-- 点击关闭按纽是是否真正关闭窗体（若为 false 则是隐藏）
--		empty		-- 创建空窗体，不带背景，全透明，只是界面需求
--		fnCreate = function(frame)		-- 打开窗体后的初始化函数，frame 为内容窗体，在此设计 UI
--		fnDestroy = function(frame)	-- 关闭销毁窗体时调用，frame 为内容窗体，可在此清理变量
-- }
-- 返回值：通用的  TF.UI 对象，可直接调用封装方法
TF.UI.CreateFrame = function(szName, tArg)
	if type(szName) == "table" then
		szName, tArg = nil, szName
	end
	tArg = tArg or {}
	local ui = _TF.UI.Frm.new(szName, tArg.empty == true)
	-- apply init setting
	if tArg.w and tArg.h then ui:Size(tArg.w, tArg.h) end
	if tArg.x and tArg.y then ui:Pos(tArg.x, tArg.y) end
	if tArg.title then ui:Title(tArg.title) end
	if tArg.drag ~= nil then ui:Drag(tArg.drag) end
	if tArg.close ~= nil then ui.self.bClose = tArg.close end
	if tArg.fnCreate then tArg.fnCreate(ui:Raw()) end
	if tArg.fnDestroy then ui.fnDestroy = tArg.fnDestroy end
	if tArg.parent then ui:Relation(tArg.parent) end
	return ui
end

-- 创建空窗体
TF.UI.CreateFrameEmpty = function(szName, szParent)
	return TF.UI.CreateFrame(szName, { empty  = true, parent = szParent })
end

-- 往某一父窗体或容器添加  INI 配置文件中的部分，并返回 TF.UI 封装对象
-- (class) TF.UI.Append(userdata hParent, string szIniFile, string szTag, string szName)
-- hParent		-- 父窗体或容器原始对象（TF.UI 对象请直接用  :Append 方法）
-- szIniFile		-- INI 文件路径
-- szTag			-- 要添加的对象源，即中括号内的部分 [XXXX]，请与 hParent 匹配采用 Wnd 或容器组件
-- szName		-- *可选* 对象名称，若不指定则沿用原名称
-- 返回值：通用的  TF.UI 对象，可直接调用封装方法，失败或出错返回 nil
-- 特别注意：这个函数也支持添加窗体对象
TF.UI.AppendIni = function(hParent, szFile, szTag, szName)
	local raw = nil
	if hParent:GetType() == "Handle" then
		if not szName then
			szName = "Child_" .. hParent:GetItemCount()
		end
		raw = hParent:AppendItemFromIni(szFile, szTag, szName)
	elseif string.sub(hParent:GetType(), 1, 3) == "Wnd" then
		local frame = Wnd.OpenWindow(szFile, "TF_Virtual")
		if frame then
			raw = frame:Lookup(szTag)
			if raw and string.sub(raw:GetType(), 1, 3) == "Wnd" then
				raw:ChangeRelation(hParent, true, true)
				if szName then
					raw:SetName(szName)
				end
			else
				raw = nil
			end
			Wnd.CloseWindow(frame)
		end
	end
	if not raw then
		TF.Sysmsg("Fail to add component [" .. szTag .. "@" .. szFile) 
		else
		return TF.UI.Fetch(raw)
	end
end

-- 往某一父窗体或容器添加 TF.UI 组件并返回封装对象
-- (class) TF.UI.Append(userdata hParent, string szType[, string szName], table tArg)
-- hParent		-- 父窗体或容器原始对象（TF.UI 对象请直接用  :Append 方法）
-- szType			-- 要添加的组件类型（如：WndWindow，WndEdit，Handle，Text ……）
-- szName		-- *可选* 名称，若省略则自动编序号
-- tArg {			-- *可选* 初始化配置参数，自动调用相应的封装方法，所有属性均可选，如果没用则忽略
--		w, h,			-- 宽和高，成对出现用于指定大小
--		x, y,			-- 位置坐标
--		txt, font, multi, limit, align		-- 文本内容，字体，是否多行，长度限制，对齐方式（0：左，1：中，2：右）
--		color, alpha			-- 颜色，不透明度
--		checked				-- 是否勾选，CheckBox 专用
--		enable					-- 是否启用
--		file, icon, type		-- 图片文件地址，图标编号，类型
--		group					-- 单选框分组设置
-- }
-- 返回值：通用的  TF.UI 对象，可直接调用封装方法，失败或出错返回 nil
-- 特别注意：为统一接口此函数也可用于 AppendIni 文件，参数与 TF.UI.AppendIni 一致
-- (class) TF.UI.Append(userdata hParent, string szIniFile, string szTag, string szName)
TF.UI.Append = function(hParent, szType, szName, tArg)
	-- compatiable with AppendIni
	if StringFindW(szType, ".ini") ~= nil then
		return TF.UI.AppendIni(hParent, szType, szName, tArg)
	end
	-- reset parameters
	if not tArg and type(szName) == "table" then
		szName, tArg = nil, szName
	end
	if not szName then
		if not hParent.nAutoIndex then
			hParent.nAutoIndex = 1
		end
		szName = szType .. "_" .. hParent.nAutoIndex
		hParent.nAutoIndex = hParent.nAutoIndex + 1
	else
		szName = tostring(szName)
	end
	-- create ui
	local ui = nil
	if string.sub(szType, 1, 3) == "Wnd" then
		if string.sub(hParent:GetType(), 1, 3) ~= "Wnd" then
			return TF.Sysmsg("The 1st arg for adding component must be a [WndXxx]")
		end
		ui = _TF.UI.Wnd.new(hParent, szType, szName)
	else
		if hParent:GetType() ~= "Handle" then
			return TF.Sysmsg("The 1st arg for adding item must be a [Handle]")
		end
		ui = _TF.UI.Item.new(hParent, szType, szName)
	end
	local raw = ui:Raw()
	if raw then
		-- for reverse fetching
		hParent.___uis = hParent.___uis or {}
		for k, v in pairs(hParent.___uis) do
			if not v.self.___id then
				hParent.___uis[k] = nil
			end
		end
		hParent.___uis[szName] = ui
		hParent.___last = szName
		-- apply init setting
		tArg = tArg or {}
		if tArg.w and tArg.h then ui:Size(tArg.w, tArg.h) end
		if tArg.x and tArg.y then ui:Pos(tArg.x, tArg.y) end
		if tArg.font then ui:Font(tArg.font) end
		if tArg.multi ~= nil then ui:Multi(tArg.multi) end
		if tArg.limit then ui:Limit(tArg.limit) end
		if tArg.color then ui:Color(unpack(tArg.color)) end
		if tArg.align ~= nil then ui:Align(tArg.align) end
		if tArg.alpha then ui:Alpha(tArg.alpha) end
		if tArg.txt then ui:Text(tArg.txt) end
		if tArg.checked ~= nil then ui:Check(tArg.checked) end
		-- wnd only
		if tArg.enable ~= nil then ui:Enable(tArg.enable) end
		if tArg.group then ui:Group(tArg.group) end
		if ui.type == "WndComboBox" and (not tArg.w or not tArg.h) then
			ui:Size(185, 25)
		end
		-- item only
		if tArg.file then ui:File(tArg.file, tArg.num) end
		if tArg.icon ~= nil then ui:Icon(tArg.icon) end
		if tArg.type then ui:Type(tArg.type) end
		return ui
	end
end

-- (class) TF.UI(...)
-- (class) TF.UI.Fetch(hRaw)						-- 将 hRaw 原始对象转换为 TF.UI 封装对象
-- (class) TF.UI.Fetch(hParent, szName)	-- 从 hParent 中提取名为 szName 的子元件并转换为 TF.UI 对象
-- 返回值：通用的  TF.UI 对象，可直接调用封装方法，失败或出错返回 nil
TF.UI.Fetch = function(hParent, szName)
	if type(hParent) == "string" then
		hParent = Station.Lookup(hParent)
	end
	if not szName then
		szName = hParent:GetName()
		hParent = hParent:GetParent()
	end
	-- exists
	if hParent.___uis and hParent.___uis[szName] then
		local ui = hParent.___uis[szName]
		if ui and ui.self.___id then
			return ui
		end
	end
	-- convert
	local hRaw = hParent:Lookup(szName)
	if hRaw then
		local ui
		if string.sub(hRaw:GetType(), 1, 3) == "Wnd" then
			ui = _TF.UI.Wnd.new(hRaw)
		else
			ui = _TF.UI.Item.new(hRaw)
		end
		hParent.___uis = hParent.___uis or {}
		hParent.___uis[szName] = ui
		return ui
	end
end  


---------------------------------------------------------------------
-- 主窗体界面回调函数 TF.OnXXX
---------------------------------------------------------------------
-- create frame
TF.OnFrameCreate = function()
	-- var
	_TF.frame = this
	_TF.hTotal = this:Lookup("Wnd_Content", "")
	_TF.hScroll = this:Lookup("Wnd_Content/Scroll_List")
	_TF.hList = _TF.hTotal:Lookup("Handle_List")
	_TF.hContent = _TF.hTotal:Lookup("Handle_Content")
	_TF.hBox = _TF.hTotal:Lookup("Box_1")
	-- title
	local szTitle =_TF.szTitle  .. " v" .. TF.GetVersion() .. " (" .. TF.szBuildDate .. ")"
	_TF.hTotal:Lookup("Text_Title"):SetText(szTitle)
	-- position
	this:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
	this:RegisterEvent("UI_SCALED")
	-- update list/detail
	_TF.UpdateTabBox(this)
	--_TF.UpdateDetail()

end

TF.OnEvent = function(szEvent)		--是否需要onevent?
	if szEvent == "UI_SCALED" then
		_TF.UpdateAnchor(this)
	end
end
TF.OnFrameDragEnd = function()
	this:CorrectPos()
	_TF.tAnchor = GetFrameAnchor(this)
end
-- breathe
TF.OnFrameBreathe = function()
	-- run breathe calls
	local nFrame = GetLogicFrameCount()
	for k, v in pairs(_TF.tBreatheCall) do
		if nFrame >= v.nNext then
			v.nNext = nFrame + v.nFrame
			local res, err = pcall(v.fnAction)
			if not res then
				TF.Debug("BreatheCall#" .. k .." ERROR: " .. err)
			end
		end
	end
	-- run delay calls
	local nTime = GetTime()
	for k = #_TF.tDelayCall, 1, -1 do
		local v = _TF.tDelayCall[k]
		if v.nTime <= nTime then
			local res, err = pcall(v.fnAction)
			if not res then
				TF.Debug("DelayCall#" .. k .." ERROR: " .. err)
			end
			table.remove(_TF.tDelayCall, k)
		end
	end
	-- run player monitor
	--_TF.SetTempTarget()
	-- run remote request (10s)
	if not _TF.nRequestExpire or _TF.nRequestExpire < nTime then
		if _TF.nRequestExpire then
			local r = table.remove(_TF.tRequest, 1)
			if r and r.fnAction then
				pcall(r.fnAction)
			end
			_TF.nRequestExpire = nil
		end
		if #_TF.tRequest > 0 then
			local page = Station.Lookup("Normal/TF/Page_1")
			if page then
				page:Navigate(_TF.tRequest[1].szUrl)
			end
			_TF.nRequestExpire = GetTime() + 15000
		end
	end
end

-- key down
TF.OnFrameKeyDown = function()
	if GetKeyName(Station.GetMessageKey()) == "Esc" then
		_TF.ClosePanel()
		return 1
	end
	return 0
end
 
-- button click
TF.OnLButtonClick = function()
	local szName = this:GetName()
	if szName == "Btn_Close" then
		_TF.ClosePanel()
	elseif szName == "Btn_Up" then
		_TF.hScroll:ScrollPrev(1)
	elseif szName == "Btn_Down" then
		_TF.hScroll:ScrollNext(1)
	end
end

-- scrolls
TF.OnScrollBarPosChanged = function()
	local handle, frame = _TF.hList, this:GetParent()
	local nPos = this:GetScrollPos()
	if nPos == 0 then
		frame:Lookup("Btn_Up"):Enable(0)
	else
		frame:Lookup("Btn_Up"):Enable(1)
	end
	if nPos == this:GetStepCount() then
		frame:Lookup("Btn_Down"):Enable(0)
	else
		frame:Lookup("Btn_Down"):Enable(1)
	end
    handle:SetItemStartRelPos(0, - nPos * 10)
end

-- web page complete
TF.OnDocumentComplete = function()
	local r = table.remove(_TF.tRequest, 1)
	if r then
		_TF.nRequestExpire = nil
		if r.fnAction then
			pcall(r.fnAction, this:GetLocationName(), this:GetDocument())
		end
	end
end

------------------------------------
--Compatible
------------------------------------
-- internet exploere
if not OpenInternetExplorer then
function IsInternetExplorerOpened(nIndex)
	local frame = Station.Lookup("Topmost/IE"..nIndex)
	if frame and frame:IsVisible() then
		return true
	end
	return false
end

function IE_GetNewIEFramePos()
	local nLastTime = 0
	local nLastIndex = nil
	for i = 1, 10, 1 do
		local frame = Station.Lookup("Topmost/IE"..i)
		if frame and frame:IsVisible() then
			if frame.nOpenTime > nLastTime then
				nLastTime = frame.nOpenTime
				nLastIndex = i
			end
		end
	end
	if nLastIndex then
		local frame = Station.Lookup("Topmost/IE"..nLastIndex)
		x, y = frame:GetAbsPos()
		local wC, hC = Station.GetClientSize()
		if x + 890 <= wC and y + 630 <= hC then
			return x + 30, y + 30
		end
	end
	return 40, 40
end

function OpenInternetExplorer(szAddr, bDisableSound)
	local nIndex, nLast = nil, nil
	for i = 1, 10, 1 do
		if not IsInternetExplorerOpened(i) then
			nIndex = i
			break
		elseif not nLast then
			nLast = i
		end
	end
	if not nIndex then
		OutputMessage("MSG_ANNOUNCE_RED", g_tStrings.MSG_OPEN_TOO_MANY)
		return nil
	end
	local x, y = IE_GetNewIEFramePos()
	local frame = Wnd.OpenWindow("InternetExplorer", "IE"..nIndex)
	frame.bIE = true
	frame.nIndex = nIndex

	frame:BringToTop()
	if nLast then
		frame:SetAbsPos(x, y)
		frame:CorrectPos()
		frame.x = x
		frame.y = y
	else
		frame:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
		frame.x, frame.y = frame:GetAbsPos()
	end
	local webPage = frame:Lookup("WebPage_Page")
	if szAddr then
		webPage:Navigate(szAddr)
	end
	Station.SetFocusWindow(webPage)
	if not bDisableSound then
		PlaySound(SOUND.UI_SOUND,g_sound.OpenFrame)
	end
	return webPage
end
end

-- dialogue panel
if not IsDialoguePanelOpened then
function IsDialoguePanelOpened()
	local frame = Station.Lookup("Normal/DialoguePanel")
	if frame and frame:IsVisible() then
		return true
	end
	return false
end
end

-- hotkey panel
function HotkeyPanel_Open(szGroup)
	local frame = Station.Lookup("Topmost/HotkeyPanel")
	if not frame then
		frame = Wnd.OpenWindow("HotkeyPanel")
	elseif not frame:IsVisible() then
		frame:Show()
	end
	if not szGroup then return end
	-- load aKey
	local aKey, nI, bindings = nil, 0, Hotkey.GetBinding(false)
	for k, v in pairs(bindings) do
		if v.szHeader ~= "" then
			if aKey then
				break
			elseif v.szHeader == szGroup then
				aKey = {}
			else
				nI = nI + 1
			end
		end
		if aKey then
			if not v.Hotkey1 then
				v.Hotkey1 = {nKey = 0, bShift = false, bCtrl = false, bAlt = false}
			end
			if not v.Hotkey2 then
				v.Hotkey2 = {nKey = 0, bShift = false, bCtrl = false, bAlt = false}
			end
			table.insert(aKey, v)
		end
	end
	if not aKey then return end
	local hP = frame:Lookup("", "Handle_List")
	local hI = hP:Lookup(nI)
	if hI.bSel then return end
	-- update list effect
	for i = 0, hP:GetItemCount() - 1 do
		local hB = hP:Lookup(i)
		if hB.bSel then
			hB.bSel = false
			if hB.IsOver then
				hB:Lookup("Image_Sel"):SetAlpha(128)
				hB:Lookup("Image_Sel"):Show()
			else
				hB:Lookup("Image_Sel"):Hide()
			end
		end
	end
	hI.bSel = true
	hI:Lookup("Image_Sel"):SetAlpha(255)
	hI:Lookup("Image_Sel"):Show()
	-- update content keys [hI.nGroupIndex]
	local hK = frame:Lookup("", "Handle_Hotkey")
	local szIniFile = "UI/Config/default/HotkeyPanel.ini"
	Hotkey.SetCapture(false)
	hK:Clear()
	hK.nGroupIndex = hI.nGroupIndex
	hK:AppendItemFromIni(szIniFile, "Text_GroupName")
	hK:Lookup(0):SetText(szGroup)
	hK:Lookup(0).bGroup = true
	for k, v in ipairs(aKey) do
		hK:AppendItemFromIni(szIniFile, "Handle_Binding")
		local hI = hK:Lookup(k)
		hI.bBinding = true
		hI.nIndex = k
		hI.szTip = v.szTip
		hI:Lookup("Text_Name"):SetText(v.szDesc)
		for i = 1, 2, 1 do
			local hK = hI:Lookup("Handle_Key"..i)
			hK.bKey = true
			hK.nIndex = i
			local hotkey = v["Hotkey"..i]
			hotkey.bUnchangeable = v.bUnchangeable
			hK.bUnchangeable = v.bUnchangeable
			local text = hK:Lookup("Text_Key"..i)
			text:SetText(GetKeyShow(hotkey.nKey, hotkey.bShift, hotkey.bCtrl, hotkey.bAlt))
			-- update btn
			if hK.bUnchangeable then
				hK:Lookup("Image_Key"..hK.nIndex):SetFrame(56)
			elseif hK.bDown then
				hK:Lookup("Image_Key"..hK.nIndex):SetFrame(55)
			elseif hK.bRDown then
				hK:Lookup("Image_Key"..hK.nIndex):SetFrame(55)
			elseif hK.bSel then
				hK:Lookup("Image_Key"..hK.nIndex):SetFrame(55)
			elseif hK.bOver then
				hK:Lookup("Image_Key"..hK.nIndex):SetFrame(54)
			elseif hotkey.bChange then
				hK:Lookup("Image_Key"..hK.nIndex):SetFrame(56)
			elseif hotkey.bConflict then
				hK:Lookup("Image_Key"..hK.nIndex):SetFrame(54)
			else
				hK:Lookup("Image_Key"..hK.nIndex):SetFrame(53)
			end
		end
	end
	-- update content scroll
	hK:FormatAllItemPos()
	local wAll, hAll = hK:GetAllItemSize()
    local w, h = hK:GetSize()
    local scroll = frame:Lookup("Scroll_Key")
    local nCountStep = math.ceil((hAll - h) / 10)
    scroll:SetStepCount(nCountStep)
	scroll:SetScrollPos(0)
	if nCountStep > 0 then
		scroll:Show()
    	scroll:GetParent():Lookup("Btn_Up"):Show()
    	scroll:GetParent():Lookup("Btn_Down"):Show()
    else
    	scroll:Hide()
    	scroll:GetParent():Lookup("Btn_Up"):Hide()
    	scroll:GetParent():Lookup("Btn_Down"):Hide()
    end
	-- update list scroll
	local scroll = frame:Lookup("Scroll_List")
	if scroll:GetStepCount() > 0 then
		local _, nH = hI:GetSize()
		local nStep = math.ceil((nI * nH) / 10)
		if nStep > scroll:GetStepCount() then
			nStep = scroll:GetStepCount()
		end
		scroll:SetScrollPos(nStep)
	end
end


--------------------------------------------------------------------
-- 注册事件、初始化
---------------------------------------------------------------------
TF.RegisterEvent("PLAYER_ENTER_GAME", _TF.Init)
TF.RegisterEvent("DOODAD_ENTER_SCENE", function() _TF.aDoodad[arg0] = true end)
TF.RegisterEvent("DOODAD_LEAVE_SCENE", function() _TF.aDoodad[arg0] = nil end)
 TF.RegisterEvent("LOADING_END", function()
	if _TF.tConflict then
		for _, v in ipairs(_TF.tConflict) do v() end
		_TF.tConflict = nil
		TF.Sysmsg(string.format("欢迎%s使用体服插件集 v".. TF.GetVersion().." Build ".._TF.szBuildDate, GetClientPlayer().szName ))
	end
	-- reseting frame count (FIXED BUG FOR Cross Server)
--	_TF.nTempFrame = nil
	for k, v in pairs(_TF.tBreatheCall) do
		v.nNext = GetLogicFrameCount()
	end
end)

TF_Info={}
TF_Info.PS = {}
-- tab box switch
--TF_About.PS.OnTaboxCheck = function(frame, nIndex, szTitle)
TF_Info.PS.OnPanelActive = function(frame)
	local ui = TF.UI(frame)
	_,nY=ui:Append("Text", { txt = "简单、实用、专注PVX!（专为体服玩家定制", x = 0, y = 0, font=27}):Pos_()
	ui:Append("Text", { x = 0, y = 28, w = 500, h = 40, multi = true })
	:Align(0, 0):Text("这是玩家微雨凭阑开发并整合优化的剑网三测试服PVX辅助插件，未经官方认证，包含被和谐功能，只能在体服使用。")
	ui:Append("Text", { x = 0, y = 74, w = 500, h = 40, multi = true })
	:Align(0, 0):Text("本插件基于个人需求和兴趣开发，不提供任何责任担保。")
	ui:Append("WndCheckBox", { x =260, y = 122, checked = TF_About.bDebug == true })
	:Text("Enable Debug"):Click(function(bChecked) TF_About.bDebug = bChecked end)
	_,nY=ui:Append("Text", { txt = "当前版本：", x = 0, y = 122, font=27}):Pos_()
	nX=ui:Append("Text", { txt = "v"..TF.GetVersion().."(".._TF.szBuildDate..")", x = 0, y =  150 }):Pos_()
	_,nY = ui:Append("Text", { txt ="下载地址/更新日志", x = 0, y =188, font=27, })
	ui:Append("Text", { txt="sina微盘：微雨凭阑的分享", x = 0, y = 218, }):Click(function()
		OpenInternetExplorer("http://vdisk.weibo.com/u/5749249142") 
	end):ASize():Pos_()			
	ui:Append("Text", { txt="Github：https://github.com/DicTag/TF", x = 0, y = 244}):Click(function()
		OpenInternetExplorer("https://github.com/DicTag/TF") 
	end):ASize():Pos_()			
	ui:Append("Text", { txt =  "By 微雨凭阑" , x = 400, y =360, font = 79 }):Click(function()
		OpenInternetExplorer("http://weibo.com/weiyupinglan") 
	end,"作者微博"):ASize():Pos_()	
	_,nY=ui:Append("Text", { txt = "关于作者：", x = 0, y =  280, font = 27 }):Pos_()
	ui:Append("Text", { x = 0, y = 308, w = 500, h = 40, multi = true }):Align(0, 0):Text("一个常驻体服的纯PVX花姐，没事不要找她，有事更不要找她!")
end

TF.RegisterPanel("关于本插件", "Interface\\TF\\0TF_Base\\aboutTF.jpg", "插件信息", TF_Info.PS)

 


TF_Thank={}
TF_Thank.PS = {}
TF_Thank.PS.OnPanelActive = function(frame)
	local ui = TF.UI(frame)
	_,nY=ui:Append("Text", { txt = "特别鸣谢：", x = 0, y = 5, font=27}):Pos_()
	_,nY=ui:Append("Text", { txt = "感谢伊瑶、红红、风千与等插件作者为体服玩家编写插件；", x = 0, y = nY+20}):Pos_()
	_,nY=ui:Append("Text", { txt = "感谢海鳗、圈叔及crazy前辈开源，供学习API和函数用法；", x = 0, y = nY+12 }):Pos_()
	_,nY=ui:Append("Text", { txt = "感谢小雪、zylaputa、const奶周等前辈提供的入门教程；", x = 0, y =  nY+12 }):Pos_()
	_,nY=ui:Append("Text", { txt = "感谢海鳗、B叔提供的插件开发环境及南诏大将军的数据；", x = 0, y =  nY+12 }):Pos_()
	_,nY=ui:Append("Text", { txt = "感谢小黄鸡提供的debug环境，及开发资料查询；", x = 0, y = nY+12}):Pos_()
	_,nY=ui:Append("Text", { txt = "特别感谢海鳗、茗伊、小雪等前辈提供的指导；", x = 0, y = nY+12 }):Pos_()
	_,nY=ui:Append("Text", { txt = "感谢常驻体服小伙伴一直以来的关照。", x = 0, y = nY+12 }):Pos_()
end

TF.RegisterPanel("特别鸣谢", 3875, "插件信息", TF_Thank.PS)



TF_About={
	bDebug=false,
 }
_TF_About = {}
_TF_About.PS = {}

 _TF_About.PS.OnTaboxCheck = function(frame, nIndex, szTitle)
	local ui = TF.UI(frame)
	local szName, me = "你", GetClientPlayer()
	if me then szName = me.szName end
	-- info
	local nF = 0
	local t = TimeToDate(GetCurrentTime())
	local nT = t.month * 100 + t.day
	if nT > 720 and nT < 804 then
		nF = 1
	end
	_,nY=ui:Append("Image", { x = 0, y = 5, w = 532, h = 313 }):File(TF.GetCustomFile("WelImg.jpg", "Interface\\TF\\0TF_Base\\WelImg.jpg")):Pos_()
	nX = ui:Append("Text", { txt ="<插件下载>", x = 0, y = nY+10, font = 27 }):Click(function()
		OpenInternetExplorer("http://vdisk.weibo.com/u/5749249142") 
	end):ASize():Pos_()	
	nX = ui:Append("Text", { txt ="<更新日志>", x = nX+10, y = nY+10, font = 27 }):Click(function()
		OpenInternetExplorer("https://github.com/DicTag/TF/releases") 
	end):ASize():Pos_()	
	nX=ui:Append("Text", { txt = "<设置快捷键>", x = nX+10 , y = nY+10, font = 27 }):Click(function() HotkeyPanel_Open("【体服专用插件集】") end):ASize():Pos_()
	nX=ui:Append("Text", { txt = "<关于插件>", x = nX + 10, y = nY+10, font = 27 }):Click(function() TF.OpenPanel("关于本插件") end):ASize():Pos_()
	nX=ui:Append("Text", { txt = "<如何换图>", x = nX+10 , y = nY+10, font = 27 }):Click(function() OutputMessage("MSG_SYS","[TF插件集-如何替换欢迎图]\n在interface下建立 TFcustom 文件夹\n将图片拷至此目录，改名成WelImg.jpg\n长：宽 约为1.7，请选用相近长宽比的图\n")  end,"点击后看聊天栏提示"):ASize():Pos_()	
	ui:Append("Text", { txt =  "By 微雨凭阑" , x = 400, y =360, font = 79 }):Click(function()
		OpenInternetExplorer("http://weibo.com/weiyupinglan") 
	end,"作者微博"):ASize():Pos_()	
end  

--[[ _TF_About.PS.GetAuthorInfo = function()
	return "微雨凭阑"
end ]]

local _About = {
--	AddNameEx = _TF_About.AddNameEx,
--	CheckTarEx = _TF_About.CheckTarEx,
--	CheckNameEx = _TF_About.CheckNameEx,
	OnTaboxCheck = _TF_About.PS.OnTaboxCheck,
	OnPanelActive = _TF_About.PS.OnTaboxCheck,
--	GetAuthorInfo = _TF_About.PS.GetAuthorInfo,
--	SyncData = _TF_About.SyncData,
}
setmetatable(TF_About, { __metatable = true, __index = _About, __newindex = function() end } )
