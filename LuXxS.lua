--[[ luxxs v5.5 | DrHub | MM2 | Aimbot + AutoWin + Skins + Mannequin Preview ]]
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local HttpService=game:GetService("HttpService")
local VU=game:GetService("VirtualUser")
local LP=Players.LocalPlayer

local FOLDER="luxxs"
local TELEGRAM_LINK="https://t.me/NurHuboffical"
local hasFS=type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function"
local function ensureFolder() if type(makefolder)=="function" and type(isfolder)=="function" and not isfolder(FOLDER) then pcall(makefolder,FOLDER) end end

local IS_TOUCH = UIS.TouchEnabled == true
local function isMobile() return IS_TOUCH or (UIS.KeyboardEnabled==false and UIS.MouseEnabled==false) end

-- THEME
local ACCENTS={Lime=Color3.fromRGB(196,255,61),Coral=Color3.fromRGB(255,104,84),Ice=Color3.fromRGB(110,214,255),Violet=Color3.fromRGB(158,110,255),Gold=Color3.fromRGB(255,196,70),Rose=Color3.fromRGB(255,96,160)}
local ACCENT_NAMES={"Lime","Coral","Ice","Violet","Gold","Rose"}
local ACC_NAME="Lime"
if hasFS then pcall(function() local p=FOLDER.."/accent.txt"; if isfile(p) then local n=readfile(p); if ACCENTS[n] then ACC_NAME=n end end end) end
local ACC=ACCENTS[ACC_NAME]

local C={bg=Color3.fromRGB(11,11,14),panel=Color3.fromRGB(16,16,20),row=Color3.fromRGB(24,24,30),line=Color3.fromRGB(40,40,48),off=Color3.fromRGB(58,58,68),text=Color3.fromRGB(232,232,226),dim=Color3.fromRGB(122,122,136)}
local WHITE=Color3.fromRGB(255,255,255)
local AIM_RED=Color3.fromRGB(255,64,64)
local BODY_GRAY=Color3.fromRGB(196,196,206)
local F_HEAD,F_BODY,F_MONO,F_SEC=Enum.Font.Michroma,Enum.Font.SourceSansSemibold,Enum.Font.RobotoMono,Enum.Font.Oswald

local themed={}
local function T(o,p,fn) themed[#themed+1]={o,p,fn}; o[p]=fn and fn(ACC) or ACC end
local function setAccent(c) ACC=c; for _,t in ipairs(themed) do pcall(function() t[1][t[2]]=t[3] and t[3](ACC) or ACC end) end end

local PALETTE={Lime=ACCENTS.Lime,Coral=ACCENTS.Coral,Ice=ACCENTS.Ice,Violet=ACCENTS.Violet,Gold=ACCENTS.Gold,Red=Color3.fromRGB(255,60,60),Green=Color3.fromRGB(70,230,110),Blue=Color3.fromRGB(70,110,255),Pink=Color3.fromRGB(255,110,200),White=Color3.fromRGB(255,255,255)}
local COLOR_NAMES={"Rainbow","Lime","Coral","Ice","Violet","Gold","Red","Green","Blue","Pink","White"}
local WING_COLORS={"White","Gold","Rainbow","Ice","Violet","Pink","Coral"}
local ROLE_COLORS={Murderer=Color3.fromRGB(255,60,60),Sheriff=Color3.fromRGB(70,130,255),Innocent=Color3.fromRGB(70,230,110)}
local ROLE_NAMES={"Murderer","Sheriff","Innocent"}
local HAT_COLORS={"Custom","Rainbow","Lime","Coral","Ice","Violet","Gold","Red","Green","Blue","Pink","White"}
local QB_POSITIONS={"Left","Right","Bottom","Top","Left-Top","Left-Bottom","Right-Top","Right-Bottom"}
local SCREEN_RATIOS={"Default","16:9","16:10","4:3","21:9","1:1"}

_G.LUXXS_HAT_H=280; _G.LUXXS_HAT_S=0.7; _G.LUXXS_HAT_V=1

local function getColor(n,t,o)
    if n=="Rainbow" then return Color3.fromHSV((((t or 0)*0.2)+(o or 0))%1,0.85,1) end
    if n=="Custom" then return Color3.fromHSV(((_G.LUXXS_HAT_H%360)/360),math.clamp(_G.LUXXS_HAT_S,0,1),math.clamp(_G.LUXXS_HAT_V,0,1)) end
    return PALETTE[n] or ACC
end

local connections={} local function track(c) connections[#connections+1]=c; return c end
local function tween(o,ti,p,s,d) local tw=TweenService:Create(o,TweenInfo.new(ti,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),p); tw:Play(); return tw end
local function corner(o,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=o; return c end
local function stroke(o,col,th,tr) local s=Instance.new("UIStroke"); s.Color=col; s.Thickness=th or 1; s.Transparency=tr or 0; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=o; return s end
local function gradient(f,rot,seq,tseq)
    local g=Instance.new("UIGradient"); g.Rotation=rot or 0
    if seq then g.Color=seq end
    if tseq then g.Transparency=tseq end
    g.Parent=f; return g
end

local GradRefresh={}
local Flags,Setters,Defaults={},{},{} local function register(k,d,s) Flags[k]=d; Defaults[k]=d; Setters[k]=s end

local gui=Instance.new("ScreenGui")
gui.Name="luxxs"; gui.ResetOnSpawn=false; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.IgnoreGuiInset=true
local okP,parent=pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
if not okP or not parent then parent=LP:WaitForChild("PlayerGui") end
if parent:FindFirstChild("luxxs") then parent.luxxs:Destroy() end
if parent:FindFirstChild("luxxsKey") then parent.luxxsKey:Destroy() end
if parent:FindFirstChild("luxxsFPS") then parent.luxxsFPS:Destroy() end
gui.Parent=parent

for _,e in ipairs(Lighting:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("DepthOfFieldEffect") then
        pcall(function() e.Enabled=false end)
    end
    if e.Name:sub(1,6)=="luxxs_" then
        pcall(function() e:Destroy() end)
    end
end

print("[luxxs] v5.5 loaded")

-- ============ ЗАГРУЗОЧНЫЙ ЭКРАН ============
do
    local sg=Instance.new("ScreenGui"); sg.Name="luxxsKey"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.DisplayOrder=999; sg.Parent=parent
    local root=Instance.new("CanvasGroup"); root.Size=UDim2.new(1,0,1,0); root.BackgroundTransparency=1; root.BorderSizePixel=0; root.Parent=sg
    do
        local bgf=Instance.new("Frame"); bgf.Size=UDim2.new(1,0,1,0); bgf.BackgroundColor3=WHITE; bgf.BorderSizePixel=0; bgf.ZIndex=0; bgf.Parent=root
        gradient(bgf,90,ColorSequence.new(Color3.fromRGB(22,22,28),Color3.fromRGB(8,8,10)))
    end
    local function hair(y) local f=Instance.new("Frame"); f.Position=UDim2.new(0,0,y,0); f.Size=UDim2.new(1,0,0,1); f.BorderSizePixel=0; f.BackgroundTransparency=0.85; f.Parent=root; T(f,"BackgroundColor3") end
    hair(0.1) hair(0.9)
    local function ctext(txt,ax,px)
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.AnchorPoint=Vector2.new(ax,0); l.Position=UDim2.new(px,ax==0 and 18 or -18,0.1,8); l.Size=UDim2.new(0,220,0,16); l.Font=F_MONO; l.TextSize=11; l.TextColor3=C.dim; l.TextXAlignment=ax==0 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right; l.Text=txt; l.Parent=root
    end
    ctext("LUXXS // LOADING",0,0) ctext("DRHUB",1,1)

    local word="LUXXS"; local LW=62; local total=LW*#word
    local holder=Instance.new("Frame"); holder.AnchorPoint=Vector2.new(0.5,0.5); holder.Position=UDim2.new(0.5,0,0.36,0); holder.Size=UDim2.new(0,total,0,84); holder.BackgroundTransparency=1; holder.ClipsDescendants=true; holder.Parent=root
    local letters={}
    for i=1,#word do
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(0,LW,0,84); l.Position=UDim2.new(0,(i-1)*LW,0,98); l.Font=F_HEAD; l.TextSize=52; l.Text=word:sub(i,i); l.TextColor3=C.text; l.Parent=holder
        letters[i]=l
    end
    local ul=Instance.new("Frame"); ul.AnchorPoint=Vector2.new(0.5,0); ul.Position=UDim2.new(0.5,0,0.36,52); ul.Size=UDim2.new(0,0,0,2); ul.BorderSizePixel=0; ul.Parent=root; T(ul,"BackgroundColor3")

    local statusLbl=Instance.new("TextLabel"); statusLbl.BackgroundTransparency=1; statusLbl.AnchorPoint=Vector2.new(0.5,0); statusLbl.Position=UDim2.new(0.5,0,0.58,0); statusLbl.Size=UDim2.new(0,400,0,18); statusLbl.Font=F_MONO; statusLbl.TextSize=13; statusLbl.TextColor3=C.dim; statusLbl.Text="INITIALIZING"; statusLbl.TextTransparency=1; statusLbl.Parent=root

    local barBg=Instance.new("Frame"); barBg.AnchorPoint=Vector2.new(0.5,0); barBg.Position=UDim2.new(0.5,0,0.64,0); barBg.Size=UDim2.new(0,320,0,3); barBg.BackgroundColor3=C.off; barBg.BorderSizePixel=0; barBg.Parent=root; corner(barBg,2)
    local barFill=Instance.new("Frame"); barFill.Size=UDim2.new(0,0,1,0); barFill.BorderSizePixel=0; barFill.Parent=barBg; corner(barFill,2); T(barFill,"BackgroundColor3")

    local subLbl=Instance.new("TextLabel"); subLbl.BackgroundTransparency=1; subLbl.AnchorPoint=Vector2.new(0.5,0); subLbl.Position=UDim2.new(0.5,0,0.66,6); subLbl.Size=UDim2.new(0,400,0,16); subLbl.Font=F_MONO; subLbl.TextSize=11; subLbl.TextColor3=C.dim; subLbl.Text=""; subLbl.TextTransparency=1; subLbl.Parent=root

    task.spawn(function()
        task.wait(0.2)
        for i,l in ipairs(letters) do tween(l,0.7,{Position=UDim2.new(0,(i-1)*LW,0,0)}); task.wait(0.08) end
        task.wait(0.25); tween(ul,0.6,{Size=UDim2.new(0,total,0,2)})
        task.wait(0.3); tween(statusLbl,0.35,{TextTransparency=0}); tween(subLbl,0.35,{TextTransparency=0})
        local steps={
            {t=0.15,txt="Checking integrity...",sub="verifying files"},
            {t=0.4,txt="Loading modules...",sub="drhub core"},
            {t=0.65,txt="Connecting...",sub="t.me/NurHuboffical"},
            {t=0.9,txt="Almost ready...",sub="preparing UI"},
            {t=1.0,txt="Access granted",sub="welcome, "..LP.Name}
        }
        for _,s in ipairs(steps) do
            statusLbl.Text=s.txt
            subLbl.Text=s.sub
            tween(barFill,0.35,{Size=UDim2.new(s.t,0,1,0)})
            task.wait(0.35)
        end
        T(statusLbl,"TextColor3")
        task.wait(0.4)
        tween(root,0.5,{GroupTransparency=1})
        task.wait(0.55)
        sg:Destroy()
    end)
end

task.wait(3.5)
print("[luxxs] loading done, building UI")

local function notify(text)
    local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(1,1); f.Size=UDim2.new(0,250,0,34); f.Position=UDim2.new(1,280,1,-20); f.BackgroundColor3=C.panel; f.BorderSizePixel=0; f.ZIndex=20; f.Parent=gui; stroke(f,C.line,1,0)
    local bar=Instance.new("Frame"); bar.Size=UDim2.new(0,3,1,0); bar.BorderSizePixel=0; bar.BackgroundColor3=ACC; bar.ZIndex=21; bar.Parent=f
    local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(1,-20,1,0); l.Position=UDim2.new(0,14,0,0); l.Font=F_MONO; l.TextSize=12; l.TextColor3=C.text; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=text; l.ZIndex=21; l.Parent=f
    tween(f,0.4,{Position=UDim2.new(1,-20,1,-20)})
    task.delay(2.6,function() tween(f,0.3,{Position=UDim2.new(1,280,1,-20)},Enum.EasingStyle.Quint,Enum.EasingDirection.In); task.delay(0.35,function() f:Destroy() end) end)
end

local function makeDraggable(handle,target,onClick)
    local dragging,startPos,startInput,moved=false,nil,nil,false
    local conn1
    conn1=handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; moved=false; startInput=input.Position; startPos=target.Position
            local c2
            c2=input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false; c2:Disconnect(); if not moved and onClick then onClick() end end end)
        end
    end)
    track(conn1)
    track(UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-startInput
            if delta.Magnitude>5 then moved=true end
            if moved then tween(target,0.08,{Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)},Enum.EasingStyle.Linear) end
        end
    end))
end

-- COSMETICS
local Cos={}
local function destroyCos(n) if Cos[n] then for _,o in ipairs(Cos[n].objs) do pcall(function() o:Destroy() end) end Cos[n]=nil end end
local function newPart(sz,p) local pt=Instance.new("Part"); pt.Size=sz; pt.CanCollide=false; pt.CanQuery=false; pt.CanTouch=false; pt.Massless=true; pt.Anchored=false; pt.Parent=p; return pt end

local function buildWings()
    destroyCos("wings")
    local char=LP.Character; local torso=char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")); if not torso then return end
    local model=Instance.new("Model"); model.Name="luxxsWings"; local feathers={}
    for _,side in ipairs({-1,1}) do for i=1,6 do
        local len=4.2-i*0.35
        local p=newPart(Vector3.new(len,0.5,0.08),model); p.Material=Enum.Material.Neon
        local w=Instance.new("Weld"); w.Part0=torso; w.Part1=p; w.Parent=p
        feathers[#feathers+1]={part=p,weld=w,side=side,i=i,len=len}
    end end
    model.Parent=char; Cos.wings={objs={model},model=model,feathers=feathers}
end

local hatRebuildAt=0
local function scheduleHatRebuild() hatRebuildAt=os.clock()+0.3 end

local function buildHat()
    destroyCos("hat")
    local char=LP.Character
    local head=char and char:FindFirstChild("Head")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not head then return end

    local size=(Flags["Visuals/Hat Size"] or 100)/100
    local height=(Flags["Visuals/Hat Height"] or 100)/100
    local level=Flags["Visuals/Keep Level"]
    if level==nil then level=true end

    local anchorPart=head
    local base=Vector3.new(0,0,0)
    if level and root then
        anchorPart=root
        base=root.CFrame:PointToObjectSpace(head.Position)
    end

    local model=Instance.new("Model")
    model.Name="luxxsHat"
    local slices={}
    local N=72
    local R=2.4*size
    local totalH=1.7*height
    local step=totalH/N
    local startY=0.52
    for i=1,N do
        local k=(i-1)/(N-1)
        local r=math.max(R*(1-k),0.04)
        local p=newPart(Vector3.new(step*1.8,r*2,r*2),model)
        p.Shape=Enum.PartType.Cylinder
        p.Material=Enum.Material.SmoothPlastic
        p.CastShadow=false
        local w=Instance.new("Weld")
        w.Part0=anchorPart
        w.Part1=p
        w.C0=CFrame.new(base+Vector3.new(0,startY+(i-1)*step,0))*CFrame.Angles(0,0,math.pi/2)
        w.Parent=p
        slices[i]=p
    end
    model.Parent=char
    Cos.hat={objs={model},model=model,slices=slices}
end

local function buildTrail()
    destroyCos("trail")
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local a0=Instance.new("Attachment"); a0.Name="luxxsA0"; a0.Parent=hrp
    local a1=Instance.new("Attachment"); a1.Name="luxxsA1"; a1.Parent=hrp
    local tr=Instance.new("Trail"); tr.Attachment0=a0; tr.Attachment1=a1; tr.LightEmission=1; tr.FaceCamera=true
    tr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(1,1)}); tr.Parent=hrp
    Cos.trail={objs={a0,a1,tr},a0=a0,a1=a1,trail=tr}
