YL={
	bZoomed = false,
	bZoomed2 = false,
	bZoomed3 = false,
	bZoomedWG = false,
	fnW=0,
	fnH=0,
	mnW=0,
	mnH=0,
	nX00=0,
	nY00=0,
	nX00wg=0,
	nY00wg=0,
}
 
 
function YL.OnFrameBreathe()
	if GetLogicFrameCount() % 4 == 0  then
--[[ 		local finfo=Station.Lookup("Normal/CharInfo")
		if finfo and finfo:IsVisible() then 			
			finfo:EnableDrag(1)
			finfo:SetDragArea(0,0,80,80)	
		end ]]
		local f = Station.Lookup("Normal/ExteriorView")
		if f and f:IsVisible() then
			f:EnableDrag(1)
			f:SetDragArea(0,0,80,80)	
			YL.AddEnterButton() 	
 		end
		local f2 = Station.Lookup("Normal/CharacterPanel")   
		if f2 and f2:IsVisible() then 
			f2:BringToTop()
			f2:EnableDrag(1)
			f2:SetDragArea(0,0,80,80)			
			YL.AddEnterButton2(f2)
		end
		local fLR =Station.Lookup("Normal/LR_AS_Equip_Panel/")   
		if fLR and fLR:IsVisible() then 
			fLR:BringToTop()
		end
		local f3 = Station.Lookup("Normal/PlayerView")  
		if f3  and f3:IsVisible()then 
			f3:EnableDrag(1)
			f3:SetDragArea(0,0,80,80)
			YL.AddEnterButton2(f3)
		end
		
		local fwg=Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role")
		if fwg  and fwg:IsVisible()then 
			YL.AddEnterButtonWG()
		else
			YL.bZoomedWG = false	
		end
	end
end
Wnd.OpenWindow("Interface\\TF\\SYJZoom\\breathe.ini","YL")

function YL.AddEnterButtonWG()  
	local f=Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role")
	local btn=f:Lookup("Btn_OpenYL")
	if not btn then  
		YL.nX00wg,YL.nY00wg=f:Lookup("Scene_RewardsRole"):GetRelPos()
	end
	local szFile="Interface\\TF\\SYJZoom\\YL.ini"
	local tips=GetFormatText("放大/还原\n", 101) .. GetFormatText("系统自带放大镜为半身像，可先缩小\n被超大头像吓到概不负责。。", 106)
	TF.AddEnterButton(f,"Btn_OpenYL",szFile,"WndBtn_Zoom",538,558,tips, YL.sZoomWG)
	local m=f:Lookup("Scene_RewardsRole")
	local tips=GetFormatText("上移,非开发版上移模型会消失\n", 101) 
	TF.AddEnterButton(f,"Btn_UM",szFile,"WndBtn_UM",540,530,tips,function() YL.sMove(m,0,-50) end )   
 	local tips=GetFormatText("下移\n", 101) 
	TF.AddEnterButton(f,"Btn_DM",szFile,"WndBtn_DM",540,590,tips,function() YL.sMove(m,0,50) end )  	
end

function YL.AddEnterButton2(frame)  
	local frame2 = Station.Lookup("Normal/CharacterPanel")
	local frame3 = Station.Lookup("Normal/PlayerView")	
	local btn=frame:Lookup("Btn_OpenYL")		 
	if not btn then    
		fff=frame:Lookup("Page_Main/Page_Battle")	  	
		local ui = TF.UI(fff)   
		ui:Append("Text", { txt ="拖", font = 224 , x = 8, y = 10 ,alpha=200}) 	
	end
	local szFile="Interface\\TF\\SYJZoom\\YL.ini"
	local tips=GetFormatText("放大/还原\n", 101)
	TF.AddEnterButton(frame,"Btn_OpenYL",szFile,"WndBtn_Zoom",233,88,tips, function() if frame==frame2 then  YL.sZoom2() elseif frame==frame3 then  YL.sZoom3() end  end )
end

function YL.AddEnterButton()  	
		local f=Station.Lookup("Normal/ExteriorView")
		local btn=f:Lookup("Btn_OpenYL")
		if not btn then  
			YL.fnW,YL.fnH=f:GetSize()
			YL.mnW,YL.mnH=f:Lookup("Scene_Role"):GetSize()
			YL.nX00,YL.nY00=f:Lookup("Scene_Role"):GetRelPos()
			local ui = TF.UI(f)
			ui:Append("Text", { txt ="拖", font = 224 , x = 8, y = 10 ,alpha=200}) 			
		end
		local szFile="Interface\\TF\\SYJZoom\\YL.ini"
		local tips=GetFormatText("放大/还原\n", 101) .. GetFormatText("放大后，人物模型上仍可用鼠标滚轮放大缩小", 106)
		TF.AddEnterButton(f,"Btn_OpenYL",szFile,"WndBtn_Zoom",288,38,tips, YL.sZoom)
		local m=f:Lookup("Scene_Role")
		local tips=GetFormatText("右移\n", 101) 
		TF.AddEnterButton(f,"Btn_RM",szFile,"WndBtn_RM",318,40,tips,function() YL.sMove(m,30,0) end )   
 		local tips=GetFormatText("左移\n", 101) 
		TF.AddEnterButton(f,"Btn_LM",szFile,"WndBtn_LM",258,40,tips,function() YL.sMove(m,-30,0) end )  
 		local tips=GetFormatText("上移,非开发版上移模型会消失\n", 101) 		
		TF.AddEnterButton(f,"Btn_UM",szFile,"WndBtn_UM",290,10,tips,function() YL.sMove(m,0,-30) end )  
 		local tips=GetFormatText("下移\n", 101) 
		TF.AddEnterButton(f,"Btn_DM",szFile,"WndBtn_DM",290,70,tips,function() YL.sMove(m,0,30) end )  		
