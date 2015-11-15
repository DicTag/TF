-- 全局变量表
DevListIcon = {
    szTitle = "系统图标列表",
}

-- 本地变量表
local _DevListIcon = {
    nCur = 0,            -- 图标 ID 最小值
    nMax = 8009,    -- 图标 ID 最大值 6246
}

-- 获取返回作者信息
_DevListIcon.GetAuthorInfo = function()
    return "海鳗鳗@电信二区荻花宫 (v1.0b)"
end

-- 加的头像菜单列表
_DevListIcon.OnPlayerMenu = function()
    -- 菜单中点击后直接打开设置面板
    return { szOption = "查看系统图标", fnAction = function() TF.OpenPanel(DevListIcon.szTitle) end }
end

-- 冲突检测函数，首次上线时执行
_DevListIcon.OnConflictCheck = function()
    TF.Sysmsg("执行 DevListIcon 冲突检测函数 ……")
end

function _DevListIcon._ShowRes()
	local frame = Station.Lookup("Normal/DevListIcon")
	if frame then
		frame:Destroy()
	end
		frame = Wnd.OpenWindow("Interface\\TF\\DevListIcon\\DevListIcon.ini","DevListIcon")
		frame:Show() 
		frame:EnableDrag(1)
		frame:SetDragArea(0,0,1500,900)
end

DevListIcon.OnFrameKeyDown= function()
	if GetKeyName(Station.GetMessageKey()) == "Esc" then
		Station.Lookup("Normal/DevListIcon"):Destroy()
		return 1
	end
	return 0
end


-- 设置界面初始化函数
_DevListIcon.OnPanelActive = function(frame)
    -- 将设置面板窗体转换为 封装好的 TF.UI 对象
    _DevListIcon._ShowRes()
    local frame = Station.Lookup("Normal/DevListIcon")
    local ui = TF.UI(frame)
    local imgs, txts = {}, {}

    -- 在界面中添加黄色的标题文字，字体为 27 号
    nX,_=ui:Append("Text", { txt = "系统图标大全", x = 0, y = 0, font = 27 }):Pos_()
	nX,_=ui:Append("WndEdit", "Edit_Pointer", { x = nX+15, y = 0,  limit = 4, w = 50, h = 28 })
	:Text(_DevListIcon.nCur):Change(function(szText)
		_DevListIcon.nCur = tonumber(szText) or _DevListIcon.nCur or 0
        if _DevListIcon.nCur<0 then _DevListIcon.nCur=0 ui:Fetch("Edit_Pointer"):Text(0)   end
        for k, v in ipairs(imgs) do
            local i = _DevListIcon.nCur + k - 1
            if i > _DevListIcon.nMax then
                break
            end
            imgs[k]:Icon(i)
            txts[k]:Text(tostring(i))
        end
	end):Pos_()
    ui:Append("Text", { txt = "关闭", x =480, y = 0, font = 205 }):Click(function() 				 
	Station.Lookup("Normal/DevListIcon"):Destroy()
	end):Size(28,28):Pos_()

    -- 将外观设计为 每页 360个，每页 12行，每行 30个 图标
    for i = 1, 360 do
        local x = ((i - 1) % 30) * 50
        local y = math.floor((i - 1) / 30) * 70 + 40
        -- 添加一个 48x48 的图片
        imgs[i] = ui:Append("Image", { w = 48, h = 48, x = x, y = y})
        -- 在图片下方添加 48x20 的文字，居中对齐
        txts[i] = ui:Append("Text", { w = 48, h = 20, x = x, y = y + 48, align = 1 })
    end
  
    -- 在下方添加 2 个按纽
    local btn1 = ui:Append("WndButton", { txt = "上一页", x = 200, y = 0 })
    local nX, _ = btn1:Pos_()
    local btn2 = ui:Append("WndButton", { txt = "下一页", x = nX, y = 0 })
    -- 设置上一页的点击处理函数
    btn1:Click(function()
        _DevListIcon.nCur = _DevListIcon.nCur - #imgs
        if _DevListIcon.nCur <= 0 then
            _DevListIcon.nCur = 0   -- 已经是第一页，将按纽设为不可点击
            btn1:Enable(false)
        end
        -- 下一页肯定要设为可以点击
        btn2:Enable(true)
        -- 刷新图片和文字的内容
        for k, v in ipairs(imgs) do
            local i = _DevListIcon.nCur + k - 1
            if i > _DevListIcon.nMax then break end
            imgs[k]:Icon(i)
            txts[k]:Text(tostring(i))
        end
    end):Click()
    -- 设置下一页按纽的处理函数
    btn2:Click(function()
        _DevListIcon.nCur = _DevListIcon.nCur + #imgs
        if (_DevListIcon.nCur + #imgs) >= _DevListIcon.nMax then    -- 已经最后一页，将按纽设为不可点击
            btn2:Enable(false)
        end
        -- 上一页肯定要设为可以点击
        btn1:Enable(true)
        -- 刷新图片和文字的内容
        for k, v in ipairs(imgs) do
            local i = _DevListIcon.nCur + k - 1
            if i > _DevListIcon.nMax then
                break
            end
            imgs[k]:Icon(i)
            txts[k]:Text(tostring(i))
        end
    end)
end

-- 把设置界面添加到海鳗插件集，分类为“开发”，图标 ID：591，函数集合在 _DevListIcon
TF.RegisterPanel(DevListIcon.szTitle, 591, "开发工具", _DevListIcon)