end

local function colorSeq(name,t)
    if name=="Rainbow" then local kp={} for k=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(k/6,getColor(name,t,-k/6*0.8)) end return ColorSequence.new(kp) end
    return ColorSequence.new(getColor(name))
end

track(RunService.Heartbeat:Connect(function()
    local t=os.clock()
    local w=Cos.wings
    if w and w.model.Parent then
        local flap=math.sin(t*(Flags["Visuals/Wing Speed"] or 3))*0.2
        for _,f in ipairs(w.feathers) do
            local a=math.rad(10+f.i*12)+flap*(0.5+f.i*0.12)
            local theta=(f.side==1) and a or (math.pi-a)
            f.weld.C0=CFrame.new(f.side*0.5,0.45,0.6)*CFrame.Angles(0,f.side*-0.35,0)*CFrame.Angles(0,0,theta)*CFrame.new(f.len/2,0,0)
            f.part.Color=getColor(Flags["Visuals/Wing Color"],t,f.i*0.05)
        end
    end
    local h=Cos.hat
    if h and h.model.Parent then local htr=(Flags["Visuals/Hat Transparency"] or 35)/100; for i,sl in ipairs(h.slices) do sl.Color=getColor(Flags["Visuals/Hat Color"],t,i*0.008); sl.Transparency=htr end end
    local tr=Cos.trail
    if tr and tr.trail.Parent then
        local width=(Flags["Visuals/Trail Width"] or 4)*0.4
        tr.a0.Position=Vector3.new(0,width/2,0); tr.a1.Position=Vector3.new(0,-width/2,0)
        tr.trail.Lifetime=math.max(0.1,(Flags["Visuals/Trail Length"] or 10)/10); tr.trail.Color=colorSeq(Flags["Visuals/Trail Color"],t)
    end
end))

local enableFlyMove
track(LP.CharacterAdded:Connect(function(c)
    c:WaitForChild("HumanoidRootPart",10); c:WaitForChild("Head",10); task.wait(0.3)
    if Flags["Visuals/Wings"] then buildWings() end
    if Flags["Visuals/Chinese Hat"] then buildHat() end
    if Flags["Visuals/Trail"] then buildTrail() end
    if Flags["Move/Fly"] and enableFlyMove then enableFlyMove() end
end))

-- SCREEN RATIO
local ScreenRes={Bars={}}
do
    local barsFolder=Instance.new("Frame"); barsFolder.Name="luxxsScreenBars"; barsFolder.Size=UDim2.new(1,0,1,0); barsFolder.BackgroundTransparency=1; barsFolder.ZIndex=0; barsFolder.Parent=gui
    local topBar=Instance.new("Frame"); topBar.Position=UDim2.new(0,0,0,0); topBar.Size=UDim2.new(1,0,0,0); topBar.BackgroundColor3=Color3.new(0,0,0); topBar.BorderSizePixel=0; topBar.ZIndex=0; topBar.Parent=barsFolder
    local botBar=Instance.new("Frame"); botBar.AnchorPoint=Vector2.new(0,1); botBar.Position=UDim2.new(0,0,1,0); botBar.Size=UDim2.new(1,0,0,0); botBar.BackgroundColor3=Color3.new(0,0,0); botBar.BorderSizePixel=0; botBar.ZIndex=0; botBar.Parent=barsFolder
    ScreenRes.Bars={top=topBar,bot=botBar,folder=barsFolder}
    local RATIOS={["16:9"]=16/9,["16:10"]=16/10,["4:3"]=4/3,["21:9"]=21/9,["1:1"]=1.0}
    function ScreenRes.apply(mode,animate)
        local cam=workspace.CurrentCamera; if not cam then return end
        local vp=cam.ViewportSize
        local ti=animate and 0.35 or 0.001
        if mode=="Default" then
            tween(ScreenRes.Bars.top,ti,{Size=UDim2.new(1,0,0,0)})
            tween(ScreenRes.Bars.bot,ti,{Size=UDim2.new(1,0,0,0)})
            return
        end
        local targetRatio=RATIOS[mode]
        if not targetRatio then return end
        local currentRatio=vp.X/vp.Y
        local barH=0
        if currentRatio>targetRatio then
            local targetH=vp.X/targetRatio
            barH=(vp.Y-targetH)/2
        end
        if barH<0 then barH=0 end
        tween(ScreenRes.Bars.top,ti,{Size=UDim2.new(1,0,0,barH)})
        tween(ScreenRes.Bars.bot,ti,{Size=UDim2.new(1,0,0,barH)})
    end
end

-- WINDOW
local W,H=972,460
local main=Instance.new("CanvasGroup")
main.AnchorPoint=Vector2.new(0.5,0.5); main.Position=UDim2.new(0.5,0,0.5,0); main.Size=UDim2.new(0,W,0,H)
main.BackgroundColor3=C.bg; main.BorderSizePixel=0; main.GroupTransparency=1; main.Visible=false; main.Parent=gui
corner(main,16); T(stroke(main,ACC,1.5,0.35),"Color"); main.BackgroundColor3=Color3.fromRGB(12,11,17)
do local bgF=Instance.new("Frame"); bgF.Size=UDim2.new(1,0,1,0); bgF.BackgroundColor3=WHITE; bgF.BorderSizePixel=0; bgF.ZIndex=0; bgF.Parent=main; gradient(bgF,125,ColorSequence.new(Color3.fromRGB(24,19,36),Color3.fromRGB(10,10,14))) end
local scale=Instance.new("UIScale"); scale.Scale=0.9; scale.Parent=main

local top=Instance.new("Frame"); top.Size=UDim2.new(1,0,0,44); top.BackgroundColor3=WHITE; top.BorderSizePixel=0; top.Parent=main; gradient(top,0,ColorSequence.new(Color3.fromRGB(34,26,48),Color3.fromRGB(15,15,21)))
do
local topLine=Instance.new("Frame"); topLine.Position=UDim2.new(0,0,1,-1); topLine.Size=UDim2.new(1,0,0,1); topLine.BackgroundColor3=C.line; topLine.BorderSizePixel=0; topLine.Parent=top
local mark=Instance.new("Frame"); mark.Position=UDim2.new(0,16,0,18); mark.Size=UDim2.new(0,8,0,8); mark.Rotation=45; mark.BorderSizePixel=0; mark.Parent=top; T(mark,"BackgroundColor3")
local title=Instance.new("TextLabel"); title.BackgroundTransparency=1; title.Position=UDim2.new(0,34,0,0); title.Size=UDim2.new(0,90,1,0); title.Font=F_HEAD; title.TextSize=15; title.TextXAlignment=Enum.TextXAlignment.Left; title.TextColor3=C.text; title.Text="LUXXS"; title.Parent=top
local sub=Instance.new("TextLabel"); sub.BackgroundTransparency=1; sub.Position=UDim2.new(0,130,0,2); sub.Size=UDim2.new(0,120,1,0); sub.Font=F_MONO; sub.TextSize=11; sub.TextXAlignment=Enum.TextXAlignment.Left; sub.TextColor3=C.dim; sub.Text="by DrHub"; sub.Parent=top
local ver=Instance.new("TextLabel"); ver.BackgroundTransparency=1; ver.AnchorPoint=Vector2.new(1,0); ver.Position=UDim2.new(1,-52,0,0); ver.Size=UDim2.new(0,160,1,0); ver.Font=F_MONO; ver.TextSize=11; ver.TextXAlignment=Enum.TextXAlignment.Right; ver.TextColor3=C.dim; ver.Text="v5.5 // MM2"; ver.Parent=top
end
local closeBtn=Instance.new("TextButton"); closeBtn.AnchorPoint=Vector2.new(1,0.5); closeBtn.Position=UDim2.new(1,-10,0.5,0); closeBtn.Size=UDim2.new(0,28,0,28); closeBtn.BackgroundColor3=C.row; closeBtn.BorderSizePixel=0; closeBtn.Text="X"; closeBtn.Font=F_MONO; closeBtn.TextSize=13; closeBtn.TextColor3=C.dim; closeBtn.AutoButtonColor=false; closeBtn.Parent=top

local side=Instance.new("Frame"); side.Position=UDim2.new(0,0,0,44); side.Size=UDim2.new(0,150,0,H-44-24); side.BackgroundColor3=C.panel; side.BorderSizePixel=0; side.Parent=main
do
local sideLine=Instance.new("Frame"); sideLine.Position=UDim2.new(1,-1,0,0); sideLine.Size=UDim2.new(0,1,1,0); sideLine.BackgroundColor3=C.line; sideLine.BorderSizePixel=0; sideLine.Parent=side
end
local sideList=Instance.new("Frame"); sideList.BackgroundTransparency=1; sideList.Position=UDim2.new(0,0,0,12); sideList.Size=UDim2.new(1,-1,1,-12); sideList.Parent=side
local indicator=Instance.new("Frame"); indicator.Size=UDim2.new(0,2,0,22); indicator.Position=UDim2.new(0,0,0,18); indicator.BorderSizePixel=0; indicator.ZIndex=3; indicator.Parent=side; T(indicator,"BackgroundColor3")

local foot=Instance.new("Frame"); foot.Position=UDim2.new(0,0,1,-24); foot.Size=UDim2.new(1,0,0,24); foot.BackgroundColor3=C.panel; foot.BorderSizePixel=0; foot.Parent=main
do
local footLine=Instance.new("Frame"); footLine.Size=UDim2.new(1,0,0,1); footLine.BackgroundColor3=C.line; footLine.BorderSizePixel=0; footLine.Parent=foot
local footL=Instance.new("TextLabel"); footL.BackgroundTransparency=1; footL.Position=UDim2.new(0,14,0,0); footL.Size=UDim2.new(0.6,0,1,0); footL.Font=F_MONO; footL.TextSize=10; footL.TextXAlignment=Enum.TextXAlignment.Left; footL.TextColor3=C.dim; footL.Text="RIGHTSHIFT = TOGGLE   |   t.me/NurHuboffical"; footL.Parent=foot
end
local footR=Instance.new("TextLabel"); footR.BackgroundTransparency=1; footR.AnchorPoint=Vector2.new(1,0); footR.Position=UDim2.new(1,-14,0,0); footR.Size=UDim2.new(0.4,0,1,0); footR.Font=F_MONO; footR.TextSize=10; footR.TextXAlignment=Enum.TextXAlignment.Right; footR.TextColor3=C.dim; footR.Text="ROLE  INNOCENT"; footR.Parent=foot

local pages=Instance.new("Frame"); pages.BackgroundTransparency=1; pages.Position=UDim2.new(0,162,0,54); pages.Size=UDim2.new(0,542,0,H-24-54-10); pages.ClipsDescendants=true; pages.Parent=main

-- =========================================================================
-- MANNEQUIN PREVIEW PANEL
-- =========================================================================
local previewPanel=Instance.new("Frame"); previewPanel.Position=UDim2.new(0,712,0,54); previewPanel.Size=UDim2.new(0,252,0,372); previewPanel.BorderSizePixel=0; previewPanel.BackgroundColor3=C.panel; previewPanel.Parent=main
corner(previewPanel,12); T(stroke(previewPanel,ACC,1,0.55),"Color")

local prevHeader=Instance.new("TextLabel"); prevHeader.BackgroundTransparency=1; prevHeader.Position=UDim2.new(0,12,0,8); prevHeader.Size=UDim2.new(1,-24,0,16); prevHeader.Font=F_MONO; prevHeader.TextSize=11; prevHeader.TextColor3=C.dim; prevHeader.TextXAlignment=Enum.TextXAlignment.Left; prevHeader.Text="PREVIEW"; prevHeader.Parent=previewPanel

local Man={parts={},wingFrames={}}
do
    local holder=Instance.new("Frame"); holder.Position=UDim2.new(0,10,0,30); holder.Size=UDim2.new(1,-20,0,170); holder.BackgroundColor3=C.bg; holder.BorderSizePixel=0; holder.Parent=previewPanel
    corner(holder,8); stroke(holder,C.line,1,0.5)
    Man.holder=holder

    local SCALE=0.78
    local originX=math.floor((232 - 78*SCALE)/2)
    local originY=10

    local BODY=Color3.fromRGB(196,196,206)
    local BODY_DARK=Color3.fromRGB(150,150,162)

    local function mkPart(d,color,isHead)
        local f=Instance.new("Frame")
        f.Position=UDim2.new(0,originX+d.x*SCALE,0,originY+d.y*SCALE)
        f.Size=UDim2.new(0,d.w*SCALE,0,d.h*SCALE)
        f.BackgroundColor3=color or BODY
        f.BorderSizePixel=0
        f.ZIndex=3
        f.Parent=holder
        if isHead then corner(f,d.r*SCALE) else corner(f,math.min(d.r*SCALE,4)) end
        return f
    end
    Man.parts.head=mkPart({x=33,y=12,w=24,h=24,r=12},BODY,true)
    Man.parts.chest=mkPart({x=27,y=43,w=36,h=30,r=4},BODY)
    Man.parts.stomach=mkPart({x=30,y=73,w=30,h=30,r=3},BODY_DARK)
    Man.parts.larm=mkPart({x=12,y=45,w=13,h=60,r=5},BODY)
    Man.parts.rarm=mkPart({x=65,y=45,w=13,h=60,r=5},BODY)
    Man.parts.lleg=mkPart({x=25,y=104,w=18,h=62,r=5},BODY)
    Man.parts.rleg=mkPart({x=47,y=104,w=18,h=62,r=5},BODY)

    local wingL=Instance.new("Frame"); wingL.BackgroundTransparency=1; wingL.Size=UDim2.new(0,80,0,60); wingL.Position=UDim2.new(0,originX-64*SCALE,0,originY+30*SCALE); wingL.ZIndex=2; wingL.Parent=holder
    local wingR=Instance.new("Frame"); wingR.BackgroundTransparency=1; wingR.Size=UDim2.new(0,80,0,60); wingR.Position=UDim2.new(0,originX+64*SCALE,0,originY+30*SCALE); wingR.ZIndex=2; wingR.Parent=holder
    Man.wingL=wingL; Man.wingR=wingR

    local hatF=Instance.new("Frame"); hatF.BackgroundTransparency=1; hatF.Size=UDim2.new(0,90,0,50); hatF.Position=UDim2.new(0,originX-6,0,originY-14); hatF.ZIndex=4; hatF.Parent=holder
    Man.hat=hatF

    local trailF=Instance.new("Frame"); trailF.BackgroundTransparency=1; trailF.Size=UDim2.new(1,0,0,16); trailF.Position=UDim2.new(0,0,1,-18); trailF.ZIndex=2; trailF.Parent=holder
    Man.trail=trailF; Man.trailBars={}
    for i=1,5 do
        local b=Instance.new("Frame"); b.AnchorPoint=Vector2.new(0,0.5); b.Position=UDim2.new(0,i*14,0.5,0); b.Size=UDim2.new(0,10,0,3); b.BorderSizePixel=0; b.Parent=trailF; corner(b,2); Man.trailBars[i]=b
    end
end

local function mkInfo(y,txt,sz,col)
    local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Position=UDim2.new(0,12,0,y); l.Size=UDim2.new(1,-24,0,sz or 14); l.Font=F_MONO; l.TextSize=(sz or 14)-3; l.TextColor3=col or C.dim; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=txt; l.Parent=previewPanel; return l
end
local prevRole=mkInfo(210,"ROLE: --",16,C.text)
local prevRoleDot=Instance.new("Frame"); prevRoleDot.Position=UDim2.new(1,-26,0,214); prevRoleDot.Size=UDim2.new(0,10,0,10); prevRoleDot.BorderSizePixel=0; prevRoleDot.Parent=previewPanel; corner(prevRoleDot,5); T(prevRoleDot,"BackgroundColor3")
local prevSkin=mkInfo(232,"SKIN K/G: -- / --",13)
local prevHat=mkInfo(250,"HAT: OFF",13)
local prevWings=mkInfo(268,"WINGS: OFF",13)
local prevTrail=mkInfo(286,"TRAIL: OFF",13)
local prevESP=mkInfo(308,"ESP: OFF",12)
local prevFPS=mkInfo(326,"FPS: --",12)
local prevStatus=mkInfo(344,"STATUS: READY",12)

