--
-- 海鳗插件：Doodad 物品采集拾取助手
--
--正则表达式  查找  _L\[\"(.+)\"\]   替换 "\1"			--应该用 - 最短匹配

-------------
AutoDood = {
--	QuestItem="",
	bLoot = true,				-- 自动拾取
	bLootFight = true,		-- 战斗中拾取
	bLootGray = false,		-- 拾取灰色
	bLootWhite = true,		-- 拾取白色
	bLootGreen = true,	-- 拾取绿色
	tLootFilter = {},			-- 过滤不捡的物品 [名称] => true/false,
	bLootOnly = false,		-- 只拾取指定物品
	tLootOnly = {},				-- 指定物品列表 [名称] => true/false,
	bManualFilter2 = false,	-- 手动拾取也过滤？=> true/false
	bQuest = true,				-- 自动采集任务物品
	bShowName = true,	-- 显示物品名称
	bMiniFlag = true,		-- 显示小地图标记
	bInteract = true,			-- 自动采集
	tCraft = {},						-- 草药、矿石列表
	bCustom = true,			-- 启用自定义
	tCustom = {},				-- 自定义列表
	tNameColor = { 196, 64, 255 },	-- 头顶名称颜色
	bShowAll2 = false,
}
TF.RegisterCustomData("AutoDood")

---------------------------------------------------------------------
-- 本地函数和变量
---------------------------------------------------------------------
local function _d(dwID)
	return GetDoodadTemplate(dwID).szName
end

local _AutoDood = {
	-- 草药、矿石列表
	tCraft = {
		1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009,
		1010, 1011, 1012, 1015, 1016, 1017, 1018, 1019, 2641,
		2642, 2643, 3321, 3358, 3359, 3360, 3361, 4227, 4228,
		5659,5660, --5659白术，5660紫苏 
		0,	--0 switch
		1020, 1021, 1022, 1023, 1024, 1025, 1027, 2644, 2645,
		4229, 4230,5661,5662	--5661 天青 烟雨
	},
	tDoodad = {},	-- 待处理的 doodad 列表
	szIniFile = "interface\\TF\\AutoDood\\AutoDood.ini",
	nToLoot = 0,	-- 待拾取处理数量（用于修复判断）
}

-- filter menu
_AutoDood.GetFilterMenu = function()
	local m0 = {
		{
			szOption = "手动拾取也过滤", bCheck = true, bChecked = AutoDood.bManualFilter2,
			fnAction = function(d, b) AutoDood.bManualFilter2 = b end,
		}, {
			bDevide = true,
		}, {
			szOption = "过滤灰色物品", bCheck = true, bChecked = not AutoDood.bLootGray,
			fnDisable = function() return AutoDood.bLootOnly end,
			fnAction = function(d, b) AutoDood.bLootGray = not b end,
		}, {
			szOption = "过滤白色物品", bCheck = true, bChecked = not AutoDood.bLootWhite,
			fnDisable = function() return AutoDood.bLootOnly end,
			fnAction = function(d, b) AutoDood.bLootWhite = not b end,
		}, {
			szOption = "过滤绿色物品", bCheck = true, bChecked = not AutoDood.bLootGreen,
			fnDisable = function() return AutoDood.bLootOnly end,
			fnAction = function(d, b) AutoDood.bLootGreen = not b end,
		}
	}
	-- filter special
	local m1 = {
		szOption = "过滤指定物品",
		fnDisable = function() return AutoDood.bLootOnly end,
		{
			szOption = "* 添加 *",
			fnAction = function()
				GetUserInput("物品名称", function(szText)
					local szText =  string.gsub(szText, "^%s*%[?(.-)%]?%s*$", "%1")
					if szText ~= "" then
						AutoDood.tLootFilter[szText] = true
					end
				end)
			end
		}, {
			bDevide = true,
		}
	}
	for k, v in pairs(AutoDood.tLootFilter) do
		table.insert(m1, {
			szOption = k, bCheck = true, bChecked = v,
			fnAction = function(d, b) AutoDood.tLootFilter[k] = b end,
			{ szOption = "删除", fnAction = function() AutoDood.tLootFilter[k] = nil end }
		})
	end
	table.insert(m0, m1)
	-- loot special
	local m1 = {
		szOption = "仅拾取指定物品", bCheck = true, bChecked = AutoDood.bLootOnly,
		fnAction = function(d, b) AutoDood.bLootOnly = b end,
		{
			szOption = "* 添加 *",
			fnAction = function()
				GetUserInput("物品名称", function(szText)
					local szText =  string.gsub(szText, "^%s*%[?(.-)%]?%s*$", "%1")
					if szText ~= "" then
						AutoDood.tLootOnly[szText] = true
					end
				end)
			end
		}, {
			bDevide = true,
		}
	}
	for k, v in pairs(AutoDood.tLootOnly) do
		table.insert(m1, {
			szOption = k, bCheck = true, bChecked = v,
			fnAction = function(d, b) AutoDood.tLootOnly[k] = b end,
			{ szOption = "删除", fnAction = function() AutoDood.tLootOnly[k] = nil end }
		})
	end
	table.insert(m0, { bDevide = true })
	table.insert(m0, m1)
	return m0
end

-- get custom text
_AutoDood.GetCustomText = function()
	local szText = ""
	for k, _ in pairs(AutoDood.tCustom) do
		if szText == "" then
			szText = k
		else
			szText = szText .. "|" .. k
		end
	end
	return szText
end

-- try to add
_AutoDood.TryAdd = function(dwID, bDelay)
	local d = GetDoodad(dwID)
	if d then
		local data, me = nil, GetClientPlayer()
		if d.nKind == DOODAD_KIND.CORPSE or d.nKind == DOODAD_KIND.NPCDROP then
			if bDelay then
				--TF.Debug("delay to try add [" .. d.szName .. "#" .. d.dwID .. "]")
				return TF.DelayCall(500, function() _AutoDood.TryAdd(dwID) end)
			end
			if AutoDood.bLoot and d.CanLoot(me.dwID) then
				data = { loot = true }
			elseif AutoDood.bCustom and AutoDood.tCustom[d.szName]
				and GetDoodadTemplate(d.dwTemplateID).dwCraftID == 3
			then
				data = { craft = true }
			end
		elseif AutoDood.bQuest and (d.dwTemplateID == 3713 or d.dwTemplateID == 3714) then
			data = { craft = true }
		elseif AutoDood.tCraft[d.szName] or (AutoDood.bCustom and AutoDood.tCustom[d.szName]) then
			data = { craft = true }
		elseif d.HaveQuest(me.dwID) then
			if AutoDood.bQuest then
				data = { quest = true }
			end
		elseif d.dwTemplateID == 4733 or d.dwTemplateID == 4734 and AutoDood.bQuest then
			data = { craft = true }
		elseif AutoDood.bShowAll2 and d.nKind ~= DOODAD_KIND.QUEST and d.IsSelectable() then
			data = { other = true }
		end
		if data then
			_AutoDood.tDoodad[dwID] = data
			_AutoDood.bUpdateLabel = true
		end
	end
end

-- remove doodad
_AutoDood.Remove = function(dwID)
	local data = _AutoDood.tDoodad[dwID]
	if data then
		_AutoDood.tDoodad[dwID] = nil
		_AutoDood.bUpdateLabel = true
	end
end

-- reload doodad
_AutoDood.Reload = function()
	_AutoDood.tDoodad = {}
	for k, _ in pairs(TF.GetAllDoodadID()) do
		_AutoDood.TryAdd(k)
	end
	_AutoDood.bUpdateLabel = true
end

-- switch name
_AutoDood.SwitchName = function(bEnable)
	if bEnable == nil then
		AutoDood.bShowName = not AutoDood.bShow
	else
		AutoDood.bShowName = bEnable == true
	end
	local frame = Station.Lookup("Lowest/AutoDood")
	if AutoDood.bShowName then
		if not frame then
			Wnd.OpenWindow(_AutoDood.szIniFile, "AutoDood")
		end
	elseif frame then
		Wnd.CloseWindow(frame)
		_AutoDood.pLabel = nil
		_AutoDood.Reload()
	end
end

-- find & get opened dooad ID
_AutoDood.GetOpenDoodadID = function()
	local dwID = _AutoDood.dwOpenID
	if dwID then
		_AutoDood.dwOpenID = nil
	elseif AutoDood.bManualFilter2 then
		local tObject = Scene_SelectObject("all") or {}
		for _, v in pairs(tObject) do
			if v["Type"] == TARGET.DOODAD and IsCorpseAndCanLoot(v["ID"]) then
				dwID = v["ID"]
				break
			end
		end
	end
	return dwID
end

-------------------------------------
-- 事件处理
-------------------------------------
-- head name
_AutoDood.OnUpdateHeadName = function()
	local sha = _AutoDood.pLabel
	if not sha then return end
	local r, g, b = unpack(AutoDood.tNameColor)
	sha:SetTriangleFan(GEOMETRY_TYPE.TEXT)
	sha:ClearTriangleFanPoint()
	for k, v in pairs(_AutoDood.tDoodad) do
		if not v.loot then
			local tar = GetDoodad(k)
			if not tar or (v.quest and not tar.HaveQuest(GetClientPlayer().dwID)) then
				_AutoDood.Remove(k)
			else
				local szName = tar.szName
				if tar.dwTemplateID == 3713 or tar.dwTemplateID == 3714 then
					szName = Table_GetNpcTemplateName(1622)
				end
				sha:AppendDoodadID(tar.dwID, r, g, b, 255, 128, 40, szName, 0, 1)
			end
		end
	end
	sha:Show()
end

-- auto interact
_AutoDood.OnAutoDoodad = function()
	local me = GetClientPlayer()
	-- auto interact
	if not me or me.GetOTActionState() ~= 0
		or (me.nMoveState ~= MOVE_STATE.ON_STAND and me.nMoveState ~= MOVE_STATE.ON_FLOAT)
		or IsDialoguePanelOpened()
	then
		return
	end  
	for k, v in pairs(_AutoDood.tDoodad) do
		local d, bKeep, bIntr = GetDoodad(k), false, false
		if not d or not d.CanDialog(me) or v.other then
			-- 若存在却不能对话只简单保留
			bKeep = d ~= nil
		elseif v.loot then		-- 尸体只摸一次
			bKeep = true	-- 改在 opendoodad 中删除
			bIntr = (not me.bFightState or AutoDood.bLootFight) and d.CanLoot(me.dwID)
			if bIntr then
				_AutoDood.dwOpenID = k
			end
		elseif v.craft or d.HaveQuest(me.dwID) then		-- 任务和普通道具尝试 5 次
			bIntr = not me.bFightState and not me.bOnHorse and AutoDood.bInteract
			bKeep = true
		--[[ 	if AutoDood.QuestItem~="" and d.szName~=AutoDood.QuestItem then  bIntr=false	--Output("ganrao") ]]
			--elseif AutoDood.QuestItem~="" and d.szName==AutoDood.QuestItem then  -- Output("shiqu"..d.szName) 			
		--[[ 	end	 ]]
		end
		if not bKeep then
			_AutoDood.Remove(k)
		end
		if bIntr then
			TF.Debug("auto interact [" .. d.szName .. "]")
			TF.BreatheCallDelayOnce("AutoDoodad", 500)
		--[[ 	if d.szName==AutoDood.QuestItem  then AutoDood.QuestItem =""  end ]]
			return InteractDoodad(k)
		end
	end
end

-- open doodad (loot)
_AutoDood.OnOpenDoodad = function(dwID)
	_AutoDood.Remove(dwID)	-- 从列表删除
	local d = GetDoodad(dwID)
	if d then
		local bP, bClear, me = false, true, GetClientPlayer()
		-- 如需庖丁，则不要过滤灰色
		if AutoDood.bInteract and AutoDood.bCustom
			and AutoDood.tCustom[d.szName] and GetDoodadTemplate(d.dwTemplateID).dwCraftID == 3
		then
			_AutoDood.tDoodad[dwID] = { craft = true }
			_AutoDood.bUpdateLabel = true
			bP = true
		end
		-- money
		local nM = d.GetLootMoney() or 0
		if nM > 0 then
			LootMoney(d.dwID)
		end
		-- items
		for i = 0, 31 do
			local it, bRoll, bDist = d.GetLootItem(i, me)
			if it then
				-- 如有待分配物品，则取消庖丁并且不清空列表
				if bDist and bClear then
					bClear = false
					if bP then
						_AutoDood.Remove(dwID)
						bP = false
					end
				end
				local bLoot, szName = true, GetItemNameByItem(it)
				if bP then
					bLoot = true
				elseif AutoDood.bLootOnly then
					bLoot = AutoDood.tLootOnly[szName] == true
				elseif (it.nQuality == 0 and not AutoDood.bLootGray)
					or (it.nQuality == 1 and not AutoDood.bLootWhite)
					or (it.nQuality == 2 and not AutoDood.bLootGreen)
					or AutoDood.tLootFilter[szName] == true
				then
					bLoot = false
				end
				if bLoot then
					LootItem(d.dwID, it.dwID)
					TF.Debug("auto loot [" .. szName .. "]")
				else
					TF.Debug("filter loot [" .. szName .. "]")
				end
			end
		end
		if bClear then
			local hL = Station.Lookup("Normal/LootList", "Handle_LootList")
			if hL then
				hL:Clear()
			end
		end
	end
end

-- save manual doodad
_AutoDood.OnLootDoodad = function()
	if not AutoDood.bCustom then
		return
	end
	local d = GetDoodad(arg0)
	if not d or d.CanLoot(GetClientPlayer().dwID) then
		return
	end
	local t = GetDoodadTemplate(d.dwTemplateID)
	if t.dwCraftID >= 1 and t.dwCraftID <= 3 and not AutoDood.tCraft[d.szName] then
		for _, v in ipairs(_AutoDood.tCraft) do
			if v == d.dwTemplateID then
				AutoDood.tCraft[d.szName] = true
				return
			end
		end
		AutoDood.tCustom[d.szName] = true
	end
end

-- mini flag
_AutoDood.OnUpdateMiniFlag = function()
	if not AutoDood.bMiniFlag then return end
	local me = GetClientPlayer()
	if not me then return end
	for k, v in pairs(_AutoDood.tDoodad) do
		if not v.loot then
			local tar = GetDoodad(k)
			if not tar or (v.quest and not tar.HaveQuest(me.dwID)) then
				_AutoDood.Remove(k)
			else
				local dwType, nF1, nF2 = 5, 169, 48
				local tpl = GetDoodadTemplate(tar.dwTemplateID)
				if v.quest then
					nF1 = 114
				elseif tpl.dwCraftID == 1 then	-- 采金类
					nF1, nF2 = 16, 47
				elseif tpl.dwCraftID == 2 then	-- 神农类
					nF1 = 2
				end
				TF.UpdateMiniFlag(dwType, tar, nF1, nF2)
			end
		end
	end
end

--[[ function _AutoDood.JianTing()
--PLAYER_SAY
--arg0=喊话内容,arg1=喊话者ID,arg2=频道,arg3=喊话者名称
--	Output(arg0,arg1,arg2,arg3)		--{    [1] = "<text>text=\"我知道我知道，先生说的是竹叶青酒！\" font=10 r=255 g=150 b=0 </text>",    [2] = 1073743056,    [3] = 14,    [4] = nil,}  强度1
--	local say=GetNpc(arg1) 	
--	Output( GetNpcIntensity(say))
	if GetNpc(arg1).szName=="睿儿" then
	str=arg0
	AutoDood.QuestItem=string.match(str,"我知道我知道，先生说的是(.+)！")
	end
--Output(AutoDood.QuestItem)
end ]]

-------------------------------------
-- 头顶名称绘制
-------------------------------------
function AutoDood.OnFrameCreate()
	-- label shadow
	_AutoDood.pLabel = this:Lookup("", "Shadow_Label")
	_AutoDood.bUpdateLabel = true
	-- events
end

function AutoDood.OnFrameBreathe()
	if _AutoDood.bUpdateLabel then
		_AutoDood.bUpdateLabel = false
		_AutoDood.OnUpdateHeadName()
	end
--	_AutoDood.OnAutoDoodad()
end

function AutoDood.OnEvent(event)
end

  
 TF.AppendPlayerMenu(function()
	return {
		szOption ="开启自动拾取", bCheck = true,
		bChecked = AutoDood.bLoot,  
		fnAction = function() AutoDood.bLoot = not AutoDood.bLoot end,
		}
end)
 TF.AppendPlayerMenu(function()
	return {
		szOption ="开启自动采集", bCheck = true,
		bChecked = AutoDood.bInteract,  
		fnAction = function()  AutoDood.bInteract = not AutoDood.bInteract end,
		}
end) 
 
 
 
TF.AppendPlayerMenu( { bDevide = true }) 

-------------------------------------
-- 设置界面
-------------------------------------
_AutoDood.PS = {}

-- init
_AutoDood.PS.OnPanelActive = function(frame)
	local ui, nX = TF.UI(frame)
	-- loot
	ui:Append("Text", { txt = "拾取", x = 0, y = 0, font = 27 })
	nX = ui:Append("WndCheckBox", { txt = "开启自动拾取", x = 40, y = 0, checked = AutoDood.bLoot })
	:Click(function(bChecked)
		AutoDood.bLoot = bChecked
		ui:Fetch("Check_Fight"):Enable(bChecked)
		ui:Fetch("Combo_Filter"):Enable(bChecked)
		_AutoDood.Reload()
	end):Pos_()
	local nX1 = nX
	nX = ui:Append("WndCheckBox", "Check_Fight", { txt = "战斗中也拾取", x = 60, y = 28, checked = AutoDood.bLootFight, enable = AutoDood.bLoot })
	:Click(function(bChecked)
		AutoDood.bLootFight = bChecked
	end):Pos_()
	local nX2 = nX
	ui:Append("WndComboBox", "Combo_Filter", { txt = "设置拾取过滤", x = nX2 + 20, y = 28, enable = AutoDood.bLoot }):Menu(_AutoDood.GetFilterMenu)
	-- doodad
	ui:Append("Text", { txt = "采集", x = 0, y = 64, font = 27 })
	nX0=ui:Append("WndCheckBox", { txt = "开启自动采集", x = 40, y = 64, checked = AutoDood.bInteract })
	:Click(function(bChecked)
		AutoDood.bInteract = bChecked
	end):Pos_()
	nX = ui:Append("WndCheckBox", { txt = "显示头顶名称", x = 40, y = 92, checked = AutoDood.bShowName })
	:Click(_AutoDood.SwitchName):Pos_()
	ui:Append("Shadow", "Shadow_Color", { x = nX + 2, y = 96, w = 18, h = 18 })
	:Color(unpack(AutoDood.tNameColor)):Click(function()
		OpenColorTablePanel(function(r, g, b)
			ui:Fetch("Shadow_Color"):Color(r, g, b)
			AutoDood.tNameColor = { r, g, b }
			_AutoDood.Reload()
		end)
	end):Pos_()
	nX = ui:Append("WndCheckBox", { txt = "显示小地图标记", x = nX + 40, y = 92, checked = AutoDood.bMiniFlag })
	:Click(function(bChecked)
		AutoDood.bMiniFlag = bChecked
	end):Pos_()
	nX = ui:Append("WndCheckBox", { txt = "任务物品", x = nX0 + 40, y = 64, checked = AutoDood.bQuest })
	:Click(function(bChecked)
		AutoDood.bQuest = bChecked
		_AutoDood.Reload()
	end):Pos_()
	nX = ui:Append("WndCheckBox", { txt = "其他全部", x = nX + 10, y = 64, checked = AutoDood.bShowAll2 })
	:Click(function(bChecked)
		AutoDood.bShowAll2 = bChecked
		_AutoDood.Reload()
	end):Pos_()
	-- craft
	nX = 10
	local nY = 124
	for _, v in ipairs(_AutoDood.tCraft) do
		if v == 0 then
			nY = nY + 8
			if nX ~= 10 then
				nY = nY + 24
				nX = 10
			end
		else
			local k = _d(v)
			ui:Append("WndCheckBox", { txt = k, x = nX, y = nY, checked = AutoDood.tCraft[k] ~= nil })
			:Click(function(bChecked)
				if bChecked then
					AutoDood.tCraft[k] = true
				else
					AutoDood.tCraft[k] = nil
				end
				_AutoDood.Reload()
			end)
			nX = nX + 86
			if nX > 500 then
				nX = 10
				nY = nY + 24
			end
		end
	end
	-- custom
	nY = nY + 8
	if nX ~= 10 then
		nY = nY + 28
	end
	nX = ui:Append("WndCheckBox", { txt = "自定义 (用 | 分隔 )", x = 10, y = nY, checked = AutoDood.bCustom })
	:Click(function(bChecked)
		AutoDood.bCustom = bChecked
		ui:Fetch("Edit_Custom"):Enable(bChecked)
		_AutoDood.Reload()
	end):Pos_()
	ui:Append("WndEdit", "Edit_Custom", { x = nX + 5, y = nY, limit = 1024, h = 27, w = 280 })
	:Text(_AutoDood.GetCustomText()):Enable(AutoDood.bCustom)
	:Change(function(szText)
		local t = {}
		szText = StringReplaceW(szText, " | ", "|")
		for _, v in ipairs(TF.Split(szText, "|")) do
			v = TF.Trim(v)
			if v ~= "" then
				t[v] = true
			end
		end
		AutoDood.tCustom = t
		_AutoDood.Reload()
	end)
	ui:Append("Text", { txt = "小提示：填入动物尸体名称可以自动庖丁！", x = 10, y = nY + 28 })
end

_AutoDood.PS.OnConflictCheck  = function()
	if IsEmpty(AutoDood.tCustom) then
		--首领的战利品|散落的镖银|粮草堆|烧尾宴
		for _, v in ipairs({ 3996, 3874, 4255, 5622 }) do
			AutoDood.tCustom[_d(v)] = true
		end
	end
end

---------------------------------------------------------------------
-- 注册事件、初始化
---------------------------------------------------------------------
TF.RegisterEvent("PLAYER_ENTER_GAME", function() _AutoDood.SwitchName(AutoDood.bShowName) end)
TF.RegisterEvent("DOODAD_ENTER_SCENE", function() _AutoDood.TryAdd(arg0, true) end)
TF.RegisterEvent("DOODAD_LEAVE_SCENE", function() _AutoDood.Remove(arg0) end)
TF.RegisterEvent("OPEN_DOODAD", _AutoDood.OnLootDoodad)
--TF.RegisterEvent("PLAYER_SAY", _AutoDood.JianTing)
TF.RegisterEvent("HELP_EVENT", function()
	if arg0 == "OnOpenpanel" and arg1 == "LOOT" and AutoDood.bLoot then
		local dwOpenID =  _AutoDood.GetOpenDoodadID()
		if dwOpenID then
			_AutoDood.OnOpenDoodad(dwOpenID)
		end
	end
end)
TF.RegisterEvent("QUEST_ACCEPTED", function()
	if AutoDood.bQuest then
		_AutoDood.Reload()
	end
end)
TF.BreatheCall("AutoDoodad", _AutoDood.OnAutoDoodad)
TF.BreatheCall("UpdateMiniFlag", _AutoDood.OnUpdateMiniFlag, 500)


TF.RegisterPanel("拾取采集(HM", 6223, "自动工具", _AutoDood.PS)	
AutoDood.OnAutoDoodad = _AutoDood.OnAutoDoodad
