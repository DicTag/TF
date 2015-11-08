--
-- 海鳗插件：五毒仙王蛊鼎显示、自动吃
--

EatGuding = {
	EGTitle="[TF自动使用蛊鼎]-",
	bAutoUse = true,		-- 路过时自动吃
	nAutoMp = 80,			-- 自动吃的 MP 百分比
	nAutoHp = 80,			-- 自动吃的 HP 百分比
}
RegisterCustomData("EatGuding.bAutoUse")
RegisterCustomData("EatGuding.nAutoMp")
RegisterCustomData("EatGuding.nAutoHp")
---------------------------------------------------------------------
-- 本地函数和变量
---------------------------------------------------------------------
local _EatGuding = {
	nMaxDelay = 500,	-- 释放和出现的最大时差，单位毫秒
	nMaxTime = 60000, -- 存在的最大时间，单位毫秒
	dwSkillID = 2234,
	dwTemplateID = 2418,
	szIniFile = "interface\\TF\\EatGuding\\EatGuding.ini",
	tList = {},					-- 显示记录 (#ID => nTime)
	tCast = {},				-- 技能释放记录
	nFrame = 0,			-- 上次自动吃鼎、绘制帧次
	tBuffCache = {},
	tSkillCache = {},	
}
 
 -- debug
_EatGuding.Debug = function(szMsg)
	OutputMessage("MSG_SYS", EatGuding.EGTitle .."=== " .. szMsg .. "\n")
end 

-- add to list
_EatGuding.AddToList = function(tar, dwCaster, dwTime, szEvent)
	_EatGuding.tList[tar.dwID] = { dwCaster = dwCaster, dwTime = dwTime }
	-- bg notify
	local me = GetClientPlayer()
	if szEvent == "DO_SKILL_CAST" and me.IsInParty() then
		EatGuding.BgTalk(PLAYER_TALK_CHANNEL.RAID, "EatGuding_NOTIFY", tar.dwID, dwCaster)
	end

end

-- remove record
_EatGuding.RemoveFromList = function(dwID)
	_EatGuding.tList[dwID] = nil
end

 
EatGuding.Talk = function(nChannel, szText, bNoEmotion)
	local szTarget, me = "", GetClientPlayer()
	-- channel
	if not nChannel then
		nChannel = PLAYER_TALK_CHANNEL.NEARBY
	elseif type(nChannel) == "string" then
		if not szText then
			szText = nChannel
			nChannel = PLAYER_TALK_CHANNEL.NEARBY
		elseif type(szText) == "number" then
			szText, nChannel = nChannel, szText
		else
			szTarget = nChannel
			nChannel = PLAYER_TALK_CHANNEL.WHISPER
		end
	elseif nChannel == PLAYER_TALK_CHANNEL.RAID and me.GetScene().nType == MAP_TYPE.BATTLE_FIELD then
		nChannel = PLAYER_TALK_CHANNEL.BATTLE_FIELD
	end
	-- filter non-party talk
	if (nChannel == PLAYER_TALK_CHANNEL.RAID or nChannel == PLAYER_TALK_CHANNEL.TEAM) and not me.IsInParty() then
		return
	end
	-- say body
	me.Talk(nChannel, szTarget, szText)
end

 
EatGuding.BgTalk = function(nChannel, ...)
	local tSay = { { type = "text", text = _L["Addon comm."] } }
	local tArg = { ... }
	-- compatiable with offcial bg channel msg of team
	if nChannel == PLAYER_TALK_CHANNEL.RAID or nChannel == PLAYER_TALK_CHANNEL.TEAM then
		tSay[1].text = "BG_CHANNEL_MSG"
	end
	for _, v in ipairs(tArg) do
		if v == nil then
			break
		end
		table.insert(tSay, { type = "eventlink", name = "", linkinfo = tostring(v) })
	end
	EatGuding.Talk(nChannel, tSay, true)
end


EatGuding.BgHear = function(szKey)
	local me = GetClientPlayer()
	local tSay = me.GetTalkData()
	if tSay and arg0 ~= me.dwID and #tSay > 1 and (tSay[1].text == _L["Addon comm."] or tSay[1].text == "BG_CHANNEL_MSG") and tSay[2].type == "eventlink" then
		local tData, nOff = {}, 2
		if szKey then
			if tSay[nOff].linkinfo ~= szKey then
				return nil
			end
			nOff = nOff + 1
		end
		for i = nOff, #tSay do
			table.insert(tData, tSay[i].linkinfo)
		end
		return tData
	end
end

-------------------------------------
-- 事件处理函数
-------------------------------------
-- skill cast log
_EatGuding.OnSkillCast = function(dwCaster, dwSkillID, dwLevel, szEvent)
	local myID, player = GetClientPlayer().dwID, GetPlayer(dwCaster)
	if player and dwSkillID == _EatGuding.dwSkillID and (dwCaster == myID or  GetClientPlayer().IsPlayerInMyParty(dwCaster))  then
		table.insert(_EatGuding.tCast, { dwCaster = dwCaster, dwTime = GetTime(), szEvent = szEvent })
		--_EatGuding.Debug("[" .. player.szName .. "] cast [" .. EatGuding.GetSkillName(dwSkillID, dwLevel) .. "#" .. szEvent .. "]")
	end
end

  
-- doodad enter
_EatGuding.OnDoodadEnter = function()
	local tar = GetDoodad(arg0)
	if not tar or _EatGuding.tList[arg0] or tar.dwTemplateID ~= _EatGuding.dwTemplateID then
		return
	end
	--_EatGuding.Debug("[" .. tar.szName .. "] enter scene")
	-- find caster
	for k, v in ipairs(_EatGuding.tCast) do
		local nTime = GetTime() - v.dwTime
		--_EatGuding.Debug("checking [#" .. v.dwCaster .. "], delay [" .. nTime .. "]")
		if nTime < _EatGuding.nMaxDelay then
			table.remove(_EatGuding.tCast, k)

			_EatGuding.AddToList(tar, v.dwCaster, v.dwTime, v.szEvent)
			--return _EatGuding.Debug("matched [" .. tar.szName .. "] casted by [#" .. v.dwCaster .. "]")
		end
	end
	-- purge
	for k, v in pairs(_EatGuding.tCast) do
		if (GetTime() - v.dwTime) > _EatGuding.nMaxDelay then
			table.remove(_EatGuding.tCast, k)
		end
	end
end

-- notify
_EatGuding.OnSkillNotify = function()
	local data = EatGuding.BgHear("EatGuding_NOTIFY")
	if data then
		local dwID = tonumber(data[1])
		if not _EatGuding.tList[dwID] then
			_EatGuding.tList[dwID] = { dwCaster = tonumber(data[2]), dwTime = GetTime() }
			--_EatGuding.Debug("received notify from [#" .. data[2] .. "]")
		end
	end
end

-------------------------------------
-- 窗口函数
-------------------------------------
-- create
function EatGuding.OnFrameCreate()
	this:RegisterEvent("SYS_MSG")
	this:RegisterEvent("DO_SKILL_CAST")
	this:RegisterEvent("DOODAD_ENTER_SCENE")
	this:RegisterEvent("ON_BG_CHANNEL_MSG")
end

-- breathe
function EatGuding.OnFrameBreathe()
	if not GetClientPlayer() then return end
	-- skip frame
 	local nFrame = GetLogicFrameCount()
	if nFrame >= _EatGuding.nFrame and (nFrame - _EatGuding.nFrame) < 8 then			 
		return
	end
	_EatGuding.nFrame = nFrame 

	-- can use or not
	local bCanUse = false
	if EatGuding.bAutoUse  and not EatGuding.HasBuff(3448, false)
		and not me.bOnHorse and me.nMoveState == MOVE_STATE.ON_STAND and me.GetOTActionState() == 0
		and ((me.nCurrentMana / me.nMaxMana) <= (EatGuding.nAutoMp / 100)
			or (me.nCurrentLife / me.nMaxLife) <= (EatGuding.nAutoHp / 100))
	then
		bCanUse = true
	end

	for k, v in pairs(_EatGuding.tList) do
		local nLeft = v.dwTime + _EatGuding.nMaxTime - GetTime()
		if nLeft < 0 then
			_EatGuding.RemoveFromList(k)
		else
			local tar = GetDoodad(k)
			if tar then
				--  check to use
				if bCanUse and EatGuding.GetDistance(tar) < 6 then
					bCanUse = false
					InteractDoodad(tar.dwID)
					OutputMessage("MSG_SYS",  EatGuding.EGTitle .."自动使用蛊鼎\n")
				end
			end
		end
	end
end

EatGuding.GetSkillName = function(dwSkillID, dwLevel)
	if not _EatGuding.tSkillCache[dwSkillID] then
		local tLine = Table_GetSkill(dwSkillID, dwLevel)
		if tLine and tLine.dwSkillID > 0 and tLine.bShow
			and (StringFindW(tLine.szDesc, "_") == nil  or StringFindW(tLine.szDesc, "<") ~= nil)
		then
			_EatGuding.tSkillCache[dwSkillID] = { tLine.szName, tLine.dwIconID }
		else
			local szName = "SKILL#" .. dwSkillID
			if dwLevel then
				szName = szName .. ":" .. dwLevel
			end
			_EatGuding.tSkillCache[dwSkillID] = { szName, 13 }
		end
	end
	return unpack(_EatGuding.tSkillCache[dwSkillID])
end

EatGuding.HasBuff = function(dwBuffID, bCanCancel)
	me = GetClientPlayer()
	if me then
		local nCount = me.GetBuffCount()
		for i = 1, nCount do
			local _dwID, _nLevel, _bCanCancel = me.GetBuff(i - 1)
			if bCanCancel == nil or bCanCancel == _bCanCancel then
				if dwBuffID == _dwID
					or (type(dwBuffID) == "string" and dwBuffID == EatGuding.GetBuffName(_dwID, _nLevel))
				then
					return true
				end
			end
		end
	end
	return false
end
 
EatGuding.GetBuffName = function(dwBuffID, dwLevel)
	local xKey = dwBuffID
	if dwLevel then
		xKey = dwBuffID .. "_" .. dwLevel
	end
	if not _EatGuding.tBuffCache[xKey] then
		local tLine = Table_GetBuff(dwBuffID, dwLevel or 1)
		if tLine then
			_EatGuding.tBuffCache[xKey] = { tLine.szName, tLine.dwIconID }
		else
			local szName = "BUFF#" .. dwBuffID
			if dwLevel then
				szName = szName .. ":" .. dwLevel
			end
			_EatGuding.tBuffCache[xKey] = { szName, -1 }
		end
	end
	return unpack(_EatGuding.tBuffCache[xKey])
end

EatGuding.GetDistance = function(nX, nY, nZ)
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


-- event
function EatGuding.OnEvent(event)
	if event == "SYS_MSG" then
		if arg0 == "UI_OME_SKILL_HIT_LOG" then
			_EatGuding.OnSkillCast(arg1, arg4, arg5, arg0)
		elseif arg0 == "UI_OME_SKILL_EFFECT_LOG" then
			_EatGuding.OnSkillCast(arg1, arg5, arg6, arg0)
		end
	elseif event == "DO_SKILL_CAST" then
		_EatGuding.OnSkillCast(arg0, arg1, arg2, event)
	elseif event == "DOODAD_ENTER_SCENE" then
		_EatGuding.OnDoodadEnter()
	elseif event == "ON_BG_CHANNEL_MSG" then
		_EatGuding.OnSkillNotify()
	end
end

 
 
-------------------------------------
-- 设置界面
-------------------------------------
_EatGuding.PS = {}

-- init
_EatGuding.PS.OnPanelActive = function(frame)
	local ui = TF.UI(frame)
	-- feature
	ui:Append("WndCheckBox", "CheckBox_GdEn",{ txt ="自动吃蛊鼎 (仅站立时)", x = 5, y = nY+20, checked = EatGuding.bAutoUse}):Pos(10, 6):Click(function(bChecked)
		EatGuding.bAutoUse = bChecked
		ui:Fetch("Track_MP"):Enable(bChecked)
		ui:Fetch("Track_HP"):Enable(bChecked)
	end)
	nX = ui:Append("Text", {txt = "蓝量少于", x = 38, y = 44 }):Pos_()
	ui:Append("WndTrackBar", "Track_MP", { x = nX, y = 48, enable = EatGuding.bAutoUse })
	:Range(0, 100, 50):Value(EatGuding.nAutoMp):Change(function(nVal) EatGuding.nAutoMp = nVal end)
	nX = ui:Append("Text", { txt = "血量少于", x = 38, y = 82 }):Pos_()
	ui:Append("WndTrackBar", "Track_HP", { x = nX, y = 86, enable = EatGuding.bAutoUse })
	:Range(0, 100, 50):Value(EatGuding.nAutoHp):Change(function(nVal) EatGuding.nAutoHp = nVal end)

end

 
---------------------------------------------------------------------
-- 注册事件、初始化
---------------------------------------------------------------------
 
-- open hidden window
local frame = Station.Lookup("Lowest/EatGuding")
if frame then Wnd.CloseWindow(frame) end
Wnd.OpenWindow(_EatGuding.szIniFile, "EatGuding")

TF.RegisterPanel("自动吃鼎(HM", 2747, "自动工具", _EatGuding.PS)