-- mannequin cosmetics rebuilders
local function rebuildWings()
    for _,f in ipairs(Man.wingFrames) do pcall(function() f:Destroy() end) end
    Man.wingFrames={}
    local col=getColor(Flags["Visuals/Wing Color"] or "White",os.clock(),0)
    for _,cont in ipairs({Man.wingL,Man.wingR}) do
        for i=1,5 do
            local len=(5.5-i*0.7)*8
            local f=Instance.new("Frame")
            f.Position=UDim2.new(0, i*4, 0, i*6)
            f.Size=UDim2.new(0,len,0,3)
            f.BackgroundColor3=col
            f.BorderSizePixel=0
            f.ZIndex=2
            f.Visible=Flags["Visuals/Wings"] and true or false
            f.Parent=cont
            corner(f,2)
            Man.wingFrames[#Man.wingFrames+1]=f
        end
    end
end
local function rebuildHat()
    for _,c in ipairs(Man.hat:GetChildren()) do c:Destroy() end
    if not Flags["Visuals/Chinese Hat"] then return end
    local col=getColor(Flags["Visuals/Hat Color"] or "Custom",os.clock(),0)
    local baseY=44
    for i=1,8 do
        local k=(i-1)/7
        local w=70*(1-k)+6
        local f=Instance.new("Frame")
        f.AnchorPoint=Vector2.new(0.5,0)
        f.Position=UDim2.new(0.5,0,0,baseY - i*3)
        f.Size=UDim2.new(0,w,0,3)
        f.BackgroundColor3=col
        f.BackgroundTransparency=(Flags["Visuals/Hat Transparency"] or 35)/100
        f.BorderSizePixel=0
        f.ZIndex=4
        f.Parent=Man.hat
        corner(f,2)
    end
end

local prevTick=0
local prevHue=0
track(RunService.Heartbeat:Connect(function(dt)
    prevTick=prevTick+dt
    if prevTick<0.2 then return end
    prevTick=0
    if not main.Visible then return end

    prevHue=prevHue+0.01

    rebuildWings()
    rebuildHat()

    local wingColor=Flags["Visuals/Wing Color"] or "White"
    for i,f in ipairs(Man.wingFrames) do
        f.BackgroundColor3=getColor(wingColor,prevHue,i*0.08)
        f.Visible=Flags["Visuals/Wings"] and true or false
    end

    local trailOn=Flags["Visuals/Trail"]
    local trailCol=getColor(Flags["Visuals/Trail Color"] or "Lime",prevHue,0)
    for i,b in ipairs(Man.trailBars) do
        b.Visible=trailOn
        b.BackgroundColor3=trailCol
        b.BackgroundTransparency=1-(i/#Man.trailBars)*0.8
    end

    local role="Innocent"
    if getRoleCached then role=getRoleCached(LP) end
    local rcol=ROLE_COLORS[role] or BODY_GRAY
    for _,p in pairs(Man.parts) do
        p.BackgroundColor3=p.BackgroundColor3:Lerp(rcol,0.08)
    end

    prevRole.Text="ROLE: "..string.upper(role)
    prevRole.TextColor3=rcol
    prevRoleDot.BackgroundColor3=rcol

    local kn=Flags["Skins/Knife Skin"] or "Off"
    local gn=Flags["Skins/Gun Skin"] or "Off"
    prevSkin.Text="SKIN K/G: "..kn.." / "..gn
    prevHat.Text="HAT: "..((Flags["Visuals/Chinese Hat"] and (Flags["Visuals/Hat Color"] or "On")) or "OFF")
    prevWings.Text="WINGS: "..((Flags["Visuals/Wings"] and (Flags["Visuals/Wing Color"] or "On")) or "OFF")
    prevTrail.Text="TRAIL: "..((Flags["Visuals/Trail"] and (Flags["Visuals/Trail Color"] or "On")) or "OFF")

    local bits={}
    if Flags["Visuals/ESP Box"] then bits[#bits+1]="BOX" end
    if Flags["Visuals/Name"] then bits[#bits+1]="NAME" end
    if Flags["Visuals/Role"] then bits[#bits+1]="ROLE" end
    if Flags["Visuals/Health"] then bits[#bits+1]="HP" end
    if Flags["Visuals/Distance"] then bits[#bits+1]="DIST" end
    if Flags["Visuals/Skeleton"] then bits[#bits+1]="SKEL" end
    if Flags["Visuals/Chams"] then bits[#bits+1]="CHAM" end
    prevESP.Text="ESP: "..(#bits>0 and table.concat(bits," ") or "OFF")

    local st="READY"
    if AutoWin and AutoWin.Enabled then st="AUTOWIN: "..AutoWin.Status
    elseif Farm and Farm.Enabled then st="FARM: "..Farm.Status
    elseif Flags["Aimbot/Enable"] then st="AIMBOT" end
    prevStatus.Text="STATUS: "..st
    prevFPS.Text="FPS: "..math.floor(1/math.max(dt,0.0001))
end))

-- =========================================================================
-- TAB BUILDER
-- =========================================================================
local tabs,currentTab,switching={},nil,false

local function restyleTabs()
    for _,t in ipairs(tabs) do
        local on=(t==currentTab)
        t.nm.TextColor3=on and C.text or C.dim
        t.num.TextColor3=on and ACC or C.dim
        t.button.BackgroundColor3=on and ACC or C.row; t.button.BackgroundTransparency=on and 0.82 or 1
    end
end

local function selectTab(tab)
    if currentTab==tab or switching then return end
    switching=true; local old=currentTab; currentTab=tab
    tween(indicator,0.3,{Position=UDim2.new(0,0,0,18+tab.index*36)})
    restyleTabs()
    if old then tween(old.page,0.15,{GroupTransparency=1}); task.delay(0.15,function() old.page.Visible=false end) end
    task.delay(old and 0.12 or 0,function()
        tab.page.GroupTransparency=1; tab.page.Visible=true
        tween(tab.page,0.25,{GroupTransparency=0})
        task.delay(0.25,function() switching=false end)
    end)
end

local function hairline(parent,y)
    local f=Instance.new("Frame"); f.Position=UDim2.new(0,0,1,y or -1); f.Size=UDim2.new(1,0,0,1); f.BackgroundColor3=C.line; f.BackgroundTransparency=1; f.BorderSizePixel=0; f.Parent=parent; return f
end

local function createTab(name)
    local index=#tabs
    local button=Instance.new("TextButton"); button.Size=UDim2.new(1,-16,0,34); button.Position=UDim2.new(0,8,0,index*36+6); button.BackgroundColor3=C.row; button.BackgroundTransparency=1; button.BorderSizePixel=0; button.Text=""; button.AutoButtonColor=false; button.Parent=sideList; corner(button,8)
    local num=Instance.new("TextLabel"); num.BackgroundTransparency=1; num.Position=UDim2.new(0,16,0,0); num.Size=UDim2.new(0,24,1,0); num.Font=F_MONO; num.TextSize=11; num.TextXAlignment=Enum.TextXAlignment.Left; num.TextColor3=C.dim; num.Text=string.format("%02d",index+1); num.Parent=button
    local nm=Instance.new("TextLabel"); nm.BackgroundTransparency=1; nm.Position=UDim2.new(0,46,0,0); nm.Size=UDim2.new(1,-50,1,0); nm.Font=F_SEC; nm.TextSize=16; nm.TextXAlignment=Enum.TextXAlignment.Left; nm.TextColor3=C.dim; nm.Text=string.upper(name); nm.Parent=button

    local page=Instance.new("CanvasGroup"); page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1; page.Visible=false; page.GroupTransparency=1; page.Parent=pages
    local scroll=Instance.new("ScrollingFrame"); scroll.Size=UDim2.new(1,0,1,0); scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=2; scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.Parent=page
    T(scroll,"ScrollBarImageColor3")
    local function mkCol(xs,xo) local f=Instance.new("Frame"); f.BackgroundTransparency=1; f.Position=UDim2.new(xs,xo,0,0); f.Size=UDim2.new(0.5,-4,0,0); f.AutomaticSize=Enum.AutomaticSize.Y; f.Parent=scroll; local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,2); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=f; return f end
    local colL=mkCol(0,0); local colR=mkCol(0.5,4)
    local hL,hR=0,0
    local COLH=H-24-54-10-12
    local function slot(h)
        if hL+h<=COLH then hL=hL+h+2; return colL end
        if hR+h<=COLH then hR=hR+h+2; return colR end
        if hR<hL then hR=hR+h+2; return colR end
        hL=hL+h+2; return colL
    end
    local pad=Instance.new("UIPadding"); pad.PaddingRight=UDim.new(0,8); pad.PaddingTop=UDim.new(0,2); pad.PaddingBottom=UDim.new(0,10); pad.Parent=scroll

    local tab={button=button,page=page,scroll=scroll,index=index,name=name,num=num,nm=nm}; table.insert(tabs,tab)
    button.MouseButton1Click:Connect(function() selectTab(tab) end)
    button.MouseEnter:Connect(function() if currentTab~=tab then tween(nm,0.15,{TextColor3=C.text}) end end)
    button.MouseLeave:Connect(function() if currentTab~=tab then tween(nm,0.15,{TextColor3=C.dim}) end end)

    function tab:Label(text)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,30); f.BackgroundTransparency=1; f.Parent=slot(30)
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Position=UDim2.new(0,0,0,6); l.Size=UDim2.new(1,0,0,18); l.Font=F_SEC; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextColor3=C.dim; l.Text=string.upper(text); l.Parent=f
        hairline(f,-3)
        local ac=Instance.new("Frame"); ac.Position=UDim2.new(0,0,1,-3); ac.Size=UDim2.new(0,28,0,1); ac.BorderSizePixel=0; ac.Parent=f; T(ac,"BackgroundColor3")
    end

    function tab:Label2(text,font,size,color)
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,0,(#text>36) and 28 or 18); l.TextWrapped=true; l.BackgroundTransparency=1; l.Font=font or F_MONO; l.TextSize=size or 11; l.TextColor3=color or C.dim; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=text; l.Parent=slot(l.Size.Y.Offset)
        return l
    end

    function tab:Frame(h) local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,h); f.BackgroundTransparency=1; f.Parent=slot(h); return f end

    function tab:Toggle(text,default,callback)
        local key=name.."/"..text; local state=default or false
        local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.BorderSizePixel=0; row.AutoButtonColor=false; row.Text=""; row.Parent=slot(34)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,0); lbl.Size=UDim2.new(1,-60,1,0); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local box=Instance.new("Frame"); box.AnchorPoint=Vector2.new(1,0.5); box.Position=UDim2.new(1,-10,0.5,0); box.Size=UDim2.new(0,36,0,18); box.BackgroundColor3=state and ACC or C.off; box.BorderSizePixel=0; box.Parent=row; corner(box,9)
        T(box,"BackgroundColor3",function(a) return state and a or C.off end)
        local inner=Instance.new("Frame"); inner.AnchorPoint=Vector2.new(0,0.5); inner.Position=UDim2.new(0,state and 20 or 2,0.5,0); inner.Size=UDim2.new(0,14,0,14); inner.BackgroundColor3=WHITE; inner.BorderSizePixel=0; inner.Parent=box; corner(inner,7)
        local function paint() tween(box,0.18,{BackgroundColor3=state and ACC or C.off}); tween(inner,0.18,{Position=UDim2.new(0,state and 20 or 2,0.5,0)}) end
        register(key,state,function(v)
            state=v and true or false; Flags[key]=state; paint()
            if callback then task.spawn(callback,state) end
        end)
        row.MouseButton1Click:Connect(function() Setters[key](not state) end)
        row.MouseEnter:Connect(function() tween(row,0.12,{BackgroundTransparency=0.3}) end)
        row.MouseLeave:Connect(function() tween(row,0.12,{BackgroundTransparency=0.55}) end)
    end

    function tab:Button(text,callback)
        local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,0,0,38); wrap.BackgroundTransparency=1; wrap.Parent=slot(38)
        local b=Instance.new("TextButton"); b.Position=UDim2.new(0,10,0,4); b.Size=UDim2.new(1,-20,0,30); b.BackgroundColor3=ACC; b.BackgroundTransparency=0.88; corner(b,8); b.BorderSizePixel=0; b.AutoButtonColor=false; b.Font=F_MONO; b.TextSize=12; b.Text=string.upper(text); b.Parent=wrap
        T(b,"TextColor3"); local bs=stroke(b,ACC,1,0.4); T(bs,"Color")
        b.MouseEnter:Connect(function() b.BackgroundColor3=ACC; tween(b,0.12,{BackgroundTransparency=0}); b.TextColor3=C.bg end)
        b.MouseLeave:Connect(function() tween(b,0.12,{BackgroundTransparency=0.88}); b.TextColor3=ACC end)
        b.MouseButton1Click:Connect(function() if callback then task.spawn(callback) end end)
    end

    function tab:Input(text,default,callback)
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,38); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.Parent=slot(38)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,0); lbl.Size=UDim2.new(0.5,-10,1,0); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local boxF=Instance.new("Frame"); boxF.AnchorPoint=Vector2.new(1,0.5); boxF.Position=UDim2.new(1,-10,0.5,0); boxF.Size=UDim2.new(0.5,-10,0,26); boxF.BackgroundColor3=C.bg; boxF.BorderSizePixel=0; boxF.Parent=row
        local bs=stroke(boxF,ACC,1,0.4); T(bs,"Color")
        local tb=Instance.new("TextBox"); tb.BackgroundTransparency=1; tb.Size=UDim2.new(1,-12,1,0); tb.Position=UDim2.new(0,6,0,0); tb.Font=F_MONO; tb.TextSize=13; tb.TextColor3=C.text; tb.PlaceholderColor3=C.dim; tb.PlaceholderText="value"; tb.Text=tostring(default or ""); tb.ClearTextOnFocus=false; tb.TextXAlignment=Enum.TextXAlignment.Center; tb.Parent=boxF
        tb.FocusLost:Connect(function(enter) if callback then task.spawn(callback,tb.Text,tb) end end)
        return tb
    end

    function tab:Slider(text,min,max,default,callback,gradFn)
        local key=name.."/"..text; local value=default or min
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,46); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.Parent=slot(46)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,4); lbl.Size=UDim2.new(0.6,0,0,20); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local val=Instance.new("TextLabel"); val.BackgroundTransparency=1; val.AnchorPoint=Vector2.new(1,0); val.Position=UDim2.new(1,-10,0,4); val.Size=UDim2.new(0,100,0,20); val.Font=F_MONO; val.TextSize=13; val.TextXAlignment=Enum.TextXAlignment.Right; val.Text=tostring(value); val.Parent=row; T(val,"TextColor3")
        local bar=Instance.new("Frame"); bar.Position=UDim2.new(0,10,0,33); bar.Size=UDim2.new(1,-20,0,5); bar.BackgroundColor3=C.off; bar.BorderSizePixel=0; bar.Parent=row
        local fill=Instance.new("Frame"); fill.Size=UDim2.new((value-min)/(max-min),0,1,0); fill.BorderSizePixel=0; fill.Parent=bar; T(fill,"BackgroundColor3")
        local gradObj
        if gradFn then
            bar.Size=UDim2.new(1,-20,0,8); bar.Position=UDim2.new(0,10,0,31); bar.BackgroundColor3=WHITE; fill.BackgroundTransparency=1
            gradObj=Instance.new("UIGradient"); gradObj.Color=gradFn(); gradObj.Parent=bar
            GradRefresh[key]=function() gradObj.Color=gradFn() end
        end
        local knob=Instance.new("Frame"); knob.AnchorPoint=Vector2.new(0.5,0.5); knob.Position=UDim2.new((value-min)/(max-min),0,0.5,0); knob.Size=UDim2.new(0,14,0,14); knob.BackgroundColor3=WHITE; knob.BorderSizePixel=0; knob.ZIndex=3; knob.Parent=bar; corner(bar,3); corner(fill,3); corner(knob,7); T(stroke(knob,ACC,2,0),"Color")
        register(key,value,function(v)
            v=math.clamp(math.floor((tonumber(v) or min)+0.5),min,max); value=v; Flags[key]=v
            val.Text=tostring(v)
            local r=(v-min)/(max-min)
            fill.Size=UDim2.new(r,0,1,0); knob.Position=UDim2.new(r,0,0.5,0)
            if callback then task.spawn(callback,v) end
        end)
        local hit=Instance.new("TextButton"); hit.BackgroundTransparency=1; hit.Text=""; hit.Position=UDim2.new(0,0,0,22); hit.Size=UDim2.new(1,0,0,24); hit.Parent=row
        local sliding=false
        local function update(x) local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1); Setters[key](min+(max-min)*rel) end
        hit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true; scroll.ScrollingEnabled=false; update(i.Position.X) end end)
        track(UIS.InputEnded:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then sliding=false; scroll.ScrollingEnabled=true end end))
        track(UIS.InputChanged:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then update(i.Position.X) end end))
    end

    function tab:Choice(text,options,default,callback)
        local key=name.."/"..text; local idx=table.find(options,default) or 1
        local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.BorderSizePixel=0; row.AutoButtonColor=false; row.Text=""; row.Parent=slot(34)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,0); lbl.Size=UDim2.new(0.5,-10,1,0); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local val=Instance.new("TextLabel"); val.BackgroundTransparency=1; val.AnchorPoint=Vector2.new(1,0); val.Position=UDim2.new(1,-10,0,0); val.Size=UDim2.new(0.5,-10,1,0); val.Font=F_MONO; val.TextSize=13; val.TextXAlignment=Enum.TextXAlignment.Right; val.Text="< "..options[idx].." >"; val.Parent=row; T(val,"TextColor3")
        register(key,options[idx],function(v)
            local i=table.find(options,v); if not i then return end
            idx=i; Flags[key]=options[i]; val.Text="< "..options[i].." >"
            if callback then task.spawn(callback,options[i]) end
        end)
        row.MouseButton1Click:Connect(function() Setters[key](options[idx%#options+1]) end)
        row.MouseButton2Click:Connect(function() Setters[key](options[(idx-2)%#options+1]) end)
        row.MouseEnter:Connect(function() tween(row,0.12,{BackgroundTransparency=0.3}) end)
        row.MouseLeave:Connect(function() tween(row,0.12,{BackgroundTransparency=0.55}) end)
    end

    function tab:List(text,items,default,callback)
        local key=name.."/"..text
        local lf=Instance.new("Frame"); lf.Size=UDim2.new(1,0,0,180); lf.BackgroundTransparency=1; lf.Parent=slot(180)
        local header=Instance.new("TextLabel"); header.BackgroundTransparency=1; header.Position=UDim2.new(0,0,0,0); header.Size=UDim2.new(1,0,0,16); header.Font=F_SEC; header.TextSize=13; header.TextXAlignment=Enum.TextXAlignment.Left; header.TextColor3=C.text; header.Text=string.upper(text); header.Parent=lf
        local sf=Instance.new("ScrollingFrame"); sf.Position=UDim2.new(0,0,0,18); sf.Size=UDim2.new(1,0,1,-18); sf.BackgroundColor3=C.row; sf.BackgroundTransparency=0.45; sf.BorderSizePixel=0; sf.ScrollBarThickness=3; sf.CanvasSize=UDim2.new(0,0,0,#items*28+10); sf.Parent=lf
        corner(sf,8); T(sf,"ScrollBarImageColor3")
        local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,2); ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Parent=sf
        local pd=Instance.new("UIPadding"); pd.PaddingTop=UDim.new(0,4); pd.PaddingLeft=UDim.new(0,4); pd.PaddingRight=UDim.new(0,6); pd.PaddingBottom=UDim.new(0,4); pd.Parent=sf
        local btns={}
        local current=default or items[1]
        local function paint()
            for n,b in pairs(btns) do
                local on=(n==current)
                b.BackgroundColor3=on and ACC or C.bg
                b.BackgroundTransparency=on and 0.55 or 0.45
                b.TextColor3=on and C.text or C.dim
            end
        end
        register(key,current,function(v)
            current=v; Flags[key]=v; paint()
            if callback then task.spawn(callback,v) end
        end)
        for i,name in ipairs(items) do
            local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,26); b.BorderSizePixel=0; b.AutoButtonColor=false; b.Font=F_BODY; b.TextSize=14
            b.TextXAlignment=Enum.TextXAlignment.Left; b.Text="  "..name; b.LayoutOrder=i; b.Parent=sf; corner(b,6)
            b.MouseButton1Click:Connect(function() Setters[key](name) end)
            b.MouseEnter:Connect(function() if name~=current then b.BackgroundTransparency=0.15 end end)
            b.MouseLeave:Connect(function() if name~=current then b.BackgroundTransparency=0.45 end end)
            btns[name]=b
        end
        paint()
    end
    return tab
end

local function fitScale() local cam=workspace.CurrentCamera; local vp=cam and cam.ViewportSize or Vector2.new(1280,720); return math.min(1,(vp.X-20)/W,(vp.Y-20)/H) end
local isOpen,busy=false,false
local MenuAlpha=0.94
local MenuScale=1

local function openMenu()
    if busy or isOpen then return end
    busy=true; isOpen=true
    main.Visible=true
    local fit=fitScale(); scale.Scale=fit*0.94*MenuScale; main.GroupTransparency=1
    tween(scale,0.35,{Scale=fit*MenuScale}); tween(main,0.3,{GroupTransparency=1-MenuAlpha})
    task.delay(0.35,function() busy=false end)
end

local function closeMenu()
    if busy or not isOpen then return end
    busy=true; isOpen=false
    tween(scale,0.25,{Scale=fitScale()*0.94*MenuScale},Enum.EasingStyle.Quint,Enum.EasingDirection.In); tween(main,0.25,{GroupTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.In)
    task.delay(0.26,function() main.Visible=false; busy=false end)
end

local function toggleMenu() if isOpen then closeMenu() else openMenu() end end

closeBtn.MouseButton1Click:Connect(closeMenu)
closeBtn.MouseEnter:Connect(function() tween(closeBtn,0.12,{BackgroundColor3=Color3.fromRGB(190,56,56)}); closeBtn.TextColor3=WHITE end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn,0.12,{BackgroundColor3=C.row}); closeBtn.TextColor3=C.dim end)

-- QUICKBAR
local setQuickBarVisible,applyQbPosition
do
local QuickBar=Instance.new("CanvasGroup")
QuickBar.AnchorPoint=Vector2.new(0,0.5)
QuickBar.Position=UDim2.new(0,24,0.5,0)
QuickBar.Size=UDim2.new(0,80,0,0)
QuickBar.AutomaticSize=Enum.AutomaticSize.Y
QuickBar.BackgroundColor3=C.bg
QuickBar.BackgroundTransparency=0.1
QuickBar.GroupTransparency=1
QuickBar.BorderSizePixel=0
QuickBar.ZIndex=6
QuickBar.Visible=false
QuickBar.Parent=gui
corner(QuickBar,14)
local qbStroke=stroke(QuickBar,ACC,1.5,0.35); T(qbStroke,"Color")

local qbHandle=Instance.new("Frame")
qbHandle.Size=UDim2.new(1,0,0,16)
qbHandle.BackgroundColor3=WHITE
qbHandle.BackgroundTransparency=0.9
qbHandle.BorderSizePixel=0
qbHandle.ZIndex=8
qbHandle.Parent=QuickBar
corner(qbHandle,8)
local qbHandleBar=Instance.new("Frame")
qbHandleBar.AnchorPoint=Vector2.new(0.5,0.5)
qbHandleBar.Position=UDim2.new(0.5,0,0.5,0)
qbHandleBar.Size=UDim2.new(0,30,0,3)
qbHandleBar.BackgroundColor3=WHITE
qbHandleBar.BackgroundTransparency=0.35
qbHandleBar.BorderSizePixel=0
qbHandleBar.ZIndex=9
qbHandleBar.Parent=qbHandle
corner(qbHandleBar,3)

local qbLayout=Instance.new("UIListLayout")
qbLayout.Padding=UDim.new(0,4)
qbLayout.SortOrder=Enum.SortOrder.LayoutOrder
qbLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
qbLayout.Parent=QuickBar

local qbPad=Instance.new("UIPadding")
qbPad.PaddingTop=UDim.new(0,20)
qbPad.PaddingBottom=UDim.new(0,8)
qbPad.PaddingLeft=UDim.new(0,7)
qbPad.PaddingRight=UDim.new(0,7)
qbPad.Parent=QuickBar

local qbToggle=Instance.new("TextButton")
qbToggle.Size=UDim2.new(0,22,0,44)
qbToggle.BackgroundColor3=C.bg
qbToggle.BackgroundTransparency=0.15
qbToggle.BorderSizePixel=0
qbToggle.Text="‹"
qbToggle.Font=F_MONO
qbToggle.TextSize=18
qbToggle.TextColor3=C.text
qbToggle.AutoButtonColor=false
qbToggle.ZIndex=7
qbToggle.Visible=false
qbToggle.Parent=gui
corner(qbToggle,10)
stroke(qbToggle,C.line,1,0.3)

local qbPositions={
    ["Left"]=function() QuickBar.AnchorPoint=Vector2.new(0,0.5); QuickBar.Position=UDim2.new(0,24,0.5,0); qbToggle.AnchorPoint=Vector2.new(0,0.5); qbToggle.Position=UDim2.new(0,4,0.5,0) end,
    ["Right"]=function() QuickBar.AnchorPoint=Vector2.new(1,0.5); QuickBar.Position=UDim2.new(1,-24,0.5,0); qbToggle.AnchorPoint=Vector2.new(1,0.5); qbToggle.Position=UDim2.new(1,-4,0.5,0) end,
    ["Bottom"]=function() QuickBar.AnchorPoint=Vector2.new(0.5,1); QuickBar.Position=UDim2.new(0.5,0,1,-24); qbToggle.AnchorPoint=Vector2.new(0.5,1); qbToggle.Position=UDim2.new(0.5,0,1,-4) end,
    ["Top"]=function() QuickBar.AnchorPoint=Vector2.new(0.5,0); QuickBar.Position=UDim2.new(0.5,0,0,24); qbToggle.AnchorPoint=Vector2.new(0.5,0); qbToggle.Position=UDim2.new(0.5,0,0,4) end,
    ["Left-Top"]=function() QuickBar.AnchorPoint=Vector2.new(0,0); QuickBar.Position=UDim2.new(0,24,0,80); qbToggle.AnchorPoint=Vector2.new(0,0); qbToggle.Position=UDim2.new(0,4,0,80) end,
    ["Left-Bottom"]=function() QuickBar.AnchorPoint=Vector2.new(0,1); QuickBar.Position=UDim2.new(0,24,1,-80); qbToggle.AnchorPoint=Vector2.new(0,1); qbToggle.Position=UDim2.new(0,4,1,-80) end,
    ["Right-Top"]=function() QuickBar.AnchorPoint=Vector2.new(1,0); QuickBar.Position=UDim2.new(1,-24,0,80); qbToggle.AnchorPoint=Vector2.new(1,0); qbToggle.Position=UDim2.new(1,-4,0,80) end,
    ["Right-Bottom"]=function() QuickBar.AnchorPoint=Vector2.new(1,1); QuickBar.Position=UDim2.new(1,-24,1,-80); qbToggle.AnchorPoint=Vector2.new(1,1); qbToggle.Position=UDim2.new(1,-4,1,-80) end,
}
local currentQbPos="Left"
local qbEnabled,qbExpanded=false,false
local qbShown=UDim2.new(0,24,0.5,0)
local qbToken=0
local qbAnimUntil=0

local function qbArrowFor(pos,expanded)
    local d
    if pos:find("Left") then d="L" elseif pos:find("Right") then d="R" elseif pos=="Top" then d="T" else d="B" end
    local closeArrow={L="‹",R="›",T="▲",B="▼"}
    local openArrow={L="›",R="‹",T="▼",B="▲"}
    return expanded and closeArrow[d] or openArrow[d]
end
local function qbSetArrow() qbToggle.Text=qbArrowFor(currentQbPos,qbExpanded) end

local function qbHiddenFrom(p)
    local o=140
    if currentQbPos:find("Left") then return UDim2.new(p.X.Scale,p.X.Offset-o,p.Y.Scale,p.Y.Offset)
    elseif currentQbPos:find("Right") then return UDim2.new(p.X.Scale,p.X.Offset+o,p.Y.Scale,p.Y.Offset)
    elseif currentQbPos=="Top" then return UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset-o)
    else return UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset+o) end
end

local function qbPop()
    local s=qbToggle.Size
    qbToggle.Size=UDim2.new(0,s.X.Offset-6,0,s.Y.Offset)
    tween(qbToggle,0.35,{Size=UDim2.new(0,22,0,44)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
end

local function qbExpand()
    qbToken+=1
    qbExpanded=true
    QuickBar.Visible=true
    if QuickBar.GroupTransparency>0.95 then QuickBar.Position=qbHiddenFrom(qbShown) end
    qbAnimUntil=os.clock()+0.55
    tween(QuickBar,0.5,{Position=qbShown,GroupTransparency=0},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    qbSetArrow(); qbPop()
end

local function qbCollapse()
    qbToken+=1
    local my=qbToken
    if qbExpanded and os.clock()>qbAnimUntil then qbShown=QuickBar.Position end
    qbExpanded=false
    tween(QuickBar,0.4,{Position=qbHiddenFrom(qbShown),GroupTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.In)
    qbSetArrow(); qbPop()
    task.delay(0.42,function()
        if qbToken==my and not qbExpanded then QuickBar.Visible=false end
    end)
end

function applyQbPosition(pos,animate)
    if not qbPositions[pos] then pos="Left" end
    currentQbPos=pos
    qbPositions[pos]()
    qbShown=QuickBar.Position
    qbSetArrow()
    if not qbEnabled then
        QuickBar.Position=qbHiddenFrom(qbShown)
        return
    end
    if qbExpanded then
        if animate then
            QuickBar.Position=qbHiddenFrom(qbShown)
            qbAnimUntil=os.clock()+0.55
            tween(QuickBar,0.45,{Position=qbShown},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        end
    else
        QuickBar.Position=qbHiddenFrom(qbShown)
    end
end

function setQuickBarVisible(on)
    on=on and true or false
    if qbEnabled==on then return end
    qbEnabled=on
    if on then
        qbPositions[currentQbPos]()
        qbShown=QuickBar.Position
        qbToggle.Visible=true
        qbToggle.BackgroundTransparency=1
        tween(qbToggle,0.4,{BackgroundTransparency=0.15},Enum.EasingStyle.Quint)
        qbExpand()
    else
        qbCollapse()
        tween(qbToggle,0.35,{BackgroundTransparency=1},Enum.EasingStyle.Quint)
        task.delay(0.45,function()
            if not qbEnabled then qbToggle.Visible=false end
        end)
    end
end

makeDraggable(qbHandle,QuickBar,nil)

qbToggle.MouseButton1Click:Connect(function()
    if not qbEnabled then return end
    if qbExpanded then qbCollapse() else qbExpand() end
end)
qbToggle.MouseEnter:Connect(function() tween(qbToggle,0.15,{BackgroundTransparency=0}) end)
qbToggle.MouseLeave:Connect(function() if qbEnabled then tween(qbToggle,0.15,{BackgroundTransparency=0.15}) end end)

local quickButtons={}
local function makeQuickButton(label,flagKey,iconText,action)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,0,0,42)
    b.BackgroundColor3=C.row
    b.BackgroundTransparency=0.4
    b.BorderSizePixel=0
    b.AutoButtonColor=false
    b.Font=F_MONO
    b.TextSize=11
    b.TextColor3=C.dim
    b.Text=iconText or label
    b.LayoutOrder=#quickButtons+1
    b.Parent=QuickBar
    corner(b,9)
    local bs=stroke(b,C.line,1,0.4)
    local function paint()
        if action then
            b.BackgroundColor3=C.row; b.BackgroundTransparency=0.4; b.TextColor3=C.dim; bs.Transparency=0.4
            return
        end
        local on=Flags[flagKey]
        b.BackgroundColor3=on and ACC or C.row
        b.BackgroundTransparency=on and 0.2 or 0.4
        b.TextColor3=on and C.bg or C.dim
        bs.Transparency=on and 0 or 0.4
    end
    b.MouseButton1Click:Connect(function()
        if action then task.spawn(action); notify(label); return end
        local newVal=not Flags[flagKey]
        if Setters[flagKey] then Setters[flagKey](newVal) else Flags[flagKey]=newVal end
        paint(); notify((newVal and "ON  " or "OFF ")..label)
    end)
    b.MouseEnter:Connect(function() if action or not Flags[flagKey] then b.BackgroundTransparency=0.15 end end)
    b.MouseLeave:Connect(paint)
    quickButtons[#quickButtons+1]={btn=b,flag=flagKey,paint=paint,action=action}
    paint()
    return b
end

makeQuickButton("AIMBOT","Aimbot/Enable","AIM")
makeQuickButton("AUTO SHOOT","Aimbot/Auto Shoot","SHT")
makeQuickButton("FLY","Move/Fly","FLY")
makeQuickButton("NOCLIP","Move/Noclip","NLP")
makeQuickButton("BHOP","Move/Bunnyhop","BHP")
makeQuickButton("AUTO WIN","Aimbot/Auto Win","AWN")
makeQuickButton("GUN TP",nil,"G·TP",function() if teleportToGun then teleportToGun() end end)
makeQuickButton("COIN FARM",nil,"FARM",function()
    if Farm and Farm.Enabled then stopFarm(); notify("Coin farm OFF")
    else Farm.Mode="Teleport"; Farm.Enabled=true; startFarm(); notify("Coin farm ON") end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(0.25)
        for _,qb in ipairs(quickButtons) do qb.paint() end
    end
end)

end -- /quickbar scope

makeDraggable(top,main)
track(UIS.InputBegan:Connect(function(input,processed) if not processed and input.KeyCode==Enum.KeyCode.RightShift then toggleMenu() end end))

-- HOME BAR
do
    local hit=Instance.new("TextButton")
    hit.Name="luxxsHomeBar"
    hit.AnchorPoint=Vector2.new(0.5,1)
    hit.Position=UDim2.new(0.5,0,1,0)
    hit.Size=UDim2.new(0,260,0,38)
    hit.BackgroundTransparency=1
    hit.Text=""
    hit.AutoButtonColor=false
    hit.ZIndex=30
    hit.Parent=gui

    local pill=Instance.new("Frame")
    pill.AnchorPoint=Vector2.new(0.5,1)
    pill.Position=UDim2.new(0.5,0,1,-8)
    pill.Size=UDim2.new(0,140,0,5)
    pill.BackgroundColor3=WHITE
    pill.BackgroundTransparency=0.35
    pill.BorderSizePixel=0
    pill.ZIndex=31
    pill.Parent=hit
    corner(pill,3)
    stroke(pill,Color3.new(0,0,0),1,0.75)

    local pressing=false
    local startX,startY,moved=0,0,0

    local function rest()
        tween(pill,0.25,{Size=UDim2.new(0,140,0,5),Position=UDim2.new(0.5,0,1,-8),BackgroundTransparency=0.35})
    end

    hit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            pressing=true
            startX=i.Position.X
            startY=i.Position.Y
            moved=0
            tween(pill,0.12,{Size=UDim2.new(0,175,0,6),BackgroundTransparency=0.05})
        end
    end)

    track(UIS.InputChanged:Connect(function(i)
        if not pressing then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local dy=i.Position.Y-startY
        moved=math.max(moved,math.abs(dy),math.abs(i.Position.X-startX))
        pill.Position=UDim2.new(0.5,0,1,-8+math.clamp(dy,-26,10)*0.6)
    end))

    track(UIS.InputEnded:Connect(function(i)
        if not pressing then return end
        if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
        pressing=false
        local dy=i.Position.Y-startY
        if dy<-22 then
            openMenu()
        elseif dy>22 then
            closeMenu()
        elseif moved<10 then
            toggleMenu()
        end
        rest()
    end))
end

-- ROLE DETECTION
local function scanName(name)
    local n=string.lower(name)
    if n=="knife" or n:find("knife") or n:find("murderknife") then return "Murderer" end
    if n=="gun" or n=="revolver" or n=="sheriff gun" or n:find("revolver") or (n:find("gun") and not n:find("shotgun") and not n:find("stun")) then return "Sheriff" end
    return nil
end
local function scanContainer(container,deep)
    if not container then return nil end
    local list=deep and container:GetDescendants() or container:GetChildren()
    for _,obj in ipairs(list) do
        if obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") then
            local r=scanName(obj.Name); if r then return r end
        end
    end
    return nil
end
local function getRole(plr)
    local char=plr.Character; if not char then return "Innocent" end
    if plr.Team then
        local tl=string.lower(plr.Team.Name)
        if tl=="murderer" then return "Murderer" end
        if tl=="sheriff" then return "Sheriff" end
        if tl=="innocent" then return "Innocent" end
    end
    for _,src in ipairs({plr,char}) do
        for _,attr in ipairs({"Role","MM2Role","MurderRole","PlayerRole","Team","role","mm2role"}) do
            local v=src:GetAttribute(attr)
            if v~=nil then
                local rl=string.lower(tostring(v))
                if rl=="murderer" or rl=="murder" then return "Murderer" end
                if rl=="sheriff" then return "Sheriff" end
                if rl=="innocent" then return "Innocent" end
            end
        end
    end
    for _,obj in ipairs(char:GetChildren()) do if obj:IsA("Tool") then local r=scanName(obj.Name); if r then return r end end end
    local r=scanContainer(char,true); if r then return r end
    local bp=plr:FindFirstChildOfClass("Backpack") or plr:FindFirstChild("Backpack")
    if bp then
        for _,obj in ipairs(bp:GetChildren()) do if obj:IsA("Tool") then local rr=scanName(obj.Name); if rr then return rr end end end
        r=scanContainer(bp,true); if r then return r end
    end
    return "Innocent"
end
local roleCache={}
local function getRoleCached(plr)
    local c=roleCache[plr]; local now=os.clock()
    if c and now-c.t<0.3 then return c.r end
    local r=getRole(plr); roleCache[plr]={r=r,t=now}; return r
end
Players.PlayerRemoving:Connect(function(p) roleCache[p]=nil end)

-- ESP
local ESPFolder=Instance.new("Folder"); ESPFolder.Name="luxxsESP"; ESPFolder.Parent=gui
local espData={}
local function setLine(f,p1,p2,thick)
    local dx,dy=p2.X-p1.X,p2.Y-p1.Y
    f.Position=UDim2.new(0,(p1.X+p2.X)*0.5,0,(p1.Y+p2.Y)*0.5)
    f.Size=UDim2.new(0,math.sqrt(dx*dx+dy*dy),0,thick)
    f.Rotation=math.deg(math.atan2(dy,dx))
end
local BONES={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}

local function createESP(plr)
    if espData[plr] or plr==LP then return end
    local d={}
    d.box=Instance.new("Frame"); d.box.BackgroundTransparency=1; d.box.BorderSizePixel=0; d.box.ZIndex=2; d.box.Parent=ESPFolder; d.boxStroke=stroke(d.box,ACC,1.2,0)
    local function mkLabel(size,font)
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Font=font or F_MONO; l.TextSize=size; l.TextColor3=WHITE; l.TextStrokeTransparency=0.4; l.TextStrokeColor3=Color3.new(0,0,0); l.Size=UDim2.new(0,260,0,size+2); l.TextXAlignment=Enum.TextXAlignment.Center; l.ZIndex=4; l.Parent=ESPFolder; return l
    end
    d.role=mkLabel(13,F_SEC); d.name=mkLabel(12); d.dist=mkLabel(11)
    d.tracer=Instance.new("Frame"); d.tracer.AnchorPoint=Vector2.new(0.5,0.5); d.tracer.BorderSizePixel=0; d.tracer.ZIndex=2; d.tracer.Parent=ESPFolder
    d.hpBg=Instance.new("Frame"); d.hpBg.BackgroundColor3=Color3.fromRGB(14,14,16); d.hpBg.BorderSizePixel=0; d.hpBg.ZIndex=3; d.hpBg.Parent=ESPFolder
    d.hpFill=Instance.new("Frame"); d.hpFill.AnchorPoint=Vector2.new(0,1); d.hpFill.BackgroundColor3=Color3.fromRGB(70,230,110); d.hpFill.BorderSizePixel=0; d.hpFill.Size=UDim2.new(1,0,1,0); d.hpFill.Position=UDim2.new(0,0,1,0); d.hpFill.ZIndex=4; d.hpFill.Parent=d.hpBg
    d.skeleton={}
    for i=1,#BONES do local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.BorderSizePixel=0; f.BackgroundColor3=WHITE; f.Visible=false; f.ZIndex=3; f.Parent=ESPFolder; d.skeleton[i]=f end
    espData[plr]=d
end

local function removeESP(plr)
    local d=espData[plr]; if not d then return end
    for k,v in pairs(d) do
        if typeof(v)=="Instance" then pcall(function() v:Destroy() end)
        elseif type(v)=="table" then for _,o in pairs(v) do pcall(function() o:Destroy() end) end end
    end
    espData[plr]=nil
end

for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then createESP(plr) end end
Players.PlayerAdded:Connect(function(plr) task.wait(0.2); createESP(plr) end)
Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)

local function espAnyOn() return Flags["Visuals/ESP Box"] or Flags["Visuals/Role"] or Flags["Visuals/Name"] or Flags["Visuals/Health"] or Flags["Visuals/Distance"] or Flags["Visuals/Tracers"] or Flags["Visuals/Skeleton"] or Flags["Visuals/Chams"] or Flags["Visuals/Glow"] end

track(RunService.RenderStepped:Connect(function()
    local cam=workspace.CurrentCamera; if not cam then return end
    local vp=cam.ViewportSize; local t=os.clock()
    local anyOn=espAnyOn()
    for plr,d in pairs(espData) do
        local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local visible=false; local minX,minY,maxX,maxY=math.huge,math.huge,-math.huge,-math.huge
        if char and hum and hrp and hum.Health>0 and anyOn then
            for _,p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") then
                    local sp,onS=cam:WorldToViewportPoint(p.Position)
                    if onS and sp.Z>0 then visible=true; minX=math.min(minX,sp.X-10); maxX=math.max(maxX,sp.X+10); minY=math.min(minY,sp.Y-10); maxY=math.max(maxY,sp.Y+10) end
                end
            end
        end
        if visible then
            local role=getRoleCached(plr); local rcol=ROLE_COLORS[role] or WHITE
            local ecol=Flags["Visuals/Color by Role"] and rcol or getColor(Flags["Visuals/ESP Color"],t,0)
            local w,h=maxX-minX,maxY-minY; local cx=(minX+maxX)*0.5
            d.box.Visible=Flags["Visuals/ESP Box"]; d.box.Position=UDim2.new(0,minX,0,minY); d.box.Size=UDim2.new(0,w,0,h); d.boxStroke.Color=ecol
            d.role.Visible=Flags["Visuals/Role"]; d.role.Text=string.upper(role); d.role.TextColor3=rcol; d.role.Position=UDim2.new(0,cx-130,0,minY-48)
            d.name.Visible=Flags["Visuals/Name"]; d.name.Text=plr.Name; d.name.TextColor3=ecol; d.name.Position=UDim2.new(0,cx-130,0,minY-32)
            local dist=(hrp.Position-cam.CFrame.Position).Magnitude
            d.dist.Visible=Flags["Visuals/Distance"]; d.dist.Text="["..math.floor(dist).."m]"; d.dist.Position=UDim2.new(0,cx-130,0,minY+h+2)
            d.hpBg.Visible=Flags["Visuals/Health"]; d.hpBg.Position=UDim2.new(0,minX-6,0,minY); d.hpBg.Size=UDim2.new(0,3,0,h); d.hpFill.Size=UDim2.new(1,0,math.clamp(hum.Health/hum.MaxHealth,0,1),0)
            d.tracer.Visible=Flags["Visuals/Tracers"]
            if d.tracer.Visible then d.tracer.BackgroundColor3=ecol; setLine(d.tracer,Vector2.new(vp.X*0.5,vp.Y),Vector2.new(cx,minY+h),1) end
            local skelOn=Flags["Visuals/Skeleton"]
            for i,bone in ipairs(BONES) do
                local ln=d.skeleton[i]
                if skelOn then
                    local p1=char:FindFirstChild(bone[1]); local p2=char:FindFirstChild(bone[2])
                    if p1 and p2 then
                        local s1,o1=cam:WorldToViewportPoint(p1.Position); local s2,o2=cam:WorldToViewportPoint(p2.Position)
                        if o1 and o2 and s1.Z>0 and s2.Z>0 then ln.Visible=true; ln.BackgroundColor3=ecol; setLine(ln,Vector2.new(s1.X,s1.Y),Vector2.new(s2.X,s2.Y),1.5)
                        else ln.Visible=false end
                    else ln.Visible=false end
                else ln.Visible=false end
            end
        else
            d.box.Visible=false; d.role.Visible=false; d.name.Visible=false; d.dist.Visible=false; d.hpBg.Visible=false; d.tracer.Visible=false
            for _,ln in ipairs(d.skeleton) do ln.Visible=false end
        end
    end
end))

-- CHAMS / GLOW
do
local chamsMap={}
local function dropCham(plr) local h=chamsMap[plr]; if h then pcall(function() h:Destroy() end); chamsMap[plr]=nil end end
Players.PlayerRemoving:Connect(dropCham)
track(RunService.Heartbeat:Connect(function()
    local chams,glow=Flags["Visuals/Chams"],Flags["Visuals/Glow"]
    local t=os.clock()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if (chams or glow) and char and hum and hum.Health>0 then
                local h=chamsMap[plr]
                if not h or not h.Parent or h.Adornee~=char then
                    if h then pcall(function() h:Destroy() end) end
                    h=Instance.new("Highlight"); h.Name="luxxsCham"; h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Adornee=char
                    local ok=pcall(function() h.Parent=char end)
                    if not ok or not h.Parent then h.Parent=ESPFolder end
                    chamsMap[plr]=h
                end
                local col
                if Flags["Visuals/Color by Role"] then col=ROLE_COLORS[getRoleCached(plr)] or WHITE else col=getColor(Flags["Visuals/ESP Color"],t,0) end
                h.FillColor=col; h.OutlineColor=col
                h.FillTransparency=chams and math.clamp((Flags["Visuals/Chams Fill"] or 50)/100,0,1) or 1
                h.OutlineTransparency=glow and 0.1 or (chams and 0.55 or 1)
                h.Enabled=true
            else
                dropCham(plr)
            end
        end
    end
end))
end

-- GUN ESP
local GunESP,GunFolder,dropGunVisual,teleportToGun,nearestGun
do
GunESP={set={},vis={}}
GunFolder=Instance.new("Folder"); GunFolder.Name="luxxsGun"; GunFolder.Parent=gui

local function lowerName(s) return string.lower(tostring(s or "")) end
local function looksLikeGunName(n)
    n=lowerName(n)
    if n=="gun" then return true end
    if n:find("gundrop") then return true end
    if n:find("gun drop") then return true end
    if n:find("droppedgun") then return true end
    if n:find("sheriffgun") then return true end
    if n:find("revolver") then return true end
    return false
end
local function gunPartOf(o)
    if o:IsA("BasePart") and looksLikeGunName(o.Name) then return o end
    if o:IsA("Tool") and o.Parent==workspace then
        local n=lowerName(o.Name)
        if n=="gun" or n:find("revolver") or n:find("sheriff") or n:find("gundrop") or looksLikeGunName(n) then
            local h=o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart")
            if h then return h end
        end
    end
    if o:IsA("Model") and o.Parent==workspace then
        if looksLikeGunName(o.Name) then local p=o:FindFirstChildWhichIsA("BasePart"); if p then return p end end
    end
    return nil
end

local function gunStillValid(p)
    if not p or not p.Parent then return false end
    return p:IsDescendantOf(workspace)
end

local function addGun(o) local p=gunPartOf(o); if p then GunESP.set[p]=true end end

function dropGunVisual(p)
    local v=GunESP.vis[p]; if not v then return end
    pcall(function() v.hl:Destroy() end); pcall(function() v.bb:Destroy() end)
    GunESP.vis[p]=nil
end

for _,o in ipairs(workspace:GetDescendants()) do addGun(o) end
track(workspace.DescendantAdded:Connect(addGun))
track(workspace.DescendantRemoving:Connect(function(o) if GunESP.set[o] then GunESP.set[o]=nil; dropGunVisual(o) end end))

function nearestGun()
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local best,bd=nil,math.huge
    for p in pairs(GunESP.set) do
        if gunStillValid(p) then
            local d=(p.Position-hrp.Position).Magnitude
            if d<bd then best,bd=p,d end
        end
    end
    return best
end

local rescanClock=0
track(RunService.RenderStepped:Connect(function()
    local on=Flags["Visuals/Gun ESP"]
    local cam=workspace.CurrentCamera
    local t=os.clock()
    rescanClock=rescanClock+1
    if rescanClock>=30 then
        rescanClock=0
        for _,o in ipairs(workspace:GetChildren()) do
            if (o:IsA("Tool") or o:IsA("Model") or o:IsA("BasePart")) and not GunESP.set[o] then
                local p=gunPartOf(o); if p and not GunESP.set[p] then GunESP.set[p]=true end
            end
        end
    end
    for p in pairs(GunESP.set) do
        if not gunStillValid(p) then
            GunESP.set[p]=nil; dropGunVisual(p)
        elseif on then
            local v=GunESP.vis[p]
            if not v then
                local hl=Instance.new("Highlight"); hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.FillTransparency=0.35; hl.OutlineTransparency=0; hl.Adornee=p; hl.Parent=GunFolder
                local bb=Instance.new("BillboardGui"); bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,120,0,34); bb.StudsOffset=Vector3.new(0,2.5,0); bb.Adornee=p; bb.Parent=GunFolder
                local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(1,0,1,0); l.Font=F_MONO; l.TextSize=13; l.TextStrokeTransparency=0.3; l.TextStrokeColor3=Color3.new(0,0,0); l.Text="GUN"; l.Parent=bb
                v={hl=hl,bb=bb,lbl=l}; GunESP.vis[p]=v
            end
            local col=getColor(Flags["Visuals/Gun Color"] or "Gold",t,0)
            v.hl.FillColor=col; v.hl.OutlineColor=col; v.lbl.TextColor3=col
            local dist=cam and math.floor((p.Position-cam.CFrame.Position).Magnitude) or 0
            v.lbl.Text="GUN ["..dist.."m]"
        else
            dropGunVisual(p)
        end
    end
end))

function teleportToGun()
    local p=nearestGun()
    if not p then notify("Gun not found") return end
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame=CFrame.new(p.Position+Vector3.new(0,3,0))
    hrp.AssemblyLinearVelocity=Vector3.zero
    notify("Teleported to gun")
end
end

-- AIM PARTS
local AIM_PARTS_DATA={
    {name="Head",x=33,y=12,w=24,h=24,r=12,dx=45,dy=24},
    {name="Chest",x=27,y=43,w=36,h=30,r=4,dx=45,dy=58},
    {name="Stomach",x=30,y=73,w=30,h=30,r=3,dx=45,dy=88},
    {name="Left Arm",x=12,y=45,w=13,h=60,r=5,dx=18,dy=75},
    {name="Right Arm",x=65,y=45,w=13,h=60,r=5,dx=72,dy=75},
    {name="Left Leg",x=25,y=104,w=18,h=62,r=5,dx=34,dy=135},
    {name="Right Leg",x=47,y=104,w=18,h=62,r=5,dx=56,dy=135}}
local AIM_NAMES={} for i,a in ipairs(AIM_PARTS_DATA) do AIM_NAMES[i]=a.name end

local function resolveBodyPart(char,name)
    if not char then return nil end
    if name=="Head" then return char:FindFirstChild("Head") end
    if name=="Chest" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
    if name=="Stomach" then return char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") end
    if name=="Left Arm" then return char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") end
    if name=="Right Arm" then return char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") end
    if name=="Left Leg" then return char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") end
    if name=="Right Leg" then return char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") end
    return char:FindFirstChild("Head")
end

local function hasWeapon()
    local char=LP.Character
    if not char then return false end
    for _,obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            local n=string.lower(obj.Name)
            if n:find("knife") or n:find("murder") or n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then return true end
        end
    end
    return false
end

local rayParams=RaycastParams.new()
do
    local ok=pcall(function() rayParams.FilterType=Enum.RaycastFilterType.Exclude end)
    if not ok then pcall(function() rayParams.FilterType=Enum.RaycastFilterType.Blacklist end) end
end
local function hasLineOfSight(fromPos,targetChar,targetPos)
    rayParams.FilterDescendantsInstances={LP.Character}
    local result=workspace:Raycast(fromPos,targetPos-fromPos,rayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(targetChar)
end

-- AIMBOT
local Shoot={}
do
local VIM=nil
pcall(function() VIM=game:GetService("VirtualInputManager") end)

local fovCircle=Instance.new("Frame"); fovCircle.AnchorPoint=Vector2.new(0.5,0.5); fovCircle.Position=UDim2.new(0.5,0,0.5,0); fovCircle.BackgroundTransparency=1; fovCircle.BorderSizePixel=0; fovCircle.Visible=false; fovCircle.ZIndex=2; fovCircle.Parent=gui; corner(fovCircle,9999)
local fovStroke=stroke(fovCircle,ACC,2,0.1); T(fovStroke,"Color"); fovCircle.BackgroundColor3=ACC; fovCircle.BackgroundTransparency=0.93
local fovLbl=Instance.new("TextLabel"); fovLbl.BackgroundTransparency=1; fovLbl.AnchorPoint=Vector2.new(0.5,1); fovLbl.Position=UDim2.new(0.5,0,0,-4); fovLbl.Size=UDim2.new(0,180,0,14); fovLbl.Font=F_MONO; fovLbl.TextSize=11; fovLbl.TextColor3=WHITE; fovLbl.TextStrokeTransparency=0.4; fovLbl.Parent=fovCircle

local function getFovRadiusPx() local cam=workspace.CurrentCamera; if not cam then return 200 end; return ((Flags["Aimbot/FOV"] or 120)/180)*math.min(cam.ViewportSize.X,cam.ViewportSize.Y) end

local function findAimbotTarget()
    local cam=workspace.CurrentCamera; if not cam then return nil end
    local center=Vector2.new(cam.ViewportSize.X*0.5,cam.ViewportSize.Y*0.5)
    local radius=getFovRadiusPx()
    local partName=Flags["Aimbot/Body Part"] or "Head"
    local best,bestDist=nil,math.huge
    local origin=cam.CFrame.Position
    local skipInno=Flags["Aimbot/Skip Innocents"]
    local wall=Flags["Aimbot/Wall Check"]
    local myRole=getRoleCached(LP)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health>0 then
                local ok=true
                if skipInno then
                    local r=getRoleCached(plr)
                    if r=="Innocent" or r==myRole then ok=false end
                end
                if ok then
                    local part=resolveBodyPart(char,partName)
                    if part then
                        local sp=cam:WorldToViewportPoint(part.Position)
                        if sp.Z>0 then
                            local dist=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                            if dist<=radius and dist<bestDist then
                                if (not wall) or hasLineOfSight(origin,char,part.Position) then best,bestDist={player=plr,part=part,char=char},dist end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local aimLastShot=0
local function clickCenter()
    if isMobile() or not VIM then return end
    local cam=workspace.CurrentCamera; if not cam then return end
    local vp=cam.ViewportSize
    pcall(function() VIM:SendMouseButtonEvent(vp.X*0.5,vp.Y*0.5,0,true,game,0) end)
    task.wait(0.01)
    pcall(function() VIM:SendMouseButtonEvent(vp.X*0.5,vp.Y*0.5,0,false,game,0) end)
end

local function getEquippedWeaponTool()
    local char=LP.Character; if not char then return nil end
    for _,t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local n=string.lower(t.Name)
            if n:find("knife") or n:find("murder") or n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then return t end
        end
    end
    return nil
end

track(RunService.RenderStepped:Connect(function(dt)
    local cam=workspace.CurrentCamera; if not cam then return end
    local showFov=Flags["Aimbot/Enable"] and Flags["Aimbot/Show FOV"]
    fovCircle.Visible=showFov and true or false
    if showFov then
        local rr=getFovRadiusPx()
        fovCircle.Size=UDim2.new(0,rr*2,0,rr*2)
        fovCircle.BackgroundColor3=ACC
        fovLbl.Text="AIM FOV  r="..math.floor(rr).."px"
    end
    if not Flags["Aimbot/Enable"] then return end
    if Flags["Aimbot/Weapon Only"] and not hasWeapon() then return end
    local target=findAimbotTarget()
    if target then
        local smooth=math.clamp(Flags["Aimbot/Smoothness"] or 30,1,100)/100
        local alpha=math.clamp(1-smooth,0.03,1)*math.min(1,dt*60)
        cam.CFrame=cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position,target.part.Position),alpha)
        if Flags["Aimbot/Auto Shoot"] then
            local tool=getEquippedWeaponTool()
            if tool then
                local tn=string.lower(tool.Name)
                local isKnife=tn:find("knife") or tn:find("murder")
                local now=os.clock()
                local delay=(Flags["Aimbot/Shoot Delay (ms)"] or 100)/1000
                if now-aimLastShot>=delay then
                    aimLastShot=now
                    pcall(function() tool:Activate() end)
                    if Shoot.fireRemotes then pcall(Shoot.fireRemotes,tool,target.part.Position,target.char) end
                    if not isKnife and not isMobile() then clickCenter() end
                end
            end
        end
    end
end))
end

-- FARM
local Farm={Enabled=false,Mode="Teleport",Speed=80,TeleportDelay=0.15,AntiAFK=false,ReturnOnFinish=false,ReturnPos=nil,LoopThread=nil,Collected=0,Status="idle"}
local setAntiAFK,disableFly,enableFly,setNoclip,startFarm,stopFarm
do
local antiAfkConn=nil
function setAntiAFK(on)
    if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn=nil end
    if not on then return end
    antiAfkConn=LP.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
end
local coinSet,coinConns={}, {}
local function isCoin(o) return o:IsA("BasePart") and (o.Name=="Coin" or o.Name:find("Coin") or o.Name:find("coin")) end
local function startCoinCache()
    for _,c in ipairs(coinConns) do c:Disconnect() end
    coinConns={}; coinSet={}
    for _,o in ipairs(workspace:GetDescendants()) do if isCoin(o) then coinSet[o]=true end end
    coinConns[1]=workspace.DescendantAdded:Connect(function(o) if isCoin(o) then coinSet[o]=true end end)
    coinConns[2]=workspace.DescendantRemoving:Connect(function(o)
        if coinSet[o] then
            coinSet[o]=nil
            local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if Farm.Enabled and hrp and (hrp.Position-o.Position).Magnitude<12 then Farm.Collected+=1 end
        end
    end)
end
local function getNearestCoin(pos,skip)
    local best,bestDist,now=nil,math.huge,os.clock()
    for p in pairs(coinSet) do
        if p.Parent and not (skip[p] and skip[p]>now) then
            local d=(p.Position-pos).Magnitude
            if d<bestDist then best,bestDist=p,d end
        end
    end
    return best
end
local flyConn,flyBodyVel,flyBodyGyro=nil,nil,nil
function disableFly()
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    local char=LP.Character
    if char then
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel=nil end
            if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro=nil end
        end
    end
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand=false end
end
function enableFly()
    disableFly()
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    flyBodyVel=Instance.new("BodyVelocity"); flyBodyVel.MaxForce=Vector3.new(9e9,9e9,9e9); flyBodyVel.Velocity=Vector3.zero; flyBodyVel.Parent=hrp
    flyBodyGyro=Instance.new("BodyGyro"); flyBodyGyro.MaxTorque=Vector3.new(9e9,9e9,9e9); flyBodyGyro.P=2000; flyBodyGyro.CFrame=hrp.CFrame; flyBodyGyro.Parent=hrp
    hum.PlatformStand=true
    local cam=workspace.CurrentCamera
    flyConn=RunService.RenderStepped:Connect(function()
        if not Farm.Enabled or not hrp or not hrp.Parent then return end
        local moveDir=Vector3.zero
        local look=cam.CFrame.LookVector; local right=cam.CFrame.RightVector
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir+=look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir-=look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir-=right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir+=right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir+=Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir-=Vector3.new(0,1,0) end
        if moveDir.Magnitude>0 then moveDir=moveDir.Unit end
        flyBodyVel.Velocity=moveDir*Farm.Speed
        flyBodyGyro.CFrame=cam.CFrame
    end)
end
local noclipConn=nil
function setNoclip(on)
    if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
    if not on then
        local char=LP.Character
        if char then for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.CanCollide=true end) end end end
        return
    end
    noclipConn=RunService.Stepped:Connect(function()
        if not Farm.Enabled then return end
        local char=LP.Character; if not char then return end
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then pcall(function() p.CanCollide=false end) end
        end
    end)
end
local function teleportTo(pos)
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame=CFrame.new(pos+Vector3.new(0,3,0)); return true
end
function startFarm()
    if Farm.LoopThread then return end
    local hrp0=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if Farm.ReturnOnFinish and hrp0 then Farm.ReturnPos=hrp0.CFrame end
    Farm.Enabled=true
    Farm.LoopThread=task.spawn(function()
        startCoinCache()
        local skip={}
        local lastCollect=0
        while Farm.Enabled do
            local dt=RunService.Heartbeat:Wait()
            local now=os.clock()
            local char=LP.Character
            local hrp=char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local tooFast = Farm.Mode=="Teleport" and (now-lastCollect)<0.13
                if tooFast then Farm.Status="cooldown"; task.wait(0.05)
                else
                    local coin=getNearestCoin(hrp.Position,skip)
                    if coin then
                        Farm.Status="to coin"
                        local target=coin.Position
                        if Farm.Mode=="Teleport" then
                            hrp.CFrame=CFrame.new(target)
                            hrp.AssemblyLinearVelocity=Vector3.zero
                            if Farm.TeleportDelay>0 then task.wait(Farm.TeleportDelay) end
                            lastCollect=os.clock()
                        else
                            local d=target-hrp.Position
                            local step=Farm.Speed*dt
                            if d.Magnitude<=step then hrp.CFrame=CFrame.new(target)
                            else hrp.CFrame=CFrame.new(hrp.Position+d.Unit*step) end
                            hrp.AssemblyLinearVelocity=Vector3.zero
                        end
                        if (hrp.Position-target).Magnitude<3 then skip[coin]=os.clock()+0.4 end
                    else Farm.Status="no coins"; task.wait(0.2) end
                end
            end
        end
        if Farm.ReturnOnFinish and Farm.ReturnPos then teleportTo(Farm.ReturnPos.Position) end
        Farm.Status="idle"
    end)
end
function stopFarm()
    Farm.Enabled=false
    if Farm.LoopThread then pcall(function() task.cancel(Farm.LoopThread) end); Farm.LoopThread=nil end
    for _,c in ipairs(coinConns) do c:Disconnect() end
    coinConns={}
    disableFly(); setNoclip(false)
end
end

-- FLY + NOCLIP
local Move={Fly=false,Speed=60,Noclip=false}
local flyUpBtn,flyDownBtn,disableFlyMove,setNoclipMove
do
local mvConn,mvVel,mvGyro,mvControls=nil,nil,nil,nil
local upHeld,downHeld=false,false
local function mkFlyBtn(txt,yOff)
    local b=Instance.new("TextButton"); b.AnchorPoint=Vector2.new(1,0.5); b.Position=UDim2.new(1,-24,0.5,yOff); b.Size=UDim2.new(0,54,0,44)
    b.BackgroundColor3=C.bg; b.BackgroundTransparency=0.1; b.BorderSizePixel=0; b.Text=txt; b.Font=F_MONO; b.TextSize=14; b.TextColor3=C.text
    b.AutoButtonColor=false; b.Visible=false; b.ZIndex=5; b.Parent=gui
    local s=stroke(b,ACC,1.5,0); T(s,"Color"); return b
end
flyUpBtn,flyDownBtn=mkFlyBtn("UP",-28),mkFlyBtn("DN",28)
local function bindHold(b,setter)
    b.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then setter(true); b.BackgroundColor3=ACC; b.TextColor3=C.bg end end)
    b.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then setter(false); b.BackgroundColor3=C.bg; b.TextColor3=C.text end end)
end
bindHold(flyUpBtn,function(v) upHeld=v end)
bindHold(flyDownBtn,function(v) downHeld=v end)
local function getMoveVector()
    if mvControls then
        local ok,v=pcall(function() return mvControls:GetMoveVector() end)
        if ok and typeof(v)=="Vector3" then return v end
    end
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    local cam=workspace.CurrentCamera
    if hum and cam then return cam.CFrame:VectorToObjectSpace(hum.MoveDirection) end
    return Vector3.zero
end
function disableFlyMove()
    if mvConn then mvConn:Disconnect(); mvConn=nil end
    if mvVel then pcall(function() mvVel:Destroy() end); mvVel=nil end
    if mvGyro then pcall(function() mvGyro:Destroy() end); mvGyro=nil end
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand=false; pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
end
enableFlyMove=function()
    disableFlyMove()
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if not mvControls then
        pcall(function()
            local pm=LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
            if pm then mvControls=require(pm):GetControls() end
        end)
    end
    mvVel=Instance.new("BodyVelocity"); mvVel.MaxForce=Vector3.new(9e9,9e9,9e9); mvVel.Velocity=Vector3.zero; mvVel.Parent=hrp
    mvGyro=Instance.new("BodyGyro"); mvGyro.MaxTorque=Vector3.new(9e9,9e9,9e9); mvGyro.P=9e4; mvGyro.D=800; mvGyro.CFrame=hrp.CFrame; mvGyro.Parent=hrp
    hum.PlatformStand=true
    mvConn=RunService.RenderStepped:Connect(function()
        if not hrp.Parent then return end
        local cam=workspace.CurrentCamera; if not cam then return end
        local mv=getMoveVector()
        local dir=cam.CFrame:VectorToWorldSpace(Vector3.new(mv.X,0,mv.Z))
        if UIS:IsKeyDown(Enum.KeyCode.W) and mv.Magnitude==0 then dir+=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) or upHeld then dir+=Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.Q) or downHeld then dir-=Vector3.new(0,1,0) end
        if dir.Magnitude>1 then dir=dir.Unit end
        mvVel.Velocity=dir*Move.Speed
        local look=cam.CFrame.LookVector
        if Vector3.new(look.X,0,look.Z).Magnitude>0.01 then
            mvGyro.CFrame=CFrame.lookAt(hrp.Position,hrp.Position+Vector3.new(look.X,0,look.Z))
        end
    end)