end

function YL.sMove(m,nX,nY)
	local nX0,nY0=m:GetAbsPos()
	m:SetAbsPos(nX0+nX,nY0+nY)
end

function YL.sZoomWG()
	local f = Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role")	
	local model= f:Lookup("Scene_RewardsRole")
	if YL.bZoomedWG==false then 
		model:Scale(1.8,1.8)
		local nX0,nY0=model:GetAbsPos()     
		model:SetAbsPos(nX0-250,nY0-230)		--开发版320
		model:BringToTop()
		Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role/Btn_UM"):BringToTop()
		Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role/Btn_DM"):BringToTop()
		Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role/Btn_OpenYL"):BringToTop()
		Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role/Btn_RoleZoomOut"):BringToTop()	
		Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role/Btn_RoleZoomIn"):BringToTop()
			Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role/Btn_RoleTurnRight"):BringToTop()		
			Station.Lookup("Normal/CoinShop/PageSet_Total/Page_Shop/Wnd_ShopView/PageSet_View/Page_Role/Btn_RoleTurnLeft"):BringToTop()			
		YL.bZoomedWG=true
	else				
		model:Scale(1/1.8,1/1.8)
		model:SetRelPos(YL.nX00wg,YL.nY00wg)
		YL.bZoomedWG=false
	end
end

function YL.sZoom2()
	local f=Station.Lookup("Normal/CharacterPanel")
	if YL.bZoomed2==false then 
		f:Scale(2.2,2.2)  
		YL.bZoomed2=true
		f:BringToTop()
		else				
		f:Scale(1/2.2,1/2.2)		
		YL.bZoomed2=false
	end
end
 
function YL.sZoom3()
	local f = Station.Lookup("Normal/PlayerView")	
	if YL.bZoomed3==false then 
		f:Scale(2.2,2.2)
		YL.bZoomed3=true
	else				
		f:Scale(1/2.2,1/2.2)		
		YL.bZoomed3=false
	end
end

function YL.sZoom()
	local f=Station.Lookup("Normal/ExteriorView")
	local model= f:Lookup("Scene_Role")
	if YL.bZoomed==false then   
		f:SetSize(YL.fnW*4,YL.fnH*4) 
		model:SetSize(YL.mnW*4,YL.mnH*4)	  	 
		local nX0,nY0=model:GetAbsPos()      	 
		model:SetAbsPos(nX0+100,nY0-210)  	 --开发版300
		YL.bZoomed=true             	 
	else				
		f:SetSize(YL.fnW,YL.fnH)	
		model:SetSize(YL.mnW,YL.mnH)		
		model:SetRelPos(YL.nX00,YL.nY00)
		YL.bZoomed=false
	end
end
 
 

-------------------------------------
-- 设置界面
-------------------------------------
_YL={}
_YL.PS = {}

-- init
_YL.PS.OnPanelActive = function(frame)
	local ui = TF.UI(frame)
	-- feature
	_,nY=ui:Append("Text", { txt =  "【功能说明】" , x = 0, y = 0, }):Pos_()		
	_,nY=ui:Append("Text", { txt =  "【1】Alt预览装备增加放大镜" , x = 0, y = nY+20, }):Pos_()
	_,nY=ui:Append("Text", { txt =  "【2】C角色增加放大镜" , x = 0, y = nY+12, }):Pos_()
	_,nY=ui:Append("Text", { txt =  "【3】观察其他角色装备面板，增加放大镜" , x = 0, y = nY+12, }):Pos_()
	_,nY=ui:Append("Text", { txt =  "【4】外观商城辅助放大，看发型时可看全身效果" , x = 0, y = nY+12, }):Pos_()
--	ui:Append("Text", { txt =  "By 微雨凭阑" , x = 340, y =340, font = 205 })
end

 
---------------------------------------------------------------------
-- 注册事件、初始化
---------------------------------------------------------------------
-- add to TF panel
TF.RegisterPanel("试衣间放大镜", "interface//TF//SYJZoom//YLIcon.jpg", "界面增强", _YL.PS) --4190