end
local ncConn,ncTouched=nil,{}
function setNoclipMove(on)
    if ncConn then ncConn:Disconnect(); ncConn=nil end
    if on then
        ncConn=RunService.Stepped:Connect(function()
            local char=LP.Character; if not char then return end
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then ncTouched[p]=true; p.CanCollide=false end
            end
        end)
    else
        for p in pairs(ncTouched) do if p.Parent then pcall(function() p.CanCollide=true end) end end
        ncTouched={}
    end
end
end

-- AUTO WIN
local AutoWin={Enabled=false,Teleport=true,AutoEquip=true,Delay=0.2,Thread=nil,Status="idle"}
local startAutoWin,stopAutoWin
do
local VIM=nil
pcall(function() VIM=game:GetService("VirtualInputManager") end)
local function isWeaponTool(t)
    local n=string.lower(t.Name)
    return (n:find("knife")~=nil) or (n:find("gun")~=nil) or (n:find("revolver")~=nil) or (n:find("pistol")~=nil) or (n:find("sheriff")~=nil) or (n:find("murder")~=nil)
end
local function isKnife(t) local n=string.lower(t.Name); return n:find("knife") or n:find("murder") end
local function getEquippedWeapon()
    local char=LP.Character; if not char then return nil end
    local t=char:FindFirstChildOfClass("Tool")
    if t and isWeaponTool(t) then return t end
    return nil
end
local function equipWeapon()
    local char=LP.Character; if not char then return nil end
    local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return nil end
    local current=getEquippedWeapon(); if current then return current end
    local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not bp then return nil end
    for _,t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") and isWeaponTool(t) then
            pcall(function() hum:EquipTool(t) end); task.wait(0.25)
            return getEquippedWeapon() or t
        end
    end
    return nil
end
local function isAlive(plr)
    local c=plr and plr.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if c and h and r and h.Health>0 then return c,h,r end
    return nil
end
local function findTarget(myRole)
    local _,_,myRoot=isAlive(LP); if not myRoot then return nil end
    local best,bestScore=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local c,h,r=isAlive(plr)
            if c then
                local role=getRoleCached(plr); local score=nil
                if myRole=="Murderer" then score=(role=="Sheriff") and 0 or 1
                elseif myRole=="Sheriff" then if role=="Murderer" then score=0 end end
                if score then
                    local combined=score*100000+(r.Position-myRoot.Position).Magnitude
                    if combined<bestScore then bestScore=combined; best={plr=plr,char=c,hum=h,root=r,role=role} end
                end
            end
        end
    end
    return best
end
local function fireRemotes(tool,pos,targetChar)
    local cf=CFrame.new(pos)
    for _,d in ipairs(tool:GetDescendants()) do
        if d:IsA("RemoteEvent") then
            pcall(function() d:FireServer(cf) end)
            pcall(function() d:FireServer(pos) end)
            pcall(function() d:FireServer(1,cf,"AH2") end)
            pcall(function() d:FireServer(1,pos,"AH2") end)
            pcall(function() d:FireServer(targetChar) end)
            pcall(function() d:FireServer(tool.Handle.CFrame) end)
        elseif d:IsA("RemoteFunction") then
            task.spawn(function()
                pcall(function() d:InvokeServer(cf) end)
                pcall(function() d:InvokeServer(pos) end)
            end)
        end
    end
end
local function touchKill(tool,targetChar)
    if type(firetouchinterest)~="function" then return end
    local handle=tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    if not handle then return end
    for _,p in ipairs(targetChar:GetChildren()) do
        if p:IsA("BasePart") then
            pcall(firetouchinterest,handle,p,0)
            pcall(firetouchinterest,handle,p,1)
        end
    end
end
local function clickAt(vec2)
    if not VIM or isMobile() then return end
    pcall(function() VIM:SendMouseButtonEvent(vec2.X,vec2.Y,0,true,game,0) end)
    task.wait(0.01)
    pcall(function() VIM:SendMouseButtonEvent(vec2.X,vec2.Y,0,false,game,0) end)
end
local function aimAt(target)
    local cam=workspace.CurrentCamera; if not cam then return end
    cam.CFrame=CFrame.lookAt(cam.CFrame.Position,target)
end
local function step()
    local _,_,hrp=isAlive(LP); if not hrp then AutoWin.Status="waiting"; return end
    local myRole=getRoleCached(LP)
    if myRole~="Murderer" and myRole~="Sheriff" then AutoWin.Status="innocent"; return end
    local target=findTarget(myRole); if not target then AutoWin.Status="no targets"; return end
    local tool=AutoWin.AutoEquip and equipWeapon() or getEquippedWeapon()
    if not tool then AutoWin.Status="no weapon"; return end
    local cam=workspace.CurrentCamera
    local tRoot=target.root
    local tHead=target.char:FindFirstChild("Head") or tRoot
    local isKnifeW=isKnife(tool)
    AutoWin.Status=(myRole=="Sheriff" and "shoot " or "stab ")..target.plr.Name
    if AutoWin.Teleport then
        if isKnifeW then hrp.CFrame=tRoot.CFrame*CFrame.new(0,0,1.8)
        else
            local back=tRoot.CFrame*CFrame.new(0,0.5,6)
            hrp.CFrame=CFrame.lookAt(back.Position,tHead.Position)
        end
        hrp.AssemblyLinearVelocity=Vector3.zero
        task.wait(0.05)
    end
    aimAt(tHead.Position)
    task.wait(0.02)
    if isKnifeW then
        touchKill(tool,target.char)
        pcall(function() tool:Activate() end)
        fireRemotes(tool,tRoot.Position,target.char)
        task.wait(0.05)
        local hum=target.char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 then
            touchKill(tool,target.char)
            pcall(function() tool:Activate() end)
        end
    else
        pcall(function() tool:Activate() end)
        fireRemotes(tool,tHead.Position,target.char)
        if cam and not isMobile() then local vp=cam.ViewportSize; clickAt(Vector2.new(vp.X*0.5,vp.Y*0.5)) end
        task.wait(0.02)
        fireRemotes(tool,tHead.Position,target.char)
        pcall(function() tool:Activate() end)
        task.wait(0.05)
        local hum=target.char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 and cam and not isMobile() then
            local vp=cam.ViewportSize
            clickAt(Vector2.new(vp.X*0.5,vp.Y*0.5))
            fireRemotes(tool,tHead.Position,target.char)
        end
    end
    task.wait(0.15)
end
local function autoWinLoop()
    while AutoWin.Enabled do
        local ok,err=pcall(step)
        if not ok then AutoWin.Status="err: "..tostring(err) end
        task.wait(AutoWin.Delay)
    end
    AutoWin.Status="idle"
end
function startAutoWin() AutoWin.Enabled=true; if not AutoWin.Thread then AutoWin.Thread=task.spawn(autoWinLoop) end end
function stopAutoWin() AutoWin.Enabled=false; if AutoWin.Thread then pcall(function() task.cancel(AutoWin.Thread) end); AutoWin.Thread=nil end; AutoWin.Status="idle" end
Shoot.fireRemotes=fireRemotes; Shoot.touchKill=touchKill
end

-- WALKSPEED + SPIN
local Move2={WalkSpeed=16,SpinSpeed=0,SpinEnabled=false}
local applyWalkSpeed,startSpin,stopSpin
do
local spinAngle=0; local spinThread=nil
function applyWalkSpeed(v)
    v=tonumber(v) or 16; Move2.WalkSpeed=v
    local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed=v end
end
track(LP.CharacterAdded:Connect(function(c)
    local hum=c:WaitForChild("Humanoid",10)
    if hum then task.wait(0.4); hum.WalkSpeed=Move2.WalkSpeed end
end))
local function spinLoop()
    while Move2.SpinEnabled do
        local dt=RunService.RenderStepped:Wait()
        local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            spinAngle=spinAngle+math.rad(Move2.SpinSpeed)*dt
            if spinAngle>math.pi*2 then spinAngle=spinAngle-math.pi*2 end
            hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(0,spinAngle,0)
        end
    end
end
function startSpin() if spinThread then return end; Move2.SpinEnabled=true; spinThread=task.spawn(spinLoop) end
function stopSpin() Move2.SpinEnabled=false; if spinThread then pcall(function() task.cancel(spinThread) end); spinThread=nil end end
end

-- BUNNYHOP
local BHop={Enabled=false,Accel=40,Max=120,Boost=4,lastJump=0,vel=nil}
do
    track(UIS.JumpRequest:Connect(function() BHop.lastJump=os.clock() end))
    track(RunService.Heartbeat:Connect(function(dt)
        if not BHop.Enabled or Move.Fly then BHop.vel=nil; return end
        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health<=0 then BHop.vel=nil; return end
        local held=UIS:IsKeyDown(Enum.KeyCode.Space) or (os.clock()-BHop.lastJump<0.25)
        local wish=hum.MoveDirection
        local grounded=hum.FloorMaterial~=Enum.Material.Air
        if not held or wish.Magnitude<0.1 then if grounded then BHop.vel=nil end; return end
        wish=wish.Unit
        local v=hrp.AssemblyLinearVelocity
        local h=BHop.vel or Vector3.new(v.X,0,v.Z)
        if grounded then
            local spd=math.min(math.max(h.Magnitude,hum.WalkSpeed)+BHop.Boost,BHop.Max)
            h=wish*spd
            local jy=hum.UseJumpPower and hum.JumpPower or math.sqrt(2*workspace.Gravity*hum.JumpHeight)
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            hrp.AssemblyLinearVelocity=Vector3.new(h.X,jy,h.Z)
        else
            local spd=h.Magnitude
            if spd>0.1 then
                local d=h.Unit:Lerp(wish,math.clamp(dt*4,0,1))
                if d.Magnitude>0.01 then h=d.Unit*spd end
            else h=wish*hum.WalkSpeed end
            h=h+wish*BHop.Accel*dt
            if h.Magnitude>BHop.Max then h=h.Unit*BHop.Max end
            hrp.AssemblyLinearVelocity=Vector3.new(h.X,v.Y,h.Z)
        end
        BHop.vel=h
    end))
end

-- SKINS
local Skin,SKIN_NAMES
do
Skin={orig=setmetatable({},{__mode="k"}),applied=setmetatable({},{__mode="k"}),live={},cfg={KnifeMesh="",KnifeTex="",GunMesh="",GunTex=""}}
local MAT=Enum.Material
local SKINS={
    ["Chroma"]={a=Color3.fromRGB(255,0,0),b=Color3.fromRGB(255,255,0),mat=MAT.Neon,rainbow=true,trail=true,spark=true},
    ["Chroma Dark"]={a=Color3.fromRGB(40,0,60),b=Color3.fromRGB(255,0,180),mat=MAT.Neon,rainbow=true,trail=true,spark=true},
    ["Ice Shard"]={a=Color3.fromRGB(150,225,255),b=Color3.fromRGB(235,250,255),mat=MAT.Ice,trail=true,spark=true},
    ["Frostbite"]={a=Color3.fromRGB(80,180,255),b=Color3.fromRGB(255,255,255),mat=MAT.Plastic,trail=true,spark=true},
    ["Harvester"]={a=Color3.fromRGB(35,12,50),b=Color3.fromRGB(255,120,20),t=Color3.fromRGB(255,120,20),mat=MAT.Metal,trail=true,spark=true},
    ["Heartblade"]={a=Color3.fromRGB(255,50,110),b=Color3.fromRGB(255,200,220),mat=MAT.Neon,trail=true,spark=true},
    ["Gingerblade"]={a=Color3.fromRGB(210,120,50),b=Color3.fromRGB(255,255,255),mat=MAT.SmoothPlastic},
    ["Corrupt"]={a=Color3.fromRGB(20,20,20),b=Color3.fromRGB(190,0,0),t=Color3.fromRGB(190,0,0),mat=MAT.Metal,trail=true},
    ["Lightbringer"]={a=Color3.fromRGB(255,235,150),b=Color3.fromRGB(255,255,255),mat=MAT.Neon,trail=true,spark=true},
    ["Batwing"]={a=Color3.fromRGB(25,20,35),b=Color3.fromRGB(130,60,220),t=Color3.fromRGB(130,60,220),mat=MAT.Metal,trail=true},
    ["Slasher"]={a=Color3.fromRGB(90,0,0),b=Color3.fromRGB(255,40,40),mat=MAT.Neon,trail=true,spark=true},
    ["Shadow"]={a=Color3.fromRGB(0,0,0),b=Color3.fromRGB(60,60,60),t=Color3.fromRGB(60,60,60),mat=MAT.Metal,trail=true},
    ["Candy"]={a=Color3.fromRGB(255,180,220),b=Color3.fromRGB(255,255,255),mat=MAT.Neon,trail=true,spark=true},
    ["Toxic"]={a=Color3.fromRGB(50,255,50),b=Color3.fromRGB(180,255,50),t=Color3.fromRGB(120,255,80),mat=MAT.Neon,trail=true,spark=true},
    ["Lava"]={a=Color3.fromRGB(180,30,0),b=Color3.fromRGB(255,180,0),t=Color3.fromRGB(255,120,0),mat=MAT.Neon,trail=true,spark=true},
    ["Plasma"]={a=Color3.fromRGB(180,0,255),b=Color3.fromRGB(80,180,255),t=Color3.fromRGB(180,80,255),mat=MAT.Neon,trail=true,spark=true},
    ["Void"]={a=Color3.fromRGB(10,0,30),b=Color3.fromRGB(60,0,100),t=Color3.fromRGB(60,0,120),mat=MAT.Neon,trail=true,spark=true},
    ["Royal"]={a=Color3.fromRGB(180,140,20),b=Color3.fromRGB(255,220,80),t=Color3.fromRGB(255,200,60),mat=MAT.Metal,trail=true,spark=true},
    ["Emerald"]={a=Color3.fromRGB(20,180,60),b=Color3.fromRGB(180,255,200),mat=MAT.Neon,trail=true,spark=true},
    ["Sapphire"]={a=Color3.fromRGB(20,60,200),b=Color3.fromRGB(150,220,255),mat=MAT.Neon,trail=true,spark=true},
    ["Ruby"]={a=Color3.fromRGB(180,20,60),b=Color3.fromRGB(255,180,200),mat=MAT.Neon,trail=true,spark=true},
    ["Amethyst"]={a=Color3.fromRGB(130,50,220),b=Color3.fromRGB(220,180,255),mat=MAT.Neon,trail=true,spark=true},
    ["Ghost"]={a=Color3.fromRGB(200,220,255),b=Color3.fromRGB(255,255,255),mat=MAT.Neon,trail=true,spark=true},
    ["Neon Pink"]={a=Color3.fromRGB(255,0,120),b=Color3.fromRGB(255,180,255),mat=MAT.Neon,trail=true,spark=true},
    ["Neon Blue"]={a=Color3.fromRGB(0,180,255),b=Color3.fromRGB(180,240,255),mat=MAT.Neon,trail=true,spark=true},
    ["Neon Green"]={a=Color3.fromRGB(0,255,80),b=Color3.fromRGB(180,255,180),mat=MAT.Neon,trail=true,spark=true},
    ["Gold"]={a=Color3.fromRGB(220,180,20),b=Color3.fromRGB(255,240,180),t=Color3.fromRGB(255,220,60),mat=MAT.Metal,trail=true,spark=true},
    ["Silver"]={a=Color3.fromRGB(180,180,200),b=Color3.fromRGB(255,255,255),mat=MAT.Metal,trail=true,spark=true},
    ["Bronze"]={a=Color3.fromRGB(150,90,30),b=Color3.fromRGB(220,180,120),mat=MAT.Metal},
    ["Blood"]={a=Color3.fromRGB(80,0,0),b=Color3.fromRGB(180,0,0),t=Color3.fromRGB(180,0,0),mat=MAT.Metal,trail=true,spark=true},
    ["Aqua"]={a=Color3.fromRGB(0,180,180),b=Color3.fromRGB(150,255,255),mat=MAT.Neon,trail=true,spark=true},
}
SKIN_NAMES={"Off"}
for name,_ in pairs(SKINS) do SKIN_NAMES[#SKIN_NAMES+1]=name end
table.sort(SKIN_NAMES,function(a,b) if a==b then return false end if a=="Off" then return true end if b=="Off" then return false end return a<b end)

local function toolKind(t) local r=scanName(t.Name); if r=="Murderer" then return "Knife" elseif r=="Sheriff" then return "Gun" end; return nil end
local function assetId(v) local x=tostring(v or ""):gsub("%s+",""); if x=="" then return "" end; if x:match("^%d+$") then return "rbxassetid://"..x end; return x end
local function saveProps(tool)
    if Skin.orig[tool] then return end
    local o={}
    for _,d in ipairs(tool:GetDescendants()) do
        if d:IsA("BasePart") then
            local e={Color=d.Color,Material=d.Material,Transparency=d.Transparency}
            if d:IsA("MeshPart") then e.TextureID=d.TextureID end
            o[d]=e
        elseif d:IsA("SpecialMesh") then o[d]={TextureId=d.TextureId,VertexColor=d.VertexColor} end
    end
    Skin.orig[tool]=o
end
local function restoreTool(tool)
    for _,d in ipairs(tool:GetDescendants()) do if d.Name=="luxxsFx" or d.Name=="luxxsCustom" then pcall(function() d:Destroy() end) end end
    local o=Skin.orig[tool]
    if o then for inst,e in pairs(o) do if inst.Parent then for k,v in pairs(e) do pcall(function() inst[k]=v end) end end end end
    Skin.applied[tool]=nil; Skin.live[tool]=nil
end
local function applyTool(tool,kind)
    local skinName=Flags["Skins/"..kind.." Skin"] or "Off"
    local def=SKINS[skinName]
    local mesh=assetId(Skin.cfg[kind.."Mesh"]); local tex=assetId(Skin.cfg[kind.."Tex"])
    local scl=(Flags["Skins/Mesh Scale %"] or 100)/100
    local sig=skinName.."|"..mesh.."|"..tex.."|"..scl
    if Skin.applied[tool]==sig then return end
    restoreTool(tool); Skin.applied[tool]=sig
    if not def and mesh=="" and tex=="" then return end
    saveProps(tool)
    local handle=tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart",true)
    local parts={}
    if def then
        local i=0
        for _,d in ipairs(tool:GetDescendants()) do
            if d:IsA("BasePart") then i+=1; parts[#parts+1]=d; d.Material=def.mat; d.Color=(i%2==0) and (def.b or def.a) or def.a
                if d:IsA("MeshPart") then d.TextureID="" end
            elseif d:IsA("SpecialMesh") then d.TextureId=""; d.VertexColor=Vector3.new(1,1,1) end
        end
    end
    if mesh~="" and handle then
        for _,d in ipairs(tool:GetDescendants()) do if d:IsA("BasePart") and d~=handle then d.Transparency=1 end end
        local cp=Instance.new("Part"); cp.Name="luxxsCustom"
        cp.Size=Vector3.new(1,1,1); cp.CanCollide=false; cp.CanQuery=false; cp.CanTouch=false; cp.Massless=true
        if def then cp.Color=def.a; cp.Material=def.mat else cp.Color=handle.Color; cp.Material=handle.Material end
        local sm=Instance.new("SpecialMesh"); sm.MeshType=Enum.MeshType.FileMesh; sm.MeshId=mesh
        sm.TextureId=tex; sm.Scale=Vector3.new(scl,scl,scl); sm.Parent=cp
        local w=Instance.new("Weld"); w.Part0=handle; w.Part1=cp; w.C0=CFrame.new(0,0,0); w.Parent=cp
        cp.Parent=tool
        handle.Transparency=1
    end
    if tex~="" and mesh=="" then
        for _,d in ipairs(tool:GetDescendants()) do
            if d:IsA("MeshPart") then d.TextureID=tex
            elseif d:IsA("SpecialMesh") then d.TextureId=tex
            elseif d:IsA("Decal") then d.Texture=tex end
        end
    end
    if def and handle then
        if def.trail then
            local a0=Instance.new("Attachment"); a0.Name="luxxsFx"; a0.Position=Vector3.new(0,0.5,0); a0.Parent=handle
            local a1=Instance.new("Attachment"); a1.Name="luxxsFx"; a1.Position=Vector3.new(0,-0.5,0); a1.Parent=handle
            local tr=Instance.new("Trail"); tr.Name="luxxsFx"; tr.Attachment0=a0; tr.Attachment1=a1
            tr.LightEmission=1; tr.FaceCamera=true
            tr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,1)})
            tr.Color=ColorSequence.new(def.a); tr.Parent=handle
        end
        if def.spark then
            local sp=Instance.new("Sparkles"); sp.Name="luxxsFx"; sp.SparkleColor=def.b or def.a; sp.Parent=handle
        end
    end
    Skin.live[tool]=kind
end
local skinnedTools=setmetatable({},{__mode="k"})
local function scanTools()
    local char=LP.Character
    if char then
        for _,t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                local kind=toolKind(t)
                if kind then
                    skinnedTools[t]=kind
                    if Flags["Skins/"..kind.." Skin"] or Skin.cfg[kind.."Mesh"]~="" or Skin.cfg[kind.."Tex"]~="" then
                        pcall(applyTool,t,kind)
                    end
                end
            end
        end
    end
end
track(RunService.Heartbeat:Connect(function()
    scanTools()
    for tool,kind in pairs(skinnedTools) do
        if tool.Parent then pcall(applyTool,tool,kind) end
    end
end))
end

-- =========================================================================
-- TABS
-- =========================================================================
local tabAim=createTab("Aimbot")
local tabVisuals=createTab("Visuals")
local tabSkins=createTab("Skins")
local tabMove=createTab("Movement")
local tabFarm=createTab("Farm")
local tabMisc=createTab("Misc")

tabAim:Label("Aim")
tabAim:Toggle("Enable",false)
tabAim:Toggle("Auto Shoot",false)
tabAim:Toggle("Show FOV",true)
tabAim:Toggle("Wall Check",false)
tabAim:Toggle("Weapon Only",true)
tabAim:Toggle("Skip Innocents",false)
tabAim:Choice("Body Part",AIM_NAMES,"Head")
tabAim:Slider("FOV",20,360,120)
tabAim:Slider("Smoothness",1,100,30)
tabAim:Slider("Shoot Delay (ms)",10,500,100)
tabAim:Label("Auto Win")
tabAim:Toggle("Auto Win",false,function(v) if v then startAutoWin() else stopAutoWin() end end)
tabAim:Toggle("Teleport",true,function(v) AutoWin.Teleport=v end)
tabAim:Toggle("AutoEquip",true,function(v) AutoWin.AutoEquip=v end)

tabVisuals:Label("Players")
tabVisuals:Toggle("ESP Box",false)
tabVisuals:Toggle("Role",false)
tabVisuals:Toggle("Name",false)
tabVisuals:Toggle("Health",false)
tabVisuals:Toggle("Distance",false)
tabVisuals:Toggle("Tracers",false)
tabVisuals:Toggle("Skeleton",false)
tabVisuals:Toggle("Chams",false)
tabVisuals:Toggle("Glow",false)
tabVisuals:Toggle("Color by Role",true)
tabVisuals:Choice("ESP Color",COLOR_NAMES,"Lime")
tabVisuals:Slider("Chams Fill",0,100,50)
tabVisuals:Label("Guns")
tabVisuals:Toggle("Gun ESP",false)
tabVisuals:Choice("Gun Color",COLOR_NAMES,"Gold")
tabVisuals:Button("Teleport to Gun",function() teleportToGun() end)
tabVisuals:Label("Cosmetics")
tabVisuals:Toggle("Wings",false,function(v) if v then buildWings() else destroyCos("wings") end end)
tabVisuals:Toggle("Chinese Hat",false,function(v) if v then buildHat() else destroyCos("hat") end end)
tabVisuals:Toggle("Keep Level",true)
tabVisuals:Toggle("Trail",false,function(v) if v then buildTrail() else destroyCos("trail") end end)
tabVisuals:Choice("Wing Color",WING_COLORS,"White")
tabVisuals:Slider("Wing Speed",1,20,3)
tabVisuals:Choice("Hat Color",HAT_COLORS,"Custom")
tabVisuals:Slider("Hat Size",50,300,100,function() scheduleHatRebuild() end)
tabVisuals:Slider("Hat Height",50,300,100,function() scheduleHatRebuild() end)
tabVisuals:Slider("Hat Transparency",0,100,35)
tabVisuals:Choice("Trail Color",COLOR_NAMES,"Lime")
tabVisuals:Slider("Trail Length",1,50,10)
tabVisuals:Slider("Trail Width",1,40,4)
tabVisuals:Label("Screen")
tabVisuals:Choice("Screen Ratio",SCREEN_RATIOS,"Default",function(v) ScreenRes.apply(v,true) end)

tabSkins:Label("Knife / Gun")
tabSkins:Choice("Knife Skin",SKIN_NAMES,"Off")
tabSkins:Choice("Gun Skin",SKIN_NAMES,"Off")
tabSkins:Label("Custom (rbxassetid)")
tabSkins:Input("Knife Mesh","",function(v) Skin.cfg.KnifeMesh=v end)
tabSkins:Input("Knife Tex","",function(v) Skin.cfg.KnifeTex=v end)
tabSkins:Input("Gun Mesh","",function(v) Skin.cfg.GunMesh=v end)
tabSkins:Input("Gun Tex","",function(v) Skin.cfg.GunTex=v end)
tabSkins:Slider("Mesh Scale %",10,500,100)
tabSkins:Button("Reset Skins",function()
    for _,t in pairs(Skin.live) do pcall(restoreTool,t) end
    Skin.live={}; Skin.applied=setmetatable({},{__mode="k"})
    notify("Skins reset")
end)

tabMove:Label("Movement")
tabMove:Toggle("Fly",false,function(v) if v then Move.Fly=true; enableFlyMove() else Move.Fly=false; disableFlyMove() end end)
tabMove:Slider("Fly Speed",10,500,60,function(v) Move.Speed=v end)
tabMove:Toggle("Noclip",false,function(v) setNoclipMove(v) end)
tabMove:Toggle("Bunnyhop",false,function(v) BHop.Enabled=v end)
tabMove:Slider("BHop Accel",5,200,40,function(v) BHop.Accel=v end)
tabMove:Slider("BHop Max",20,500,120,function(v) BHop.Max=v end)
tabMove:Label("Speed")
tabMove:Slider("WalkSpeed",8,300,16,function(v) applyWalkSpeed(v) end)
tabMove:Toggle("Spin",false,function(v) if v then startSpin() else stopSpin() end end)
tabMove:Slider("Spin Speed",10,2000,360,function(v) Move2.SpinSpeed=v end)

tabFarm:Label("Coin Farm")
tabFarm:Toggle("Enable",false,function(v)
    if v then Farm.Mode=Flags["Farm/Mode"] or "Teleport"; Farm.Enabled=true; startFarm()
    else stopFarm() end
end)
tabFarm:Choice("Mode",{"Teleport","Walk"},"Teleport",function(v) Farm.Mode=v end)
tabFarm:Slider("Walk Speed",20,300,80,function(v) Farm.Speed=v end)
tabFarm:Slider("Teleport Delay x100",0,50,15,function(v) Farm.TeleportDelay=v/100 end)
tabFarm:Toggle("Anti AFK",false,function(v) Farm.AntiAFK=v; setAntiAFK(v) end)
tabFarm:Toggle("Return On Finish",false,function(v) Farm.ReturnOnFinish=v end)
tabFarm:Button("Start Farm",function() Farm.Enabled=true; startFarm() end)
tabFarm:Button("Stop Farm",function() stopFarm() end)
tabFarm:Button("Teleport to Gun",function() teleportToGun() end)

tabMisc:Label("Interface")
tabMisc:Toggle("Quick Bar",true,function(v) setQuickBarVisible(v) end)
tabMisc:Choice("QB Position",QB_POSITIONS,"Left",function(v) applyQbPosition(v,true) end)
tabMisc:Label("Accent")
tabMisc:Choice("Accent",ACCENT_NAMES,"Lime",function(v)
    ACC_NAME=v; setAccent(ACCENTS[v])
    if hasFS then ensureFolder(); pcall(function() writefile(FOLDER.."/accent.txt",v) end) end
    notify("Accent: "..v)
end)
tabMisc:Label("Config")
tabMisc:Button("Save Config",function()
    if not hasFS then notify("No file system") return end
    ensureFolder()
    local data={}
    for k,v in pairs(Flags) do data[k]=v end
    data.__accent=ACC_NAME
    pcall(function() writefile(FOLDER.."/config.json",HttpService:JSONEncode(data)) end)
    notify("Config saved")
end)
tabMisc:Button("Load Config",function()
    if not hasFS then notify("No file system") return end
    local p=FOLDER.."/config.json"
    if not isfile(p) then notify("No config") return end
    local ok,data=pcall(function() return HttpService:JSONDecode(readfile(p)) end)
    if not ok or type(data)~="table" then notify("Bad config") return end
    for k,v in pairs(data) do
        if k~="__accent" and Setters[k] then pcall(function() Setters[k](v) end) end
    end
    notify("Config loaded")
end)
tabMisc:Label("Info")
tabMisc:Label2("luxxs v5.5 • DrHub")
tabMisc:Label2("Telegram: t.me/NurHuboffical")

-- INIT
selectTab(tabAim)
task.wait(0.15)
openMenu()
task.wait(0.6)
setQuickBarVisible(true)
selectTab(tabAim)

track(RunService.Heartbeat:Connect(function()
    if hatRebuildAt>0 and os.clock()>=hatRebuildAt then
        hatRebuildAt=0
        if Flags["Visuals/Chinese Hat"] then buildHat() end
    end
end))

LP.AncestryChanged:Connect(function(_,p)
    if not p then
        for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        pcall(function() gui:Destroy() end)
    end
end)

print("[luxxs] v5.5 ready")
