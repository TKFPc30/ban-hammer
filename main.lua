game.Players.LocalPlayer.Character["LUAhEAD"].Handle.Mesh:Destroy() --Pink Hair
game.Players.LocalPlayer.Character["Pink Hair"].Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character["Kate Hair"].Handle.Mesh:Destroy() --LavanderHair
game.Players.LocalPlayer.Character["LavanderHair"].Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character["Robloxclassicred"].Handle.Mesh:Destroy()
game.Players.LocalPlayer.Character["Surfboard"].Handle.Handle:Destroy()
game.Players.LocalPlayer.Character["VANS_Umbrella"].Handle.Mesh:Destroy() --Surfboard
 --VarietyShades02
 --TennisBall

local c = game.Players.LocalPlayer.Character
for i, v in pairs({"Right Arm", "Left Arm"}) do
    local arm = c[v]
    arm.Parent = nil
    arm.Transparency = 1
    arm.Parent = c
end

local c = game.Players.LocalPlayer.Character
for i, v in pairs({"Right Leg", "Left Leg"}) do
    local Leg = c[v]
    Leg.Parent = nil
    Leg.Transparency = 1
    Leg.Parent = c
end

local v3_net, v3_808 = Vector3.new(10000, 25100, 10000), Vector3.new(8, 0, 8)
		local function getNetlessVelocity(realPartVelocity)
			local mag = realPartVelocity.Magnitude
			if mag > 1 then
				local unit = realPartVelocity.Unit
				if (unit.Y > 0.25) or (unit.Y < -0.75) then
					return unit * (25.1 / unit.Y)
				end
			end 
			return v3_net + realPartVelocity * v3_808
		end
		local simradius = "shp" --simulation radius (net bypass) method
--simulation radius (net bypass) method
--"shp" - sethiddenproperty
--"ssr" - setsimulationradius
--false - disable
local antiragdoll = true --removes hingeConstraints and ballSocketConstraints from your character
local newanimate = false --disables the animate script and enables after reanimation
local discharscripts = true --disables all localScripts parented to your character before reanimation
local R15toR6 = true --tries to convert your character to r6 if its r15
local hatcollide = true --makes hats cancollide (only method 0)
local humState16 = true --enables collisions for limbs before the humanoid dies (using hum:ChangeState)
local addtools = false --puts all tools from backpack to character and lets you hold them after reanimation
local hedafterneck = false --disable aligns for head and enable after neck is removed
local loadtime = game:GetService("Players").RespawnTime + 0.5 --anti respawn delay
local method = 0 --reanimation method
--methods:
--0 - breakJoints (takes [loadtime] seconds to laod)
--1 - limbs
--2 - limbs + anti respawn
--3 - limbs + breakJoints after [loadtime] seconds
--4 - remove humanoid + breakJoints
--5 - remove humanoid + limbs
local alignmode = 3 --AlignPosition mode
--modes:
--1 - AlignPosition rigidity enabled true
--2 - 2 AlignPositions rigidity enabled both true and false
--3 - AlignPosition rigidity enabled false

healthHide = healthHide and ((method == 0) or (method == 2) or (method == 000)) and gp(c, "Head", "BasePart")

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local stepped = rs.Stepped
local heartbeat = rs.Heartbeat
local renderstepped = rs.RenderStepped
local sg = game:GetService("StarterGui")
local ws = game:GetService("Workspace")
local cf = CFrame.new
local v3 = Vector3.new
local v3_0 = v3(0, 0, 0)
local inf = math.huge

local c = lp.Character

if not (c and c.Parent) then
	return
end

c.Destroying:Connect(function()
	c = nil
end)

local function gp(parent, name, className)
	if typeof(parent) == "Instance" then
		for i, v in pairs(parent:GetChildren()) do
			if (v.Name == name) and v:IsA(className) then
				return v
			end
		end
	end
	return nil
end

local function align(Part0, Part1)
	Part0.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.0001, 0.0001, 0.0001, 0.0001)

	local att0 = Instance.new("Attachment", Part0)
	att0.Orientation = v3_0
	att0.Position = v3_0
	att0.Name = "att0_" .. Part0.Name
	local att1 = Instance.new("Attachment", Part1)
	att1.Orientation = v3_0
	att1.Position = v3_0
	att1.Name = "att1_" .. Part1.Name

	if (alignmode == 1) or (alignmode == 2) then
		local ape = Instance.new("AlignPosition", att0)
		ape.ApplyAtCenterOfMass = false
		ape.MaxForce = inf
		ape.MaxVelocity = inf
		ape.ReactionForceEnabled = false
		ape.Responsiveness = 200
		ape.Attachment1 = att1
		ape.Attachment0 = att0
		ape.Name = "AlignPositionRtrue"
		ape.RigidityEnabled = true
	end

	if (alignmode == 2) or (alignmode == 3) then
		local apd = Instance.new("AlignPosition", att0)
		apd.ApplyAtCenterOfMass = false
		apd.MaxForce = inf
		apd.MaxVelocity = inf
		apd.ReactionForceEnabled = false
		apd.Responsiveness = 200
		apd.Attachment1 = att1
		apd.Attachment0 = att0
		apd.Name = "AlignPositionRfalse"
		apd.RigidityEnabled = false
	end

	local ao = Instance.new("AlignOrientation", att0)
	ao.MaxAngularVelocity = inf
	ao.MaxTorque = inf
	ao.PrimaryAxisOnly = false
	ao.ReactionTorqueEnabled = false
	ao.Responsiveness = 200
	ao.Attachment1 = att1
	ao.Attachment0 = att0
	ao.RigidityEnabled = false

	if type(getNetlessVelocity) == "function" then
	    local realVelocity = v3_0
        local steppedcon = stepped:Connect(function()
            Part0.Velocity = realVelocity
        end)
        local heartbeatcon = heartbeat:Connect(function()
            realVelocity = Part0.Velocity
            Part0.Velocity = getNetlessVelocity(realVelocity)
        end)
        Part0.Destroying:Connect(function()
            Part0 = nil
            steppedcon:Disconnect()
            heartbeatcon:Disconnect()
        end)
    end
end

local function respawnrequest()
	local ccfr = ws.CurrentCamera.CFrame
	local c = lp.Character
	lp.Character = nil
	lp.Character = c
	local con = nil
	con = ws.CurrentCamera.Changed:Connect(function(prop)
	    if (prop ~= "Parent") and (prop ~= "CFrame") then
	        return
	    end
	    ws.CurrentCamera.CFrame = ccfr
	    con:Disconnect()
    end)
end

local destroyhum = (method == 4) or (method == 5)
local breakjoints = (method == 0) or (method == 4)
local antirespawn = (method == 0) or (method == 2) or (method == 3)

hatcollide = hatcollide and (method == 0)

addtools = addtools and gp(lp, "Backpack", "Backpack")

local fenv = getfenv()
local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.set_hidden_prop or fenv.sethiddenprop
local ssr = fenv.setsimulationradius or fenv.set_simulation_radius or fenv.set_sim_radius or fenv.setsimradius or fenv.set_simulation_rad or fenv.setsimulationrad

if shp and (simradius == "shp") then
	spawn(function()
		while c and heartbeat:Wait() do
			shp(lp, "SimulationRadius", inf)
		end
	end)
elseif ssr and (simradius == "ssr") then
	spawn(function()
		while c and heartbeat:Wait() do
			ssr(inf)
		end
	end)
end

antiragdoll = antiragdoll and function(v)
	if v:IsA("HingeConstraint") or v:IsA("BallSocketConstraint") then
		v.Parent = nil
	end
end

if antiragdoll then
	for i, v in pairs(c:GetDescendants()) do
		antiragdoll(v)
	end
	c.DescendantAdded:Connect(antiragdoll)
end

if antirespawn then
	respawnrequest()
end

if method == 0 then
	wait(loadtime)
	if not c then
		return
	end
end

if discharscripts then
	for i, v in pairs(c:GetChildren()) do
		if v:IsA("LocalScript") then
			v.Disabled = true
		end
	end
elseif newanimate then
	local animate = gp(c, "Animate", "LocalScript")
	if animate and (not animate.Disabled) then
		animate.Disabled = true
	else
		newanimate = false
	end
end

if addtools then
	for i, v in pairs(addtools:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = c
		end
	end
end

pcall(function()
	settings().Physics.AllowSleep = false
	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
end)

local OLDscripts = {}

for i, v in pairs(c:GetDescendants()) do
	if v.ClassName == "Script" then
		table.insert(OLDscripts, v)
	end
end

local scriptNames = {}

for i, v in pairs(c:GetDescendants()) do
	if v:IsA("BasePart") then
		local newName = tostring(i)
		local exists = true
		while exists do
			exists = false
			for i, v in pairs(OLDscripts) do
				if v.Name == newName then
					exists = true
				end
			end
			if exists then
				newName = newName .. "_"    
			end
		end
		table.insert(scriptNames, newName)
		Instance.new("Script", v).Name = newName
	end
end

c.Archivable = true
local hum = c:FindFirstChildOfClass("Humanoid")
if hum then
	for i, v in pairs(hum:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end
local cl = c:Clone()
if hum and humState16 then
    hum:ChangeState(Enum.HumanoidStateType.Physics)
    if destroyhum then
        wait(1.6)
    end
end
if hum and hum.Parent and destroyhum then
    hum:Destroy()
end

if not c then
    return
end

local head = gp(c, "Head", "BasePart")
local torso = gp(c, "Torso", "BasePart") or gp(c, "UpperTorso", "BasePart")
local root = gp(c, "HumanoidRootPart", "BasePart")
if hatcollide and c:FindFirstChildOfClass("Accessory") then
    local anything = c:FindFirstChildOfClass("BodyColors") or gp(c, "Health", "Script")
    if not (torso and root and anything) then
        return
    end
    torso:Destroy()
    root:Destroy()
    if shp then
        for i,v in pairs(c:GetChildren()) do
            if v:IsA("Accessory") then
                shp(v, "BackendAccoutrementState", 0)
            end 
        end
    end
    anything:Destroy()
    if head then
       head:Destroy()
    end
end

for i, v in pairs(cl:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Transparency = 1
		v.Anchored = false
	end
end

local model = Instance.new("Model", c)
model.Name = model.ClassName

model.Destroying:Connect(function()
	model = nil
end)

for i, v in pairs(c:GetChildren()) do
	if v ~= model then
		if addtools and v:IsA("Tool") then
			for i1, v1 in pairs(v:GetDescendants()) do
				if v1 and v1.Parent and v1:IsA("BasePart") then
					local bv = Instance.new("BodyVelocity", v1)
					bv.Velocity = v3_0
					bv.MaxForce = v3(1000, 1000, 1000)
					bv.P = 1250
					bv.Name = "bv_" .. v.Name
				end
			end
		end
		v.Parent = model
	end
end

if breakjoints then
	model:BreakJoints()
else
	if head and torso then
		for i, v in pairs(model:GetDescendants()) do
			if v:IsA("Weld") or v:IsA("Snap") or v:IsA("Glue") or v:IsA("Motor") or v:IsA("Motor6D") then
				local save = false
				if (v.Part0 == torso) and (v.Part1 == head) then
					save = true
				end
				if (v.Part0 == head) and (v.Part1 == torso) then
					save = true
				end
				if save then
					if hedafterneck then
						hedafterneck = v
					end
				else
					v:Destroy()
				end
			end
		end
	end
	if method == 3 then
		spawn(function()
			wait(loadtime)
			if model then
				model:BreakJoints()
			end
		end)
	end
end

cl.Parent = c
for i, v in pairs(cl:GetChildren()) do
	v.Parent = c
end
cl:Destroy()

local modelDes = {}
for i, v in pairs(model:GetDescendants()) do
	if v:IsA("BasePart") then
		i = tostring(i)
		v.Destroying:Connect(function()
			modelDes[i] = nil
		end)
		modelDes[i] = v
	end
end
local modelcolcon = nil
local function modelcolf()
	if model then
		for i, v in pairs(modelDes) do
			v.CanCollide = false
		end
	else
		modelcolcon:Disconnect()
	end
end
modelcolcon = stepped:Connect(modelcolf)
modelcolf()

for i, scr in pairs(model:GetDescendants()) do
	if (scr.ClassName == "Script") and table.find(scriptNames, scr.Name) then
		local Part0 = scr.Parent
		if Part0:IsA("BasePart") then
			for i1, scr1 in pairs(c:GetDescendants()) do
				if (scr1.ClassName == "Script") and (scr1.Name == scr.Name) and (not scr1:IsDescendantOf(model)) then
					local Part1 = scr1.Parent
					if (Part1.ClassName == Part0.ClassName) and (Part1.Name == Part0.Name) then
						align(Part0, Part1)
						break
					end
				end
			end
		end
	end
end

if (typeof(hedafterneck) == "Instance") and head then
	local aligns = {}
	local con = nil
	con = hedafterneck.Changed:Connect(function(prop)
	    if (prop == "Parent") and not hedafterneck.Parent then
	        con:Disconnect()
    		for i, v in pairs(aligns) do
    			v.Enabled = true
    		end
		end
	end)
	for i, v in pairs(head:GetDescendants()) do
		if v:IsA("AlignPosition") or v:IsA("AlignOrientation") then
			i = tostring(i)
			aligns[i] = v
			v.Destroying:Connect(function()
			    aligns[i] = nil
			end)
			v.Enabled = false
		end
	end
end

for i, v in pairs(c:GetDescendants()) do
	if v and v.Parent then
		if v.ClassName == "Script" then
			if table.find(scriptNames, v.Name) then
				v:Destroy()
			end
		elseif not v:IsDescendantOf(model) then
			if v:IsA("Decal") then
				v.Transparency = 1
			elseif v:IsA("ForceField") then
				v.Visible = false
			elseif v:IsA("Sound") then
				v.Playing = false
			elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
				v.Enabled = false
			end
		end
	end
end

if newanimate then
	local animate = gp(c, "Animate", "LocalScript")
	if animate then
		animate.Disabled = false
	end
end

if addtools then
	for i, v in pairs(c:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = addtools
		end
	end
end

local hum0 = model:FindFirstChildOfClass("Humanoid")
if hum0 then
    hum0.Destroying:Connect(function()
        hum0 = nil
    end)
end

local hum1 = c:FindFirstChildOfClass("Humanoid")
if hum1 then
    hum1.Destroying:Connect(function()
        hum1 = nil
    end)
end

if hum1 then
	ws.CurrentCamera.CameraSubject = hum1
	local camSubCon = nil
	local function camSubFunc()
		camSubCon:Disconnect()
		if c and hum1 then
			ws.CurrentCamera.CameraSubject = hum1
		end
	end
	camSubCon = renderstepped:Connect(camSubFunc)
	if hum0 then
		hum0.Changed:Connect(function(prop)
			if hum1 and (prop == "Jump") then
				hum1.Jump = hum0.Jump
			end
		end)
	else
		respawnrequest()
	end
end

local rb = Instance.new("BindableEvent", c)
rb.Event:Connect(function()
	rb:Destroy()
	sg:SetCore("ResetButtonCallback", true)
	if destroyhum then
		c:BreakJoints()
		return
	end
	if hum0 and (hum0.Health > 0) then
		model:BreakJoints()
		hum0.Health = 0
	end
	if antirespawn then
	    respawnrequest()
	end
end)
sg:SetCore("ResetButtonCallback", rb)

spawn(function()
	while c do
		if hum0 and hum1 then
			hum1.Jump = hum0.Jump
		end
		wait()
	end
	sg:SetCore("ResetButtonCallback", true)
end)

R15toR6 = R15toR6 and hum1 and (hum1.RigType == Enum.HumanoidRigType.R15)
if R15toR6 then
    local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
	if part then
	    local cfr = part.CFrame
		local R6parts = { 
			head = {
				Name = "Head",
				Size = v3(2, 1, 1),
				R15 = {
					Head = 0
				}
			},
			torso = {
				Name = "Torso",
				Size = v3(2, 2, 1),
				R15 = {
					UpperTorso = 0.2,
					LowerTorso = -100
				}
			},
			root = {
				Name = "HumanoidRootPart",
				Size = v3(2, 2, 1),
				R15 = {
					HumanoidRootPart = 0
				}
			},
			leftArm = {
				Name = "Left Arm",
				Size = v3(1, 2, 1),
				R15 = {
					LeftHand = -0.73,
					LeftLowerArm = -0.2,
					LeftUpperArm = 0.4
				}
			},
			rightArm = {
				Name = "Right Arm",
				Size = v3(1, 2, 1),
				R15 = {
					RightHand = -0.73,
					RightLowerArm = -0.2,
					RightUpperArm = 0.4
				}
			},
			leftLeg = {
				Name = "Left Leg",
				Size = v3(1, 2, 1),
				R15 = {
					LeftFoot = -0.73,
					LeftLowerLeg = -0.15,
					LeftUpperLeg = 0.6
				}
			},
			rightLeg = {
				Name = "Right Leg",
				Size = v3(1, 2, 1),
				R15 = {
					RightFoot = -0.73,
					RightLowerLeg = -0.15,
					RightUpperLeg = 0.6
				}
			}
		}
		for i, v in pairs(c:GetChildren()) do
			if v:IsA("BasePart") then
				for i1, v1 in pairs(v:GetChildren()) do
					if v1:IsA("Motor6D") then
						v1.Part0 = nil
					end
				end
			end
		end
		part.Archivable = true
		for i, v in pairs(R6parts) do
			local part = part:Clone()
			part:ClearAllChildren()
			part.Name = v.Name
			part.Size = v.Size
			part.CFrame = cfr
			part.Anchored = false
			part.Transparency = 1
			part.CanCollide = false
			for i1, v1 in pairs(v.R15) do
				local R15part = gp(c, i1, "BasePart")
				local att = gp(R15part, "att1_" .. i1, "Attachment")
				if R15part then
					local weld = Instance.new("Weld", R15part)
					weld.Name = "Weld_" .. i1
					weld.Part0 = part
					weld.Part1 = R15part
					weld.C0 = cf(0, v1, 0)
					weld.C1 = cf(0, 0, 0)
					R15part.Massless = true
					R15part.Name = "R15_" .. i1
					R15part.Parent = part
					if att then
						att.Parent = part
						att.Position = v3(0, v1, 0)
					end
				end
			end
			part.Parent = c
			R6parts[i] = part
		end
		local R6joints = {
			neck = {
				Parent = R6parts.torso,
				Name = "Neck",
				Part0 = R6parts.torso,
				Part1 = R6parts.head,
				C0 = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
				C1 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
			},
			rootJoint = {
				Parent = R6parts.root,
				Name = "RootJoint" ,
				Part0 = R6parts.root,
				Part1 = R6parts.torso,
				C0 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
				C1 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
			},
			rightShoulder = {
				Parent = R6parts.torso,
				Name = "Right Shoulder",
				Part0 = R6parts.torso,
				Part1 = R6parts.rightArm,
				C0 = cf(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				C1 = cf(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			},
			leftShoulder = {
				Parent = R6parts.torso,
				Name = "Left Shoulder",
				Part0 = R6parts.torso,
				Part1 = R6parts.leftArm,
				C0 = cf(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = cf(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			},
			rightHip = {
				Parent = R6parts.torso,
				Name = "Right Hip",
				Part0 = R6parts.torso,
				Part1 = R6parts.rightLeg,
				C0 = cf(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
				C1 = cf(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			},
			leftHip = {
				Parent = R6parts.torso,
				Name = "Left Hip" ,
				Part0 = R6parts.torso,
				Part1 = R6parts.leftLeg,
				C0 = cf(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = cf(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			}
		}
		for i, v in pairs(R6joints) do
			local joint = Instance.new("Motor6D")
			for prop, val in pairs(v) do
				joint[prop] = val
			end
			R6joints[i] = joint
		end
		hum1.RigType = Enum.HumanoidRigType.R6
		hum1.HipHeight = 0
	end
end



--find rig joints

local function fakemotor()
    return {C0=cf(), C1=cf()}
end

local torso = gp(c, "Torso", "BasePart")
local root = gp(c, "HumanoidRootPart", "BasePart")

local neck = gp(torso, "Neck", "Motor6D")
neck = neck or fakemotor()

local rootJoint = gp(root, "RootJoint", "Motor6D")
rootJoint = rootJoint or fakemotor()

local leftShoulder = gp(torso, "Left Shoulder", "Motor6D")
leftShoulder = leftShoulder or fakemotor()

local rightShoulder = gp(torso, "Right Shoulder", "Motor6D")
rightShoulder = rightShoulder or fakemotor()

local leftHip = gp(torso, "Left Hip", "Motor6D")
leftHip = leftHip or fakemotor()

local rightHip = gp(torso, "Right Hip", "Motor6D")
rightHip = rightHip or fakemotor()

--120 fps

local fps = 40
local event = Instance.new("BindableEvent", c)
event.Name = "120 fps"
local floor = math.floor
fps = 1 / fps
local tf = 0
local con = nil
con = game:GetService("RunService").RenderStepped:Connect(function(s)
	if not c then
		con:Disconnect()
		return
	end
    --tf += s
	if tf >= fps then
		for i=1, floor(tf / fps) do
			event:Fire(c)
		end
		tf = 0
	end
end)
local event = event.Event

local hedrot = v3(0, 5, 0)

local uis = game:GetService("UserInputService")
local function isPressed(key)
    return (not uis:GetFocusedTextBox()) and uis:IsKeyDown(Enum.KeyCode[key])
end

local biggesthandle = nil
for i, v in pairs(c:GetChildren()) do
    if v:IsA("Accessory") then
        local handle = gp(v, "Handle", "BasePart")
        if biggesthandle then
            if Surfboard.Size.Magnitude < handle.Size.Magnitude then
                biggesthanlde = handle
            end
       else
            biggesthanlde = gp(v, "Handle", "BasePart")
        end
    end
end

if not biggesthanlde then
    return
end

local handle1 = gp(gp(model, biggesthanlde.Parent.Name, "Accessory"), "Handle", "BasePart")
if not handle1 then
    return
end

handle1.Destroying:Connect(function()
    handle1 = nil
end)
biggesthanlde.Destroying:Connect(function()
    biggesthanlde = nil
end)

--biggesthandle:BreakJoints()
--biggesthandle.Anchored = true

--for i, v in pairs(handle1:GetDescendants()) do
    --if v:IsA("AlignOrientation") then
       -- v.Enabled = false
  -- end
--end

--local mouse = lp:GetMouse()
--local fling = false
--mouse.Button1Down:Connect(function()
    --fling = true
--end)
--mouse.Button1Up:Connect(function()
    --fling = false
--end)
local function doForSignal(signal, vel)
    spawn(function()
        while signal:Wait() and c and handle1 and biggesthanlde do
            if fling and mouse.Target then
                biggesthanlde.Position = mouse.Hit.Position --biggesthanlde
            end
            --handle1.RotVelocity = vel
        end
    end)
end
doForSignal(stepped, v3(100, 100, 100))
doForSignal(renderstepped, v3(100, 100, 100))
doForSignal(heartbeat, v3(200000000000000000000, 2000000000000000000, 20000000000000000)) --https://web.roblox.com/catalog/63690008/Pal-Hair

local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local stepped = rs.Stepped
local heartbeat = rs.Heartbeat
local renderstepped = rs.RenderStepped
local sg = game:GetService("StarterGui")
local ws = game:GetService("Workspace")
local cf = CFrame.new
local v3 = Vector3.new
local v3_0 = Vector3.zero
local inf = math.huge

local cplayer = lp.Character

local v3 = Vector3.new

local function gp(parent, name, className)
    if typeof(parent) == "Instance" then
        for i, v in pairs(parent:GetChildren()) do
            if (v.Name == name) and v:IsA(className) then
                return v
            end
        end
    end
    return nil
end

local hat2 = gp(cplayer, "LUAhEAD", "Accessory")
local handle2 = gp(hat2, "Handle", "BasePart")
local att2 = gp(handle2, "att1_Handle", "Attachment")
att2.Parent = cplayer["Torso"]
att2.Position = Vector3.new(-0, -0, 0)
att2.Rotation = Vector3.new(90, 0, 0)


local hat2 = gp(cplayer, "Pink Hair", "Accessory")
local handle2 = gp(hat2, "Handle", "BasePart")
local att2 = gp(handle2, "att1_Handle", "Attachment")
att2.Parent = cplayer["Left Arm"]
att2.Position = Vector3.new(0, -0, 0)
att2.Rotation = Vector3.new(90, 0, 0)

local hat2 = gp(cplayer, "Kate Hair", "Accessory")
local handle2 = gp(hat2, "Handle", "BasePart")
local att2 = gp(handle2, "att1_Handle", "Attachment")
att2.Parent = cplayer["Right Arm"]
att2.Position = Vector3.new(0, -0, 0)
att2.Rotation = Vector3.new(90, 0, 0) --LavanderHair

local hat2 = gp(cplayer, "LavanderHair", "Accessory")
local handle2 = gp(hat2, "Handle", "BasePart")
local att2 = gp(handle2, "att1_Handle", "Attachment")
att2.Parent = cplayer["Right Leg"]
att2.Position = Vector3.new(0, -0, 0) --Robloxclassicred
att2.Rotation = Vector3.new(90, 0, 0)

local hat2 = gp(cplayer, "Robloxclassicred", "Accessory")
local handle2 = gp(hat2, "Handle", "BasePart")
local att2 = gp(handle2, "att1_Handle", "Attachment")
att2.Parent = cplayer["Left Leg"]
att2.Position = Vector3.new(0, -0, 0) 
att2.Rotation = Vector3.new(90, 0, 0) 

--z = Instance.new("Sound", Char)
--z.SoundId = "rbxassetid://1837768323"--242463565
--z.Looped = true
--z.Pitch = .8
--z.Volume = 1.75
--z:Play()


Player=game.Players.LocalPlayer
Character=Player.Character
hum = Character.Humanoid
LeftArm=Character["Left Arm"]
LeftLeg=Character["Left Leg"]
RightArm=Character["Right Arm"]
RightLeg=Character["Right Leg"]
Root=Character["HumanoidRootPart"]
Head=Character["Head"]
Torso=Character["Torso"]
Neck=Torso["Neck"]
walking = false
attacking = false
tauntdebounce = false
themeallow = true
secondform = false
position = nil
MseGuide = true
equipping = false
settime = 0
sine = 0
ws = 16
change = 1
dgs = 75
RunSrv = game:GetService("RunService")
RenderStepped = game:GetService("RunService").RenderStepped
removeuseless = game:GetService("Debris")
smoothen = game:GetService("TweenService")
cam = workspace.CurrentCamera
local armorparts = {}
local dmt2 = {1837768323,9048376021,9038254260,7023635858,1837807891,9039704032}
combo1 = true
combo2 = false
combo3 = false
combo4 = false
local bloodfolder = Instance.new("Folder",Torso)
local tauntable = {3493125551,3493128152,3493130715,3493305976,3493316200,3493334982,3493370895,3493372969,3493382339,3493384428}
local killable = {3493244407,3493249574,3493297656,3493301150,3493312467,3493319499,3493325658,3493328969,3493332011,3493356644,3493359848,3493368055,3493376612}

screenGui = Instance.new("ScreenGui")
screenGui.Parent = script.Parent

local HEADLERP = Instance.new("ManualWeld")
HEADLERP.Parent = Head
HEADLERP.Part0 = Head
HEADLERP.Part1 = Head
HEADLERP.C0 = CFrame.new(0, -1.5, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local TORSOLERP = Instance.new("ManualWeld")
TORSOLERP.Parent = Root
TORSOLERP.Part0 = Torso
TORSOLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local ROOTLERP = Instance.new("ManualWeld")
ROOTLERP.Parent = Root
ROOTLERP.Part0 = Root
ROOTLERP.Part1 = Torso
ROOTLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local RIGHTARMLERP = Instance.new("ManualWeld")
RIGHTARMLERP.Parent = RightArm
RIGHTARMLERP.Part0 = RightArm
RIGHTARMLERP.Part1 = Torso
RIGHTARMLERP.C0 = CFrame.new(-1.5, 0, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local LEFTARMLERP = Instance.new("ManualWeld")
LEFTARMLERP.Parent = LeftArm
LEFTARMLERP.Part0 = LeftArm
LEFTARMLERP.Part1 = Torso
LEFTARMLERP.C0 = CFrame.new(1.5, 0, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local RIGHTLEGLERP = Instance.new("ManualWeld")
RIGHTLEGLERP.Parent = RightLeg
RIGHTLEGLERP.Part0 = RightLeg
RIGHTLEGLERP.Part1 = Torso
RIGHTLEGLERP.C0 = CFrame.new(-0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local LEFTLEGLERP = Instance.new("ManualWeld")
LEFTLEGLERP.Parent = LeftLeg
LEFTLEGLERP.Part0 = LeftLeg
LEFTLEGLERP.Part1 = Torso
LEFTLEGLERP.C0 = CFrame.new(0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local function weldBetween(a, b)
    local weld = Instance.new("ManualWeld", a)
    weld.Part0 = a
    weld.Part1 = b
    weld.C0 = a.CFrame:inverse() * b.CFrame
    return weld
end

function MAKETRAIL(PARENT,POSITION1,POSITION2,LIFETIME,COLOR)
A = Instance.new("Attachment", PARENT)
A.Position = POSITION1
A.Name = "A"
B = Instance.new("Attachment", PARENT)
B.Position = POSITION2
B.Name = "B"
x = Instance.new("Trail", PARENT)
x.Attachment0 = A
x.Attachment1 = B
x.Enabled = true
x.Lifetime = LIFETIME
x.TextureMode = "Static"
x.LightInfluence = 0
x.Color = COLOR
x.Transparency = NumberSequence.new(0, 1)
end

function ray(pos, di, ran, ignore)
	return workspace:FindPartOnRay(Ray.new(pos, di.unit * ran), ignore)
end

function ray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return ray(StartPos, di, Distance, Ignore)
end

function colortween(a,speed,color1)
local z = {
Color = color1
}
local tween = smoothen:Create(a,TweenInfo.new(speed,Enum.EasingStyle.Linear),z)
tween:Play()
end

function takeDamage(victim,damage)
if victim.MaxHealth < 50000 and victim ~= hum then
victim.Health = victim.Health - damage
if victim.Health < 1 then
killtaunt()
end
else
victim.Parent:BreakJoints()
killtaunt()
end
end

function taunt()
coroutine.wrap(function()
if tauntdebounce then return end
tauntdebounce = true
rdnm2 = tauntable[math.random(1,#tauntable)]
for i = 1, 3 do
coroutine.wrap(function()
tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "http://www.roblox.com/asset/?id="..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = 1
tauntsound:Play()
wait(3)
wait(tauntsound.TimeLength)
tauntsound:Remove()
wait(1)
tauntdebounce = false
end)()
end
end)()
end

function killtaunt()
coroutine.wrap(function()
if tauntdebounce then return end
tauntdebounce = true
rdnm2 = killable[math.random(1,#killable)]
for i = 1, 3 do
coroutine.wrap(function()
tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "http://www.roblox.com/asset/?id="..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = 1
tauntsound:Play()
wait(3)
wait(tauntsound.TimeLength)
tauntsound:Remove()
wait(1)
tauntdebounce = false
end)()
end
end)()
end

function velo(a,name,pos,speed)
local bov = Instance.new("BodyVelocity",a)
bov.Name = name
bov.maxForce = Vector3.new(99999,99999,99999)
a.CFrame = CFrame.new(a.Position,pos)
bov.velocity = a.CFrame.lookVector*speed
end
function bolt(parent,from,too,endtarget,color,size)
local function iray(pos, di, ran, ignore)
local ing={endtarget}
	return workspace:FindPartOnRayWithWhitelist(Ray.new(pos, di.unit * ran), ing)
end
local function iray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return iray(StartPos, di, Distance, Ignore)
end
lastposition = from
local step = 16
local distance = (from-too).magnitude
for i = 1,distance, step do
local from = lastposition
local too = from + -(from-too).unit*step+ Vector3.new(math.random(-10,10),math.random(-10,10),math.random(-10,10))
local bolt = Instance.new("Part",parent)
bolt.Size = Vector3.new(size,size,(from-too).magnitude)
bolt.Anchored = true
bolt.CanCollide = false
bolt.BrickColor = color
bolt.Material = "Neon"
bolt.CFrame = CFrame.new(from:lerp(too,.5),too)
lastposition = too
coroutine.wrap(function()
for i = 1, 5 do
bolt.Transparency = bolt.Transparency + .2
wait()
end
bolt:Remove()
end)()
end
local lastbolt = Instance.new("Part",parent)
lastbolt.Size = Vector3.new(1,1,(from-too).magnitude)
lastbolt.Anchored = true
lastbolt.CanCollide = false
lastbolt.BrickColor = color
lastbolt.Material = "Neon"
lastbolt.CFrame = CFrame.new(lastposition,too)
lastbolt.Size = Vector3.new(size,size,size)
local start = lastposition
local hit,endp = iray2(lastposition,too,650,workspace.Base)
local dis = (start - endp).magnitude
lastbolt.CFrame = CFrame.new(lastposition,too) * CFrame.new(0,0,-dis/2)
lastbolt.Size = Vector3.new(size,size,dis)
coroutine.wrap(function()
for i = 1, 5 do
lastbolt.Transparency = lastbolt.Transparency + .2
wait()
end
lastbolt:Remove()
end)()
end

dmt2random = dmt2[math.random(1,#dmt2)]
doomtheme = Instance.new("Sound", Torso)
doomtheme.Volume = 0
doomtheme.Name = "doomtheme"
doomtheme.Looped = false
doomtheme.SoundId = "rbxassetid://"..dmt2random
doomtheme:Play()
coroutine.wrap(function()
while wait() do
pcall(function()
doomtheme.Ended:Wait()
dmt2random = dmt2[math.random(1,#dmt2)]
doomtheme.SoundId = "rbxassetid://"..dmt2random
doomtheme:Play()
end)
end
end)()

Torso.ChildRemoved:connect(function(removed)
if removed.Name == "doomtheme" then
dmt2random = dmt2[math.random(1,#dmt2)]
doomtheme = Instance.new("Sound",Torso)
doomtheme.SoundId = "rbxassetid://"..dmt2random
if equip then
doomtheme.Volume = 3
else
doomtheme.Volume = 0
end
doomtheme.Name = "doomtheme"
doomtheme.Looped = true
doomtheme:Play()
end
end)

coroutine.wrap(function()
while wait() do
hum.WalkSpeed = ws
hum.JumpPower = 75
end
end)()
godmode = coroutine.wrap(function()
for i,v in pairs(Character:GetChildren()) do
if v:IsA("BasePart") and v ~= Root then
v.Anchored = false
end
end
while true do
hum.MaxHealth = math.huge
wait(0.0000001)
hum.Health = math.huge
swait()
end
end)
godmode()
ff = Instance.new("ForceField", Character)
ff.Visible = false

pcall(function()
----defaultpos----
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,0,0) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)), 0.2)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0,0) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)), 0.2)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),.2)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), 0.2)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), 0.2)
----defaultpos----
end)

function damagealll(Radius,Position)		
	local Returning = {}		
	for _,v in pairs(workspace:GetChildren()) do		
		if v~=Character and v:FindFirstChildOfClass('Humanoid') and v:FindFirstChild('Torso') or v:FindFirstChild('UpperTorso') then
if v:FindFirstChild("Torso") then		
			local Mag = (v.Torso.Position - Position).magnitude		
			if Mag < Radius then		
				table.insert(Returning,v)		
			end
elseif v:FindFirstChild("UpperTorso") then	
			local Mag = (v.UpperTorso.Position - Position).magnitude		
			if Mag < Radius then		
				table.insert(Returning,v)		
			end
end	
		end		
	end		
	return Returning		
end

function swait(num)
	if num == 0 or num == nil then
		game:service("RunService").Stepped:wait(0)
	else
		for i = 0, num do
			game:service("RunService").Stepped:wait(0)
		end
	end
end

function SOUND(PARENT,ID,VOL,LOOP,PITCH,REMOVE)
local so = Instance.new("Sound")
so.Parent = PARENT
so.SoundId = "rbxassetid://"..ID
so.Volume = VOL
so.Looped = LOOP
so.Pitch = PITCH
so:Play()
removeuseless:AddItem(so,REMOVE)
end

function meshify(parent,scale,mid,tid)
local mesh = Instance.new("SpecialMesh",parent)
mesh.Name = "mesh"
mesh.Scale = scale
mesh.MeshId = "rbxassetid://"..mid
mesh.TextureId = "rbxassetid://"..tid
end

function blocktrail(position,size,trans,mat,color)
local trailblock = Instance.new("Part",Torso)
trailblock.Anchored = true
trailblock.CanCollide = false
trailblock.Transparency = trans
trailblock.Material = mat
trailblock.BrickColor = color
trailblock.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
trailblock.Size = size
coroutine.wrap(function()
for i = 1, 20 do
trailblock.Transparency = trailblock.Transparency + .05
trailblock.Size = trailblock.Size - trailblock.Size/20
swait()
end
trailblock:Remove()
end)()
end


function blood(parent,intensity)
coroutine.wrap(function()
local particlemiter1 = Instance.new("ParticleEmitter", parent)
particlemiter1.Enabled = true
particlemiter1.Color = ColorSequence.new(BrickColor.new("Crimson").Color)
particlemiter1.Texture = "rbxassetid://1391189545"
particlemiter1.Lifetime = NumberRange.new(.6)
particlemiter1.Size = NumberSequence.new(3,3)
particlemiter1.Transparency = NumberSequence.new(0,1)
particlemiter1.Rate = intensity
particlemiter1.Rotation = NumberRange.new(0,360)
particlemiter1.Speed = NumberRange.new(6)
particlemiter1.SpreadAngle = Vector2.new(180,180)
wait(.2)
particlemiter1.Enabled = false
removeuseless:AddItem(particlemiter1,10)
end)()
coroutine.wrap(function()
for i = 1, 10 do
local ray = Ray.new(parent.Position, Vector3.new(0,-25,0))
local part, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {bloodfolder,parent.Parent,bloc,Character,blooddecal,blowd,Torso},false,true)
if part and part.Parent ~= parent.Parent and not part.Parent:FindFirstChildOfClass("Humanoid") then
local vbn = math.random(5,15)
coroutine.wrap(function()
local blooddecal = Instance.new("Part",bloodfolder)
blooddecal.Size =  Vector3.new(vbn,.1,vbn)
blooddecal.Transparency = 1
blooddecal.Anchored = true
blooddecal.Name = "blowd"
blooddecal.CanCollide = false
blooddecal.Position = hitPosition 
blooddecal.Rotation = Vector3.new(0,math.random(-180,180),0)
local blood = Instance.new("Decal",blooddecal)
blood.Face = "Top"
blood.Texture = "rbxassetid://1391189545"
blood.Transparency = math.random(.1,.4)
wait(60)
for i = 1, 100 do
blood.Transparency = blood.Transparency + .01
swait()
end
blooddecal:Destroy()
end)()
else
end
swait()
end
end)()
end

function shockwave(position,scale,transparency,brickcolor,speed,transparencyincrease)
coroutine.wrap(function()
local shockwave = Instance.new("Part", Torso)
shockwave.Size = Vector3.new(1,1,1)
shockwave.CanCollide = false
shockwave.Anchored = true
shockwave.Transparency = transparency
shockwave.BrickColor = brickcolor
shockwave.CFrame = position
local shockwavemesh = Instance.new("SpecialMesh", shockwave)
shockwavemesh.Scale = Vector3.new(1,.25,1)
shockwavemesh.MeshId = "rbxassetid://20329976"
local shockwave2 = Instance.new("Part", Torso)
shockwave2.Size = Vector3.new(1,1,1)
shockwave2.CanCollide = false
shockwave2.Anchored = true
shockwave2.Transparency = shockwave.Transparency
shockwave2.BrickColor = shockwave.BrickColor
shockwave2.CFrame = shockwave.CFrame
local shockwavemesh2 = Instance.new("SpecialMesh", shockwave2)
shockwavemesh2.Scale = Vector3.new(1,.25,1)
shockwavemesh2.MeshId = "rbxassetid://20329976"
for i = 1, 40 do
shockwave.CFrame = shockwave.CFrame * CFrame.Angles(math.rad(0),math.rad(0+speed),0)
shockwave2.CFrame = shockwave2.CFrame * CFrame.Angles(math.rad(0),math.rad(0-speed),0)
shockwave.Transparency = shockwave.Transparency + transparencyincrease
shockwave2.Transparency = shockwave2.Transparency + transparencyincrease
shockwavemesh2.Scale = shockwavemesh2.Scale + scale
shockwavemesh.Scale = shockwavemesh.Scale + scale
swait()
end
shockwave:Destroy()
shockwave2:Destroy()
end)()
end

function blockyeffect(brickcolor,size,trans,posi,mater,spread)
local blocky = Instance.new("Part",Torso)
blocky.Anchored = true
blocky.CanCollide = false
blocky.BrickColor = brickcolor
blocky.Size = size
blocky.Transparency = trans
blocky.CFrame = posi * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
blocky.Material = mater
local locbloc = Instance.new("Part",Torso)
locbloc.Anchored = true
locbloc.CanCollide = false
locbloc.Transparency = 1
locbloc.Size = Vector3.new(1,1,1)
locbloc.CFrame = blocky.CFrame * CFrame.new(math.random(-spread,spread),math.random(-spread,spread),math.random(-spread,spread))
coroutine.wrap(function()
local a = math.random(-180,180)
local b = math.random(-180,180)
local c = math.random(-180,180)
for i = 1, 20 do
blocky.CFrame = blocky.CFrame:lerp(CFrame.new(locbloc.Position) * CFrame.Angles(math.rad(a),math.rad(b),math.rad(c)),.2)
blocky.Transparency = blocky.Transparency + .05
swait()
end
blocky:Remove()
locbloc:Remove()
end)()
end

coroutine.wrap(function()
for i,v in pairs(Character:GetChildren()) do
if v.Name == "Animate" then
end
end
end)()

leftlocation = Instance.new("Part",LeftArm)
leftlocation.Size = Vector3.new(1,1,1)
leftlocation.Transparency = 1
leftlocation.CanCollide = false
leftlocationweld = weldBetween(leftlocation,LeftArm)
leftlocationweld.C0 = CFrame.new(0,1.2,0)
rightlocation = Instance.new("Part",RightArm)
rightlocation.Size = Vector3.new(1,1,1)
rightlocation.CanCollide = false
rightlocation.Transparency = 1
rightlocationweld = weldBetween(rightlocation,RightArm)
rightlocationweld.C0 = CFrame.new(0,1.2,0)
leftlocation2 = Instance.new("Part",LeftLeg)
leftlocation2.Size = Vector3.new(1,1,1)
leftlocation2.CanCollide = false
leftlocation2.Transparency = 1
leftlocationweld2 = weldBetween(leftlocation2,LeftLeg)
leftlocationweld2.C0 = CFrame.new(0,2,0)
rightlocation2 = Instance.new("Part",RightLeg)
rightlocation2.Size = Vector3.new(1,1,1)
rightlocation2.CanCollide = false
rightlocation2.Transparency = 1
rightlocationweld2 = weldBetween(rightlocation2,RightLeg)
rightlocationweld2.C0 = CFrame.new(0,2,0)

whandel = Instance.new("Part",Torso)
whandel.Size = Vector3.new(1,1,1)
whandel.Name = 'DeathMF'
whandel.Transparency = 1
whandel.Anchored = false
whandel.CanCollide = false
whandel.BrickColor = BrickColor.new("Navy blue")
whandelweld = weldBetween(whandel,Torso)
whandelweld.C0 = CFrame.new(0,-.6,-.75) * CFrame.Angles(math.rad(-10),math.rad(0),math.rad(-135))
whandelmesh = Instance.new("SpecialMesh",whandel)
whandelmesh.MeshId = "rbxassetid://3447918423"
--Surfboard

game:GetService("Players").LocalPlayer.Character["Surfboard"].Handle.att1_Handle.Parent = whandel
whandel.att1_Handle.Rotation = Vector3.new(-90,0,90)
whandel.att1_Handle.Position = Vector3.new(-0,0.5,0)

wmain = Instance.new("Part",Torso)
wmain.Size = Vector3.new(1,1,1)
wmain.Anchored = false
wmain.Transparency = 1
wmain.CanCollide = false
wmain.BrickColor = BrickColor.new("Dark grey")
wmainweld = weldBetween(wmain,whandel)
wmainweld.C0 = CFrame.new(0,-1.45,0) * CFrame.Angles(0,math.rad(90),0)
wmainmesh = Instance.new("SpecialMesh",wmain)
wmainmesh.MeshId = "rbxassetid://3447905639"

game:GetService("Players").LocalPlayer.Character["VANS_Umbrella"].Handle.att1_Handle.Parent = wmain
wmain.att1_Handle.Rotation = Vector3.new(0,0,0)
wmain.att1_Handle.Position = Vector3.new(-0,4.75,0)

wright = Instance.new("Part",Torso)
wright.Size = Vector3.new(1,1,1)
wright.CanCollide = false
wright.Anchored = false
wright.Transparency = 1
wrightweld = weldBetween(wright,wmain)
wrightweld.C0 = CFrame.new(0,0,1.2)

wleft = Instance.new("Part",Torso)
wleft.Size = Vector3.new(1,1,1)
wleft.CanCollide = false
wleft.Anchored = false
wleft.Transparency = 1
wleftweld = weldBetween(wleft,wmain)
wleftweld.C0 = CFrame.new(0,0,-1.2)

A = Instance.new("Attachment", wleft)
A.Position = Vector3.new(0,.5,0)
A.Name = "A"
B = Instance.new("Attachment", wleft)
B.Position = Vector3.new(0,-.5,0)
B.Name = "B"
tr1 = Instance.new("Trail", wleft)
tr1.Attachment0 = A
tr1.Attachment1 = B
tr1.Enabled = false
tr1.Lifetime = .8
tr1.TextureMode = "Static"
tr1.LightInfluence = 0
tr1.Color = ColorSequence.new(BrickColor.new("White").Color,BrickColor.new("Really black").Color)
tr1.Transparency = NumberSequence.new(0, 1)

A = Instance.new("Attachment", wright)
A.Position = Vector3.new(0,.5,0)
A.Name = "A"
B = Instance.new("Attachment", wright)
B.Position = Vector3.new(0,-.5,0)
B.Name = "B"
tr2 = Instance.new("Trail", wright)
tr2.Attachment0 = A
tr2.Attachment1 = B
tr2.Enabled = false
tr2.Lifetime = .8
tr2.TextureMode = "Static"
tr2.LightInfluence = 0
tr2.Color = ColorSequence.new(BrickColor.new("White").Color,BrickColor.new("Really black").Color)
tr2.Transparency = NumberSequence.new(0, 1)

wspikes = Instance.new("Part",Torso)
wspikes.Size = Vector3.new(1,1,1)
wspikes.Transparency = 1
wspikes.Anchored = false
wspikes.CanCollide = false
wspikes.BrickColor = BrickColor.new("Medium stone grey")
wspikesweld = weldBetween(wspikes,wmain)
wspikesweld.C0 = CFrame.new(0,0,0) * CFrame.Angles(0,math.rad(0),0)
wspikesmesh = Instance.new("SpecialMesh",wspikes)
wspikesmesh.MeshId = "rbxassetid://3448020685"

wmain2 = Instance.new("Part",Torso)
wmain2.Size = Vector3.new(1,1,1)
wmain2.Anchored = false
wmain2.Transparency = 1
wmain2.CanCollide = false
wmain2.BrickColor = BrickColor.new("Really black")
wmainweld2 = weldBetween(wmain2,wmain)
wmainweld2.C0 = CFrame.new(0,0,0) * CFrame.Angles(0,math.rad(0),0)
wmainmesh2 = Instance.new("SpecialMesh",wmain2)
wmainmesh2.MeshId = "rbxassetid://3447912823"
local mouse = Player:GetMouse()
mouse.Button1Down:connect(function()
if combo1 then
if not equip then return end
if debounce then return end 
combo1 = false
combo2 = true
combo3 = false
combo4 = false
debounce = true
attacking = true
ws = 13
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(0,90000,0)
for i = 1, 15 do
g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.15)
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-2.15,-1.7,-.35) * CFrame.Angles(math.rad(90),math.rad(-90),math.rad(0)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(0), math.rad(50), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.1,0.7,0.4)*CFrame.Angles(math.rad(-88.4),math.rad(21.9),math.rad(-10.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,2,0)*CFrame.Angles(math.rad(-2.5),math.rad(-0.1),math.rad(2.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1,0.6,0.2)*CFrame.Angles(math.rad(-94.7),math.rad(-31.9),math.rad(-4.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,2,0.4)*CFrame.Angles(math.rad(2.9),math.rad(50.3),math.rad(-4.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
swait()
end
local bloc = Instance.new("Part",Torso)
bloc.Anchored = true
bloc.CanCollide = false
bloc.Size = Vector3.new(1,1,1)
bloc.Transparency = 1
bloc.Name = "bloc"
bloc.CFrame = Root.CFrame * CFrame.new(0,0,-5)
--Hit = damagealll(4,bloc.Position)
--for _,v in pairs(Hit) do
--if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
--slachtoffer = v:FindFirstChildOfClass("Humanoid")
--takeDamage(slachtoffer,math.random(29,42))
--vel = Instance.new("BodyVelocity",v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")) 
--vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
--torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
--vel.velocity = CFrame.new(wmain.Position,torso.Position).lookVector*75
--SOUND(torso,2801263,5,false,math.random(7,8)/10,6)
--blood(torso,200)
--removeuseless:AddItem(vel,.1)
--end
--end
SOUND(wmain,1306070008,5,false,math.random(7,9)/10,10)
tr1.Enabled = true
tr2.Enabled = true
for i = 1, 15 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-2.6,-1.5,-.35) * CFrame.Angles(math.rad(90),math.rad(-10),math.rad(0)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(0), math.rad(-70), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0.8,1.4,0.9)*CFrame.Angles(math.rad(-51.1),math.rad(-52.4),math.rad(1.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.4,2.1,0.2)*CFrame.Angles(math.rad(-7.5),math.rad(-37),math.rad(3.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.2,1.3,0)*CFrame.Angles(math.rad(-68.7),math.rad(30.1),math.rad(-28.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.5,2.1,0.3)*CFrame.Angles(math.rad(-4.4),math.rad(40.2),math.rad(0.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
swait()
end
ws = 29
removeuseless:AddItem(g1,.001)
tr1.Enabled = false
tr2.Enabled = false
removeuseless:AddItem(bloc,6)
debounce = false
attacking = false
elseif combo2 then
if not equip then return end
if debounce then return end
combo1 = false
combo2 = false
combo3 = true
combo4 = false
debounce = true
attacking = true
ws = 13
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(0,90000,0)
for i = 1, 12 do
g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.15)
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(1.2,-2.8,.15) * CFrame.Angles(0,math.rad(90),math.rad(55)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(0), math.rad(-30), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.1,0,0.3)*CFrame.Angles(math.rad(-91.1),math.rad(49.7),math.rad(0.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,1.3,0.9)*CFrame.Angles(math.rad(18.3),math.rad(-39.3),math.rad(1.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1,1.4,0.4)*CFrame.Angles(math.rad(-134.9),math.rad(19.4),math.rad(21.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,2.1,-0.1)*CFrame.Angles(math.rad(-7.1),math.rad(-3),math.rad(-8.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
swait()
end
local bloc = Instance.new("Part",Torso)
bloc.Anchored = true
bloc.CanCollide = false
bloc.Size = Vector3.new(1,1,1)
bloc.Transparency = 1
bloc.Name = "bloc"
bloc.CFrame = Root.CFrame * CFrame.new(0,0,-5)
--
SOUND(wmain,1306070008,5,false,math.random(7,9)/10,10)
tr1.Enabled = true
tr2.Enabled = true
for i = 1, 20 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(1.55,-2.8,-.35) * CFrame.Angles(math.rad(90),math.rad(40),math.rad(0)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(0), math.rad(50), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.3,-0.1,0.3)*CFrame.Angles(math.rad(-88.9),math.rad(4.5),math.rad(-1.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,2,0.2)*CFrame.Angles(math.rad(-2.9),math.rad(-15),math.rad(2.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.9,0.9,0.1)*CFrame.Angles(math.rad(-100),math.rad(-34.7),math.rad(-2.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.2,2.1,0.4)*CFrame.Angles(math.rad(11.9),math.rad(48.6),math.rad(-17.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
swait()
end
ws = 29
removeuseless:AddItem(g1,.001)
removeuseless:AddItem(bloc,6)
tr1.Enabled = false
tr2.Enabled = false
debounce = false
attacking = false
elseif combo3 then
if not equip then return end
if debounce then return end
combo1 = false
combo2 = false
combo3 = false
combo4 = true
debounce = true
attacking = true
ws = 10
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(0,90000,0)
for i = 1, 16 do
g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.15)
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-1.85,-1.7,-.35) * CFrame.Angles(math.rad(90),math.rad(-60),math.rad(0)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,0.5,-0.6)*CFrame.Angles(math.rad(0.9),math.rad(25.4),math.rad(25.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,2.1,0.3)*CFrame.Angles(math.rad(-2.2),math.rad(-47.3),math.rad(7.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.2,0.1,0.3)*CFrame.Angles(math.rad(-84.5),math.rad(-47.2),math.rad(6.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.5,2,0.3)*CFrame.Angles(math.rad(-2.8),math.rad(30),math.rad(-3.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
swait()
end
local bloc = Instance.new("Part",Torso)
bloc.Anchored = true
bloc.CanCollide = false
bloc.Size = Vector3.new(1,1,1)
bloc.Transparency = 1
bloc.Name = "bloc"
bloc.CFrame = Root.CFrame * CFrame.new(0,0,-6.5)
--
SOUND(wmain,1306070008,5,false,math.random(7,9)/10,10)
tr1.Enabled = true
tr2.Enabled = true
for i = 1, 17 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-1.25,-3.7,-.35) * CFrame.Angles(math.rad(90),math.rad(60),math.rad(0)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(0), math.rad(70), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0.7,1.7,0.8)*CFrame.Angles(math.rad(20.6),math.rad(-25.7),math.rad(74.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.1,2,0.5)*CFrame.Angles(math.rad(-0.7),math.rad(-67.3),math.rad(1.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,1.7,0.5)*CFrame.Angles(math.rad(-97.8),math.rad(61.9),math.rad(9.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.3,2,0.5)*CFrame.Angles(math.rad(-5.1),math.rad(60),math.rad(0.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.3)
swait()
end
ws = 29
removeuseless:AddItem(g1,.001)
tr1.Enabled = false
tr2.Enabled = false
removeuseless:AddItem(bloc,6)
debounce = false
attacking = false
elseif combo4 then
if not equip then return end
if debounce then return end
combo1 = true
combo2 = false
combo3 = false
combo4 = false
debounce = true
attacking = true
ws = 8
--local g1 = Instance.new("BodyGyro", nil)
--g1.CFrame = Root.CFrame
--g1.Parent = Root
--g1.D = 175
--g1.P = 20000
--g1.MaxTorque = Vector3.new(0,90000,0)
for i = 1, 20 do
--g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.15)
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-0,-3.5,-1.75) * CFrame.Angles(math.rad(-81),math.rad(0),math.rad(180)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(30), math.rad(0), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,0.8,0.3)*CFrame.Angles(math.rad(150.4),math.rad(13),math.rad(37.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,1.9,0.8)*CFrame.Angles(math.rad(20.7),math.rad(-16),math.rad(6.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0.7,0.5)*CFrame.Angles(math.rad(150.1),math.rad(-16.6),math.rad(-45.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.3,0.9,1)*CFrame.Angles(math.rad(43.9),math.rad(-6),math.rad(-15.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
ws = 0
tr1.Enabled = true
tr2.Enabled = true
SOUND(wmain,1306070008,5,false,math.random(7,9)/10,10)
local bloc = Instance.new("Part",Torso)
bloc.Size = Vector3.new(1,1,1)
bloc.Anchored = true
bloc.CanCollide = false
bloc.Transparency = 1
bloc.CFrame = Root.CFrame * CFrame.new(0,-2.2,-4.8)
--
SOUND(wmain,2691586,5,false,.3,10)
shockwave(CFrame.new(bloc.Position) * CFrame.new(0,-1,0),Vector3.new(.5,.1,.5),.2,BrickColor.new("White"),math.random(16,21),.025)
coroutine.wrap(function()
local bball = Instance.new("Part",Torso)
bball.Anchored = true
bball.CanCollide = false
bball.Size = Vector3.new(1,1,1)
bball.BrickColor = BrickColor.new("White")
bball.Material = "Neon"
bball.Transparency = .4
bball.Shape = "Ball"
bball.CFrame = bloc.CFrame
for i = 1, 40 do
bball.Size = bball.Size + Vector3.new(.5,.5,.5)
bball.Transparency = bball.Transparency + .025
swait()
end
bball:Destroy()
end)()
for i = 1, 20 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(.5,-3.5,0) * CFrame.Angles(math.rad(-0),math.rad(90),math.rad(0))*CFrame.Angles(math.rad(65),math.rad(0),math.rad(0)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(-31), math.rad(0), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,-0.1,-0.3)*CFrame.Angles(math.rad(-103.8),math.rad(36),math.rad(31.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,1.3,0.3)*CFrame.Angles(math.rad(-40.3),math.rad(-0.1),math.rad(0.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.4,0,-0.1)*CFrame.Angles(math.rad(-98.4),math.rad(-34.3),math.rad(-24))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,0.8,1.4)*CFrame.Angles(math.rad(57.4),math.rad(-12.1),math.rad(-7.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
removeuseless:AddItem(g1,.001)
removeuseless:AddItem(bloc,6)
tr1.Enabled = false
tr2.Enabled = false
attacking = false
debounce = false
ws = 29
end
end)

mouse.KeyDown:connect(function(Press)
Press=Press:lower()
if Press=='' then
immortality()
	for i,v in pairs(Player.Character:GetDescendants()) do
		if v:IsA("BodyVelocity") then
			v:Remove()
		end
	end
elseif Press=='u' then
if not equip then return end
if debounce then return end
debounce = true
attacking = true
tr1.Enabled = true
tr2.Enabled = true
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(0,90000,0)
for i = 1, 20 do
g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.15)
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-0,-3.5,-1.75) * CFrame.Angles(math.rad(-81),math.rad(0),math.rad(180)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 4, 0) * CFrame.Angles(math.rad(30), math.rad(0), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,0.8,0.3)*CFrame.Angles(math.rad(150.4),math.rad(13),math.rad(37.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,1.9,0.8)*CFrame.Angles(math.rad(20.7),math.rad(-16),math.rad(6.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0.7,0.5)*CFrame.Angles(math.rad(150.1),math.rad(-16.6),math.rad(-45.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.3,0.9,1)*CFrame.Angles(math.rad(43.9),math.rad(-6),math.rad(-15.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
ws = 0
coroutine.wrap(function()
local x = 0
for i = 1, 150 do
swait()
x = x + 25
local grl = Instance.new("Part",Torso)
grl.Size = Vector3.new(1,1,1)
grl.Anchored = true
grl.Transparency = 1
grl.CanCollide = false
grl.CFrame = Root.CFrame * CFrame.new(0,-2,-10 - x)
local didhit = false
local mate = nil
local colo = nil
local ray = Ray.new(grl.Position, grl.CFrame.Position + CFrame.new(0,-10,0).Position)
local tabd = {bloodfolder,Character}
local part, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {bloodfolder,grl,Character,blooddecal,blowd,Torso},false,true)
if part then
	didhit = true
mate = part.Material
colo = part.BrickColor
else
	didhit = false
end
if not didhit then
grl:Destroy()
elseif didhit then
--
coroutine.wrap(function()
local shockwave = Instance.new("Part", Torso)
shockwave.Size = Vector3.new(1,1,1)
shockwave.CanCollide = false
shockwave.Anchored = true
shockwave.Transparency = .4
shockwave.BrickColor = BrickColor.new("White")
shockwave.CFrame = CFrame.new(grl.Position) * CFrame.new(0,-1.75,0)
local shockwavemesh = Instance.new("SpecialMesh", shockwave)
shockwavemesh.Scale = Vector3.new(4,.7,4)
shockwavemesh.MeshId = "rbxassetid://20329976"
local shockwave2 = Instance.new("Part", Torso)
shockwave2.Size = Vector3.new(1,1,1)
shockwave2.CanCollide = false
shockwave2.Anchored = true
shockwave2.Transparency = .4
shockwave2.BrickColor = BrickColor.new("White")
shockwave2.CFrame = CFrame.new(grl.Position) * CFrame.new(0,-1.6,0)
local shockwavemesh2 = Instance.new("SpecialMesh", shockwave2)
shockwavemesh2.Scale = Vector3.new(4,.7,4)
shockwavemesh2.MeshId = "rbxassetid://20329976"
local shockwave3 = Instance.new("Part", Torso)
shockwave3.Size = Vector3.new(1,1,1)
shockwave3.CanCollide = false
shockwave3.Anchored = true
shockwave3.Transparency = .4
shockwave3.BrickColor = BrickColor.new("White")
shockwave3.CFrame = CFrame.new(grl.Position) * CFrame.new(0,-1.75,0)
local shockwavemesh3 = Instance.new("SpecialMesh", shockwave3)
shockwavemesh3.Scale = Vector3.new(4,.7,4)
shockwavemesh3.MeshId = "rbxassetid://20329976"
local sonbox = Instance.new("Part",Torso)
sonbox.Size = Vector3.new(1,1,1)
sonbox.Anchored = true
sonbox.CanCollide = flase
sonbox.Transparency = 1
sonbox.CFrame = grl.CFrame
SOUND(sonbox,292536356,5,false,math.random(8,11)/10,3)
for i = 1, 60 do
shockwave.CFrame = shockwave.CFrame * CFrame.Angles(math.rad(0),math.rad(0+math.random(16,21)),0)
shockwave2.CFrame = shockwave2.CFrame * CFrame.Angles(math.rad(0),math.rad(0-math.random(13,16)),0)
shockwave3.CFrame = shockwave3.CFrame * CFrame.Angles(math.rad(0),math.rad(0-math.random(6,9)),0)
shockwave.Transparency = shockwave.Transparency + .02
shockwave2.Transparency = shockwave2.Transparency + .02
shockwavemesh2.Scale = shockwavemesh2.Scale + Vector3.new(2,3,2)
shockwavemesh.Scale = shockwavemesh.Scale + Vector3.new(3,1.5,3)
shockwavemesh3.Scale = shockwavemesh3.Scale + Vector3.new(5,.25,5)
shockwave3.Transparency = shockwave3.Transparency + .02
swait()
end
shockwave3:Remove()
shockwave:Remove()
shockwave2:Remove()
end)()
local bigrass = Instance.new("Part",Torso)
bigrass.Size = Vector3.new(11,25 + math.random(1,20),11)
bigrass.Anchored = true
bigrass.BrickColor = colo
bigrass.Material = mate
bigrass.CanCollide = true
bigrass.CFrame = grl.CFrame * CFrame.new(0,-10,0)
coroutine.wrap(function()
local r1 = math.random(-3,3)
for i = 1, 20 do
bigrass.CFrame = bigrass.CFrame:lerp(bigrass.CFrame * CFrame.new(0,2,0) * CFrame.Angles(math.rad(r1),math.rad(r1),math.rad(r1)),.4)
swait()
end
end)()
coroutine.wrap(function()
wait(40)
local r2 = math.random(-3,3)
for i = 1, 100 do
bigrass.Transparency = bigrass.Transparency + .01
bigrass.CFrame = bigrass.CFrame:lerp(bigrass.CFrame * CFrame.new(0,-10,0) * CFrame.Angles(math.rad(r2),math.rad(r2),math.rad(r2)),.1)
swait()
end
bigrass:Destroy()
grl:Destroy()
end)()
end
end
end)()
for i = 1, 30 do
hum.CameraOffset = Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(.5,-3.5,0) * CFrame.Angles(math.rad(-0),math.rad(90),math.rad(0))*CFrame.Angles(math.rad(65),math.rad(0),math.rad(0)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(-31), math.rad(0), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,-0.1,-0.3)*CFrame.Angles(math.rad(-103.8),math.rad(36),math.rad(31.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,1.3,0.3)*CFrame.Angles(math.rad(-40.3),math.rad(-0.1),math.rad(0.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.4,0,-0.1)*CFrame.Angles(math.rad(-98.4),math.rad(-34.3),math.rad(-24))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,0.8,1.4)*CFrame.Angles(math.rad(57.4),math.rad(-12.1),math.rad(-7.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
removeuseless:AddItem(g1,.001)
tr1.Enabled = false
tr2.Enabled = false
hum.CameraOffset = Vector3.new(0,0,0)
ws = 29
attacking = false
debounce = false
elseif Press=='y' then
if mouse.Target ~= nil and mouse.Target.Parent ~= Character and mouse.Target.Parent.Parent ~= Character and mouse.Target.Parent:FindFirstChildOfClass("Humanoid") ~= nil then
local enemyhum = mouse.Target.Parent:FindFirstChildOfClass("Humanoid")
if enemyhum.Health < 1 then return end
local ETorso = enemyhum.Parent:FindFirstChild("Torso") or enemyhum.Parent:FindFirstChild("LowerTorso")
if (ETorso.Position - Torso.Position).magnitude < 10 then
if not equip then return end
if debounce then return end
debounce = true
attacking = true
SOUND(Torso,3475458279,5,false,1.2,10)
ws = 0
enemyhum.WalkSpeed = 0
local locatetor = Instance.new("Part",Torso)
locatetor.Size = Vector3.new(1,1,1)
locatetor.Anchored = true
locatetor.Transparency = 1
locatetor.CanCollide = false
locatetor.CFrame = Root.CFrame * CFrame.new(0,0,-5.5)
ETorso.CFrame = locatetor.CFrame * CFrame.Angles(0,math.rad(180),0)
for i = 1, 70 do
ETorso.CFrame = locatetor.CFrame * CFrame.Angles(0,math.rad(180),0)
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-.4,-2.7,1.5) * CFrame.Angles(math.rad(9),math.rad(0),math.rad(15)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.1, 0) * CFrame.Angles(math.rad(0), math.rad(-65), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0.6,0.4,0.9)*CFrame.Angles(math.rad(-56.1),math.rad(30.8),math.rad(-54.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,2.1,0.3)*CFrame.Angles(math.rad(5.2),math.rad(-51),math.rad(13.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.6,0.1,1)*CFrame.Angles(math.rad(-73.4),math.rad(-12.9),math.rad(47))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,2,0.3)*CFrame.Angles(math.rad(-5.2),math.rad(31),math.rad(-1.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
for i = 1, 6 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(.5,-3.7,.5) * CFrame.Angles(math.rad(90),math.rad(0),math.rad(0)) * CFrame.Angles(math.rad(-20),math.rad(15),0),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.25, 0) * CFrame.Angles(math.rad(0), math.rad(10), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0.8,0.5,0.3)*CFrame.Angles(math.rad(-72.7),math.rad(28.1),math.rad(-0.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,2,0.3)*CFrame.Angles(math.rad(0),math.rad(-26.4),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.3,0.9,0.4)*CFrame.Angles(math.rad(-89.8),math.rad(-7.6),math.rad(0.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.5,1.9,-0.3)*CFrame.Angles(math.rad(-48.7),math.rad(27.2),math.rad(4.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
local bbo = Instance.new("Part",Torso)
bbo.Size = Vector3.new(3,3,3)
bbo.Anchored = true
bbo.CanCollide = false
bbo.Material = "Neon"
bbo.BrickColor = BrickColor.new("White")
bbo.Shape = "Ball"
bbo.Transparency = .2
bbo.CFrame = locatetor.CFrame
local bbo2 = bbo:Clone() bbo2.Parent = Torso bbo2.Transparency = .85 bbo2mesh = Instance.new("SpecialMesh",bbo2) bbo2mesh.MeshId = "rbxassetid://9982590" bbo2mesh.Scale = Vector3.new(2,2,2)
local bbo3 = bbo:Clone() bbo3.Parent = Torso bbo3.Transparency = .85 bbo3mesh = Instance.new("SpecialMesh",bbo3) bbo3mesh.MeshId = "rbxassetid://9982590" bbo3mesh.Scale = Vector3.new(2,2,2)
coroutine.wrap(function()
for i = 1, 20 do
bbo2.CFrame = bbo2.CFrame * CFrame.Angles(math.rad(0+math.random(7,14)),math.rad(0+math.random(16,21)),math.rad(0+math.random(23,29)))
bbo2mesh.Scale = bbo2mesh.Scale + Vector3.new(2,2,2)
bbo2.Transparency = bbo2.Transparency + .007
bbo3.CFrame = bbo3.CFrame * CFrame.Angles(math.rad(0+math.random(7,14)),math.rad(0+math.random(16,21)),math.rad(0+math.random(23,29)))
bbo3mesh.Scale = bbo3mesh.Scale + Vector3.new(1,1,1)
bbo3.Transparency = bbo3.Transparency + .007
bbo.Size = bbo.Size + Vector3.new(1.5,1.5,1.5)
bbo.Transparency = bbo.Transparency + .05
swait()
end
bbo3:Remove()
bbo2:Remove()
bbo:Destroy()
end)()
--
enemyhum.WalkSpeed = 16
for i = 1, 15 do
hum.CameraOffset = Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-1.2,-1.9,1.5) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(-90)) * CFrame.Angles(math.rad(0),math.rad(-10),math.rad(10)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.25, 0) * CFrame.Angles(math.rad(0), math.rad(55), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.2,1.5,-0.5)*CFrame.Angles(math.rad(-95),math.rad(-38.9),math.rad(35.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,2.1,0.4)*CFrame.Angles(math.rad(9.5),math.rad(-45.4),math.rad(12.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,0.8,0.9)*CFrame.Angles(math.rad(-107.1),math.rad(-28.2),math.rad(30.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,2,0.5)*CFrame.Angles(math.rad(-6.1),math.rad(60.4),math.rad(0.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
hum.CameraOffset = Vector3.new(0,0,0)
ws = 29
attacking = false
debounce = false
end
end
elseif Press=='f' then
if mouse.Target ~= nil and mouse.Target.Parent ~= Character and mouse.Target.Parent.Parent ~= Character and mouse.Target.Parent:FindFirstChildOfClass("Humanoid") ~= nil then
local enemyhum = mouse.Target.Parent:FindFirstChildOfClass("Humanoid")
if enemyhum.Health < 1 then return end
local ETorso = enemyhum.Parent:FindFirstChild("Torso") or enemyhum.Parent:FindFirstChild("LowerTorso")
if (ETorso.Position - Torso.Position).magnitude < 4 then
if not equip then return end
if debounce then return end
debounce = true
attacking = true
ws = 0
enemyhum.WalkSpeed = 0
local locatetor = Instance.new("Part",Torso)
locatetor.Size = Vector3.new(1,1,1)
locatetor.Anchored = true
locatetor.Transparency = 1
locatetor.CanCollide = false
locatetor.CFrame = Root.CFrame * CFrame.new(0,0,-3)
ETorso.CFrame = locatetor.CFrame * CFrame.Angles(0,math.rad(180),0)
for i = 1, 20 do
ETorso.CFrame = locatetor.CFrame * CFrame.Angles(0,math.rad(180),0)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(0), math.rad(80), math.rad(20)),.35)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(-0.2,2,0.2)*CFrame.Angles(math.rad(4.8),math.rad(-19.6),math.rad(31.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,0.3,1.4)*CFrame.Angles(math.rad(72.2),math.rad(23.3),math.rad(1.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
SOUND(ETorso,545219984,10,false,1,10)
for i = 1, 20 do
ETorso.CFrame = ETorso.CFrame:lerp(CFrame.new(locatetor.Position) *CFrame.new(0,0,1)* CFrame.Angles(math.rad(90),math.rad(90),0),.2)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(0), math.rad(85), math.rad(60)),.35)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(-0.7,1.7,0.1)*CFrame.Angles(math.rad(8),math.rad(-16.6),math.rad(58.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0.3,2.2,0)*CFrame.Angles(math.rad(-6.9),math.rad(-24.1),math.rad(-39.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
swait()
end
local toweld = weldBetween(ETorso,locatetor)
toweld.C0 = CFrame.new(1,-.5,2.5) * CFrame.Angles(math.rad(90),math.rad(90),0)
for i = 1, 20 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(0,-1.1 + .1 * math.sin(sine/16),1.6) * CFrame.Angles(0,math.rad(0),math.rad(-60 + 1 * math.sin(sine/16))),.2)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,0.2,0.2)*CFrame.Angles(math.rad(-96.2 + 2 * math.sin(sine/16)),math.rad(19 + 1 * math.sin(sine/16)),math.rad(4.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.3,0.1,0.2)*CFrame.Angles(math.rad(-60.7+3*math.sin(sine/16)),math.rad(-25 + 2 * math.sin(sine/16)),math.rad(5.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2 + -.1 * math.sin(sine/16), 0) * CFrame.Angles(math.rad(0), math.rad(30), math.rad(0)),.2)
RIGHTLEGLERP.C1 = RIGHTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(0),0,0),.2)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-.4, 2 - .1 * math.sin(sine/16), .2) * CFrame.Angles(math.rad(-5), math.rad(30 + 0 * math.sin(sine/16)), math.rad(-5)), 0.2)
LEFTLEGLERP.C1 = LEFTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.1)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.55, 2.0 - .1 * math.sin(sine/16), .31) * CFrame.Angles(math.rad(5), math.rad(-20 + 0 * math.sin(sine/16)), math.rad(5)), 0.2)
swait()
end
for i = 1, 20 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(2,-1.7,.8) * CFrame.Angles(math.rad(0),math.rad(45),math.rad(60)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(35), math.rad(-72), math.rad(0)),.25)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.1,0.7,-0.6)*CFrame.Angles(math.rad(-94.8),math.rad(2.7),math.rad(45.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.4,1.2,1)*CFrame.Angles(math.rad(12.8),math.rad(-71),math.rad(-13.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.6,0.9,1.2)*CFrame.Angles(math.rad(-92.5),math.rad(-38.1),math.rad(51.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0.4,2.2,-0.2)*CFrame.Angles(math.rad(48.9),math.rad(69.7),math.rad(-88.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
tr1.Enabled = true
tr2.Enabled = true
coroutine.wrap(function()
pcall(function()
local bc = Instance.new("Part",Torso)
bc.CFrame = enemyhum.Parent.Head.CFrame
bc.Anchored = true
bc.CanCollide = false
bc.Size = Vector3.new(1,1,1)
bc.Transparency = 1
SOUND(bc,429400881,5,false,1,10)
--blood(bc,200)
enemyhum.Parent.Head:Destroy()
killtaunt()
for i = 1, 15 do
local meat = Instance.new("Part",Torso)
meat.BrickColor = BrickColor.new("Really red")
meat.Material = "Granite"
meat.Transparency = 0
meat.Anchored = false
meat.CanCollide = true
meat.Size = Vector3.new(.4,.4,.4)
meat.CFrame = bc.CFrame
coroutine.wrap(function()
for i = 1, 12 do
meat.CFrame = meat.CFrame:lerp(bc.CFrame * CFrame.new(math.random(-12,12),math.random(-12,12),math.random(-12,12)),.1)
swait()
end
wait(10)
for i = 1, 20 do
meat.Transparency = meat.Transparency + .05
swait()
end
meat:Destroy()
bc:Destroy()
end)()
end
end)
end)()
for i = 1, 20 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(.5,-3.5,0) * CFrame.Angles(math.rad(-0),math.rad(90),math.rad(0))*CFrame.Angles(math.rad(65),math.rad(0),math.rad(0)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -1.2, 0) * CFrame.Angles(math.rad(-31), math.rad(-30), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,-0.1,-0.3)*CFrame.Angles(math.rad(-103.8),math.rad(36),math.rad(31.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,1.3,0.3)*CFrame.Angles(math.rad(-40.3),math.rad(-0.1),math.rad(0.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.4,0,-0.1)*CFrame.Angles(math.rad(-98.4),math.rad(-34.3),math.rad(-24))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,0.8,1.4)*CFrame.Angles(math.rad(57.4),math.rad(-12.1),math.rad(-7.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
tr1.Enabled = false
tr2.Enabled = false
debounce = false
attacking = false
ws = 29
enemyhum.WalkSpeed = 16
end
end
elseif Press=='t' then
if not equip then return end
if debounce then return end
debounce = true
attacking = true
ws = 0
local god = {1707907547,1707907331,1707907822}
local supr14 = Instance.new("Part",Torso)
supr14.Anchored = false
supr14.CanCollide = false
supr14.Size = Vector3.new(1,1,1)
supr14.BrickColor = BrickColor.new("Gold")
supr14.Material = "Glass"
local supr14weld = weldBetween(supr14,rightlocation) supr14weld.C0 = supr14weld.C0 * CFrame.new(0,-1,0) * CFrame.Angles(math.rad(180),math.rad(-90),math.rad(-60))
local supr14m = Instance.new("SpecialMesh",supr14)
supr14m.Scale = Vector3.new(.06,.06,.06)
supr14m.MeshId = "rbxassetid://3517656385"
SOUND(supr14,1570569503,10,false,1.2,10)
local ran = god[math.random(1,#god)]
local m = Instance.new("Sound",supr14)
m.SoundId = "rbxassetid://"..ran
m.Volume = 8
m:Play()
for i = 1, 100 do
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(0.3,1.7,-0.9)*CFrame.Angles(math.rad(-34.4),math.rad(27.7),math.rad(-123.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(0,-1.1 + .1 * math.sin(sine/16),1.6) * CFrame.Angles(0,math.rad(0),math.rad(-60 + 1 * math.sin(sine/16))),.2)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,0.2,0.2)*CFrame.Angles(math.rad(-96.2 + 2 * math.sin(sine/16)),math.rad(19 + 1 * math.sin(sine/16)),math.rad(4.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2 + -.1 * math.sin(sine/16), 0) * CFrame.Angles(math.rad(0), math.rad(60), math.rad(0)),.2)
RIGHTLEGLERP.C1 = RIGHTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(0),0,0),.2)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-.4, 2 - .1 * math.sin(sine/16), .2) * CFrame.Angles(math.rad(-5), math.rad(30 + 0 * math.sin(sine/16)), math.rad(-5)), 0.2)
LEFTLEGLERP.C1 = LEFTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.1)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.55, 2.0 - .1 * math.sin(sine/16), .31) * CFrame.Angles(math.rad(5), math.rad(-20 + 0 * math.sin(sine/16)), math.rad(5)), 0.2)
swait()
end
supr14:Destroy()
debounce = false
attacking = false
ws = 29
elseif Press=='r' then
if debounce then return end
if not equip then return end
debounce = true
attacking = true
tr1.Enabled = true
tr2.Enabled = true
SOUND(Torso,2101137,5,false,math.random(7,8)/10,10)
for i = 1, 80 do
ws = ws - .3625
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(1.5,-2.3,-.15) * CFrame.Angles(math.rad(-20),math.rad(90),math.rad(90))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.06)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(45), math.rad(-45), math.rad(0))*CFrame.Angles(0,math.rad(0),0), 0.06)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0.2,0,-1)*CFrame.Angles(math.rad(-136.6),math.rad(-4.7),math.rad(84.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.06)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.4,0.9,1.5)*CFrame.Angles(math.rad(30.2),math.rad(-47.9),math.rad(-2.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.06)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0.4,0.4)*CFrame.Angles(math.rad(-105.6),math.rad(-6.7),math.rad(4.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.06)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.3,1.7,1.1)*CFrame.Angles(math.rad(59.4),math.rad(-53.4),math.rad(-6.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.06)
swait()
end
--local bloc = Instance.new("Part",Torso)
--bloc.Size = Vector3.new(0,0,0)
--bloc.Anchored = true
--bloc.CanCollide = false
--bloc.Transparency = 1
--bloc.CFrame = Root.CFrame * CFrame.new(0,-0,-0)
local didhit = false
local mate = nil
local colo = nil
--local ray = Ray.new(bloc.Position, bloc.CFrame.Position + CFrame.new(0,-0,0).Position)
local tabd = {bloodfolder,Character}
--local part, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {bloodfolder,bloc,Character,blooddecal,blowd,Torso},false,true)
if part then
	didhit = true
--mate = part.Material
---colo = part.BrickColor
else
	didhit = false
end
if didhit then
coroutine.wrap(function()
--local shockwave = Instance.new("Part", Torso)
--shockwave.Size = Vector3.new(1,1,1)
--shockwave.CanCollide = false
--shockwave.Anchored = true
--shockwave.Transparency = .4
--shockwave.BrickColor = BrickColor.new("White")
--shockwave.CFrame = CFrame.new(bloc.Position) * CFrame.new(0,-1.75,0)
--local shockwavemesh = Instance.new("SpecialMesh", shockwave)
--shockwavemesh.Scale = Vector3.new(4,.7,4)
shockwavemesh.MeshId = "rbxassetid://20329976"
local shockwave2 = Instance.new("Part", Torso)
shockwave2.Size = Vector3.new(1,1,1)
shockwave2.CanCollide = false
shockwave2.Anchored = true
shockwave2.Transparency = .4
shockwave2.BrickColor = BrickColor.new("White")
shockwave2.CFrame = CFrame.new(bloc.Position) * CFrame.new(0,-1.6,0)
local shockwavemesh2 = Instance.new("SpecialMesh", shockwave2)
shockwavemesh2.Scale = Vector3.new(0,.0,0)
shockwavemesh2.MeshId = "rbxassetid://20329976"
local shockwave3 = Instance.new("Part", Torso)
shockwave3.Size = Vector3.new(0,0,0)
shockwave3.CanCollide = false
shockwave3.Anchored = true
shockwave3.Transparency = .4
shockwave3.BrickColor = BrickColor.new("White")
shockwave3.CFrame = CFrame.new(bloc.Position) * CFrame.new(0,-1.75,0)
local shockwavemesh3 = Instance.new("SpecialMesh", shockwave3)
shockwavemesh3.Scale = Vector3.new(4,.7,4)
shockwavemesh3.MeshId = "rbxassetid://20329976"
local sonbox = Instance.new("Part",Torso)
sonbox.Size = Vector3.new(0,0,0)
sonbox.Anchored = true
sonbox.CanCollide = flase
sonbox.Transparency = 1
sonbox.CFrame = bloc.CFrame
SOUND(sonbox,1776706665,5,false,math.random(9,12)/10,12)
for i = 1, 80 do
shockwave.CFrame = shockwave.CFrame * CFrame.Angles(math.rad(0),math.rad(0+math.random(16,21)),0)
shockwave2.CFrame = shockwave2.CFrame * CFrame.Angles(math.rad(0),math.rad(0-math.random(13,16)),0)
shockwave3.CFrame = shockwave3.CFrame * CFrame.Angles(math.rad(0),math.rad(0-math.random(6,9)),0)
shockwave.Transparency = shockwave.Transparency + .009
shockwave2.Transparency = shockwave2.Transparency + .009
shockwavemesh2.Scale = shockwavemesh2.Scale + Vector3.new(2,2,2)
shockwavemesh.Scale = shockwavemesh.Scale + Vector3.new(4,1.5,4)
shockwavemesh3.Scale = shockwavemesh3.Scale + Vector3.new(3,.5,3)
shockwave3.Transparency = shockwave3.Transparency + .009
swait()
end
shockwave3:Remove()
shockwave:Remove()
shockwave2:Remove()
end)()
coroutine.wrap(function()
for i = 1, 30 do
local mv = Instance.new("Part",Torso)
mv.Size = Vector3.new(1,1,1)
mv.Anchored = true
mv.CanCollide = false
mv.Transparency = 1
mv.CFrame = bloc.CFrame * CFrame.new(math.random(-30,30),35,math.random(-30,30))
local dragh = math.random(4,6)
local mv2 = Instance.new("Part",Torso)
mv2.Size = Vector3.new(dragh,dragh,dragh)
mv2.BrickColor = colo
mv2.Material = mate
mv2.CanCollide = true
mv2.Anchored = false
mv2.CFrame = bloc.CFrame * CFrame.new(0,12.5,0)
MAKETRAIL(mv2,Vector3.new(.2,.2,0),Vector3.new(-.2,-.2,0),1.5,ColorSequence.new(BrickColor.new("White").Color,BrickColor.new("Really black").Color))
coroutine.wrap(function()
velo(mv2,"l",mv.Position,325)
wait(.25)
mv2.l:Remove()
mv:Remove()
wait(10)
for i = 1, 40 do
mv2.Transparency = mv2.Transparency + .025
swait()
end
mv2:Remove()
end)()
end
end)()
---checking for error---
coroutine.wrap(function()
local b = Instance.new("Part",Torso)
b.Size = Vector3.new(1,1,1)
b.Anchored = true
b.CanCollide = false
b.CFrame = bloc.CFrame
b.Transparency = 1
local t = 0
for i = 1, 36 do
t = t + 10
local b2 = b:Clone() b2.Parent = Torso b2.Transparency = 1
b2.CFrame = b.CFrame * CFrame.Angles(0,math.rad(t),math.rad(0)) * CFrame.new(10,0,0) 
local grassblock = Instance.new("Part",Torso)
grassblock.Size = Vector3.new(3.5,3.5,3.5)
grassblock.BrickColor = colo
grassblock.Material = mate
grassblock.Anchored = true
grassblock.CanCollide = true
grassblock.CFrame = b2.CFrame * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
coroutine.wrap(function()
wait(15)
for i = 1, 20 do
grassblock.Transparency = grassblock.Transparency + .05
swait()
end
grassblock:Destroy()
end)()
end
wait(.1)
t = 0
for i = 1, 36 do
t = t + 10
local b2 = b:Clone() b2.Parent = Torso b2.Transparency = 1
b2.CFrame = b.CFrame * CFrame.Angles(0,math.rad(t),math.rad(0)) * CFrame.new(14,0,0) 
local grassblock = Instance.new("Part",Torso)
grassblock.Size = Vector3.new(7,7,7)
grassblock.BrickColor = colo
grassblock.Material = mate
grassblock.Anchored = true
grassblock.CanCollide = true
grassblock.CFrame = b2.CFrame * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
coroutine.wrap(function()
wait(15)
for i = 1, 20 do
grassblock.Transparency = grassblock.Transparency + .05
swait()
end
grassblock:Destroy()
end)()
end
bloc:Remove()
end)()
local bbo = Instance.new("Part",Torso)
bbo.Size = Vector3.new(3,3,3)
bbo.Anchored = true
bbo.CanCollide = false
bbo.Material = "Neon"
bbo.BrickColor = BrickColor.new("White")
bbo.Shape = "Ball"
bbo.Transparency = .2
bbo.CFrame = bloc.CFrame
local bbo2 = bbo:Clone() bbo2.Parent = Torso bbo2.Transparency = .85 bbo2mesh = Instance.new("SpecialMesh",bbo2) bbo2mesh.MeshId = "rbxassetid://9982590" bbo2mesh.Scale = Vector3.new(2,2,2)
local bbo3 = bbo:Clone() bbo3.Parent = Torso bbo3.Transparency = .85 bbo3mesh = Instance.new("SpecialMesh",bbo3) bbo3mesh.MeshId = "rbxassetid://9982590" bbo3mesh.Scale = Vector3.new(2,2,2)
coroutine.wrap(function()
for i = 1, 20 do
bbo2.CFrame = bbo2.CFrame * CFrame.Angles(math.rad(0+math.random(7,14)),math.rad(0+math.random(16,21)),math.rad(0+math.random(23,29)))
bbo2mesh.Scale = bbo2mesh.Scale + Vector3.new(4,4,4)
bbo2.Transparency = bbo2.Transparency + .007
bbo3.CFrame = bbo3.CFrame * CFrame.Angles(math.rad(0+math.random(7,14)),math.rad(0+math.random(16,21)),math.rad(0+math.random(23,29)))
bbo3mesh.Scale = bbo3mesh.Scale + Vector3.new(2,2,2)
bbo3.Transparency = bbo3.Transparency + .007
bbo.Size = bbo.Size + Vector3.new(3,3,3)
bbo.Transparency = bbo.Transparency + .05
swait()
end
bbo3:Remove()
bbo2:Remove()
bbo:Destroy()
end)()

end
for i = 1, 30 do
hum.CameraOffset = Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(.5,-3.5,0) * CFrame.Angles(math.rad(-0),math.rad(90),math.rad(0))*CFrame.Angles(math.rad(65),math.rad(0),math.rad(0)),.3)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(-31), math.rad(0), math.rad(0)), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,-0.1,-0.3)*CFrame.Angles(math.rad(-103.8),math.rad(36),math.rad(31.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,1.3,0.3)*CFrame.Angles(math.rad(-40.3),math.rad(-0.1),math.rad(0.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.4,0,-0.1)*CFrame.Angles(math.rad(-98.4),math.rad(-34.3),math.rad(-24))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,0.8,1.4)*CFrame.Angles(math.rad(57.4),math.rad(-12.1),math.rad(-7.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
tr1.Enabled = false
tr2.Enabled = false
hum.CameraOffset = Vector3.new(0,0,0)
ws = 29
attacking = false
debounce = false
elseif Press=='e' then
if not equip then return end
if debounce then return end
debounce = true
attacking = true
tr1.Enabled = true
tr2.Enabled = true
ws = 6
local z = 0
local z2 = 0
for i = 1, 325 do
z2 = z2 + .1
ws = ws + z2/50
z = z + z2
--Hit = damagealll(5,wmain.Position)
--for _,v in pairs(Hit) do
--if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
--slachtoffer = v:FindFirstChildOfClass("Humanoid")
--if not didhit then
--takeDamage(slachtoffer,math.random(11,20))
--SOUND(torso,2801263,5,false,math.random(7,8)/10,6)
--end
--vel = Instance.new("BodyVelocity",v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("HumanoidRootPart")) 
--vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
--torso = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("HumanoidRootPart")
--vel.velocity = CFrame.new(wmain.Position,torso.Position).lookVector*40
--removeuseless:AddItem(vel,.1)
--blood(torso,200)
--end
--end
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(0,-3.5,-.5) * CFrame.Angles(math.rad(-0),math.rad(0),math.rad(0))*CFrame.Angles(math.rad(110),math.rad(0),math.rad(0)),.3)
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(-20),math.rad(0),0),.2)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(0), math.rad(z), math.rad(0))*CFrame.Angles(0,math.rad(0),0), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.3,0.1,0.3)*CFrame.Angles(math.rad(-66.5),math.rad(37.7),math.rad(1.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,1.3,0.9)*CFrame.Angles(math.rad(33.1),math.rad(-0.1),math.rad(7.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.3,0.1,0.2)*CFrame.Angles(math.rad(-74.5),math.rad(-37.1),math.rad(-6.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,2.1,0)*CFrame.Angles(math.rad(0.6),math.rad(5),math.rad(-7.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
for i = 1, 350 do
z = z + z2
--Hit = damagealll(8,wmain.Position)
--for _,v in pairs(Hit) do
--if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
--slachtoffer = v:FindFirstChildOfClass("Humanoid")
--if not didhit then
--takeDamage(slachtoffer,math.random(20,29))
--SOUND(torso,2801263,5,false,math.random(7,8)/10,6)
--end
--vel = Instance.new("BodyVelocity",v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")) 
--vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
--torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
--vel.velocity = CFrame.new(wmain.Position,torso.Position).lookVector*125
--removeuseless:AddItem(vel,.1)
--blood(torso,200)
--end
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(0,-3.5,-.5) * CFrame.Angles(math.rad(-0),math.rad(0),math.rad(0))*CFrame.Angles(math.rad(110),math.rad(0),math.rad(0)),.3)
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(-20),math.rad(0),0),.2)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2, 0) * CFrame.Angles(math.rad(0), math.rad(z), math.rad(0))*CFrame.Angles(0,math.rad(0),0), 0.3)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.3,0.1,0.3)*CFrame.Angles(math.rad(-66.5),math.rad(37.7),math.rad(1.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,1.3,0.9)*CFrame.Angles(math.rad(33.1),math.rad(-0.1),math.rad(7.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.3,0.1,0.2)*CFrame.Angles(math.rad(-74.5),math.rad(-37.1),math.rad(-6.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,2.1,0)*CFrame.Angles(math.rad(0.6),math.rad(5),math.rad(-7.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
swait()
end
tr1.Enabled = false
tr2.Enabled = false
ROOTLERP.C1 = CFrame.new(0,0,0) * CFrame.Angles(math.rad(0),math.rad(0),0)
debounce = false
attacking = false
elseif Press=='q' then
if debounce then return end
debounce = true
if equip then
equipping = true
SOUND(wmain,12222225,4,false,.5,10)
for i = 1, 20 do
doomtheme.Volume = doomtheme.Volume - .15
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-2.45,-.8,-.45) * CFrame.Angles(0,0,math.rad(-50)),.12)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,0.5,0.4)*CFrame.Angles(math.rad(8.4),math.rad(-24.5),math.rad(19.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.1,1.4,0)*CFrame.Angles(math.rad(170.6),math.rad(-0.9),math.rad(31.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
swait()
end
doomtheme.Volume = 0
for i = 1, 20 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-.615,-.8,-1.25) * CFrame.Angles(0,0,math.rad(-130)),.12)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.4,0.3,0.3)*CFrame.Angles(math.rad(156.4),math.rad(3.2),math.rad(-16.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.3,1,0.4)*CFrame.Angles(math.rad(0.3),math.rad(-21),math.rad(35.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
swait()
end
whandelweld.C0 = CFrame.new(0,-.6,-.75) * CFrame.Angles(math.rad(-10),math.rad(0),math.rad(-135))
equipping = false
equip = false
debounce = false
else
equipping = true
SOUND(wmain,12222225,4,false,.6,10)
taunt()
for i = 1, 20 do
doomtheme.Volume = doomtheme.Volume + .15
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,0.7,0.4)*CFrame.Angles(math.rad(-14.6),math.rad(-23.3),math.rad(21.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(-2.25,-.8,-.8) * CFrame.Angles(0,0,math.rad(-50)),.12)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.4,0.9,-0.4)*CFrame.Angles(math.rad(156.1),math.rad(16.5),math.rad(21))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
swait()
end
doomtheme.Volume = 3
for i = 1, 20 do
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(0,-1.1 + .1 * math.sin(sine/12),1.6) * CFrame.Angles(0,math.rad(0),math.rad(-60)),.12)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,0.2,0.2)*CFrame.Angles(math.rad(-96.2 + 2 * math.sin(sine/12)),math.rad(19 + 1 * math.sin(sine/12)),math.rad(4.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.3,0.1,0.2)*CFrame.Angles(math.rad(-60.7+3*math.sin(sine/12)),math.rad(-25 + 2 * math.sin(sine/12)),math.rad(5.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
swait()
end
equipping = false
equip = true
debounce = false
attacking = false
end
end
end)

checks1 = coroutine.wrap(function() -------Checks
while true do
hf = ray(Root.Position,(CFrame.new(Root.Position,Root.Position+Vector3.new(0,-1,0))).lookVector,4 * 1,Character)
if Root.Velocity.y > 5 and hf == nil then
position = "Jump"
elseif Root.Velocity.y < -5 and hf == nil then
position = "Falling"
elseif Root.Velocity.Magnitude < 5 and hf ~= nil then
position = "Idle"
elseif Root.Velocity.Magnitude > 5 and hf ~= nil then
position = "Walking"
else
end
wait()
end
end)
checks1()

OrgnC0 = Neck.C0
local movelimbs = coroutine.wrap(function()
while wait() do
TrsoLV = Torso.CFrame.lookVector
Dist = nil
Diff = nil
if not MseGuide then
print("Failed to recognize")
else
local _, Point = Workspace:FindPartOnRay(Ray.new(Head.CFrame.p, mouse.Hit.lookVector), Workspace, false, true)
Dist = (Head.CFrame.p-Point).magnitude
Diff = Head.CFrame.Y-Point.Y
local _, Point2 = Workspace:FindPartOnRay(Ray.new(LeftArm.CFrame.p, mouse.Hit.lookVector), Workspace, false, true)
Dist2 = (LeftArm.CFrame.p-Point).magnitude
Diff2 = LeftArm.CFrame.Y-Point.Y
HEADLERP.C0 = CFrame.new(0, -1.5, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
Neck.C0 = Neck.C0:lerp(OrgnC0*CFrame.Angles((math.tan(Diff/Dist)*1), 0, (((Head.CFrame.p-Point).Unit):Cross(Torso.CFrame.lookVector)).Y*1), .25)
end
end
end)
movelimbs()
immortal = {}
for i,v in pairs(Character:GetDescendants()) do
	if v:IsA("BasePart") and v.Name ~= "lmagic" and v.Name ~= "rmagic" then
		if v ~= Root and v ~= Torso and v ~= Head and v ~= RightArm and v ~= LeftArm and v ~= RightLeg and v.Name ~= "lmagic" and v.Name ~= "rmagic" and v ~= LeftLeg then
			v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
		end
		table.insert(immortal,{v,v.Parent,v.Material,v.Color,v.Transparency})
	elseif v:IsA("JointInstance") then
		table.insert(immortal,{v,v.Parent,nil,nil,nil})
	end
end
for e = 1, #immortal do
if immortal[e] ~= nil then
local STUFF = immortal[e]
local PART = STUFF[1]
local PARENT = STUFF[2]
local MATERIAL = STUFF[3]
local COLOR = STUFF[4]
local TRANSPARENCY = STUFF[5]
if levitate then
if PART.ClassName == "Part" and PART ~= Root and PART.Name ~= eyo1 and PART.Name ~= eyo2 and PART.Name ~= "lmagic" and PART.Name ~= "rmagic" then
PART.Material = MATERIAL
PART.Color = COLOR
PART.Transparency = TRANSPARENCY
end
PART.AncestryChanged:connect(function()
PART.Parent = PARENT
end)
else
if PART.ClassName == "Part" and PART ~= Root and PART.Name ~= "lmagic" and PART.Name ~= "rmagic" then
PART.Material = MATERIAL
PART.Color = COLOR
PART.Transparency = TRANSPARENCY
end
PART.AncestryChanged:connect(function()
PART.Parent = PARENT
end)
end
end
end
function immortality()
for e = 1, #immortal do
if immortal[e] ~= nil then
local STUFF = immortal[e]
local PART = STUFF[1]
local PARENT = STUFF[2]
local MATERIAL = STUFF[3]
local COLOR = STUFF[4]
local TRANSPARENCY = STUFF[5]
if PART.ClassName == "Part" and PART == Root then
PART.Material = MATERIAL
PART.Color = COLOR
PART.Transparency = TRANSPARENCY
end
if PART.Parent ~= PARENT then
hum:Remove()
PART.Parent = PARENT
hum = Instance.new("Humanoid",Character)
hum.Name = "noneofurbusiness"
end
end
end
end
coroutine.wrap(function()
while true do
hum:SetStateEnabled("Dead",false) hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
if hum.Health < .1 then
--immortality()
end
swait()
end
end)()
----------

--------------

local anims = coroutine.wrap(function()
while true do
settime = 0.05
sine = sine + change
if position == "Jump" and not attacking then
change = 1
if equip then
if not equipping then
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(0,-1.1 + .1 * math.sin(sine/8),1.6) * CFrame.Angles(0,math.rad(0),math.rad(-60 + 1 * math.sin(sine/8))),.2)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,0.2,0.2)*CFrame.Angles(math.rad(-96.2 + 2 * math.sin(sine/8)),math.rad(19 + 1 * math.sin(sine/8)),math.rad(4.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.3,0.1,0.2)*CFrame.Angles(math.rad(-60.7+3*math.sin(sine/8)),math.rad(-25 + 2 * math.sin(sine/8)),math.rad(5.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
end
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-20), math.rad(0), math.rad(0)), 0.09)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.5, 2, 0) * CFrame.Angles(math.rad(10), math.rad(0), math.rad(0)), 0.2)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5, 1.0, .9) * CFrame.Angles(math.rad(20), math.rad(0), math.rad(0)), 0.2)
else
if not equipping then
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5, .15, 0) * CFrame.Angles(math.rad(10), math.rad(2), math.rad(10)), 0.2)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0.5,0.1)*CFrame.Angles(math.rad(167.5),math.rad(1.7),math.rad(-4.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
end
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.2)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-20), math.rad(0), math.rad(0)), 0.09)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.5, 2, 0) * CFrame.Angles(math.rad(10), math.rad(0), math.rad(0)), 0.2)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5, 1.0, .9) * CFrame.Angles(math.rad(20), math.rad(0), math.rad(0)), 0.2)
end
elseif position == "Falling" and not attacking then
change = 1
if equip then
if not equipping then
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(0,-1.1 + .1 * math.sin(sine/8),1.6) * CFrame.Angles(0,math.rad(0),math.rad(-60 + 1 * math.sin(sine/8))),.2)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,0.2,0.2)*CFrame.Angles(math.rad(-96.2 + 2 * math.sin(sine/8)),math.rad(19 + 1 * math.sin(sine/8)),math.rad(4.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.3,0.1,0.2)*CFrame.Angles(math.rad(-60.7+3*math.sin(sine/8)),math.rad(-25 + 2 * math.sin(sine/8)),math.rad(5.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
end
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(20), math.rad(0), math.rad(0)), 0.09)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.54, 1.4 + .1 * math.sin(sine/12), .4) * CFrame.Angles(math.rad(9 + 2 * math.cos(sine/12)), math.rad(0), math.rad(0)), 0.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.54, 2 + .02 * math.sin(sine/12), 0.2 + .1 * math.sin(sine/12)) * CFrame.Angles(math.rad(25 + 5 * math.sin(sine/12)), math.rad(20), math.rad(0)), 0.25)
else
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.2)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(20), math.rad(0), math.rad(0)), 0.09)
if not equipping then
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,.94 + .02 * math.sin(sine/12),-0) * CFrame.Angles(math.rad(28 + 5 * math.sin(sine/12)),math.rad(0),math.rad(45)), 0.2)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0.5,0.1)*CFrame.Angles(math.rad(167.5),math.rad(1.7),math.rad(-4.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
end
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.54, 1.4 + .1 * math.sin(sine/12), .4) * CFrame.Angles(math.rad(9 + 2 * math.cos(sine/12)), math.rad(0), math.rad(0)), 0.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.54, 2 + .02 * math.sin(sine/12), 0.2 + .1 * math.sin(sine/12)) * CFrame.Angles(math.rad(25 + 5 * math.sin(sine/12)), math.rad(20), math.rad(0)), 0.25)
end
elseif position == "Walking" and not attacking then
change = 1
walking = true
ws = 29
local plant2 = hum.MoveDirection*Torso.CFrame.LookVector
local plant3 = hum.MoveDirection*Torso.CFrame.RightVector
local plant = plant2.Z + plant2.X
local plant4 = plant3.Z + plant3.X
if equip then
if not equipping then
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(0,-1.1 + .1 * math.sin(sine/8),1.6) * CFrame.Angles(0,math.rad(0),math.rad(-60 + 1 * math.sin(sine/8))),.2)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,0.2,0.2)*CFrame.Angles(math.rad(-96.2 + 2 * math.sin(sine/8)),math.rad(19 + 1 * math.sin(sine/8)),math.rad(4.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.3,0.1,0.2)*CFrame.Angles(math.rad(-60.7+3*math.sin(sine/8)),math.rad(-25 + 2 * math.sin(sine/8)),math.rad(5.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
end
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.3 + 0.31*math.sin(sine/3), 0) * CFrame.Angles(math.rad(plant-plant/5)*-20, math.rad(-plant4 - -plant4/5*math.sin(sine/6))*35, math.rad(-plant4 - plant4*15) + Root.RotVelocity.Y / 30) * CFrame.Angles(0,math.rad(12 * -math.cos(sine/6)), 0),.1)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.52, 1.62 - .54 * math.cos(sine/6)/2.8,.2 - .5 * math.sin(sine/6)) * CFrame.Angles(math.rad(-20 * -plant - plant*math.sin(sine/6)*60), math.rad(-plant4 - -plant4/5*math.sin(sine/6)*40),math.rad(-plant4 - plant4*math.sin(sine/6)*20)), 0.3)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.52, 1.62 + .54 * math.cos(sine/6)/2.8,.2 + .5 * math.sin(sine/6)) * CFrame.Angles(math.rad(-20 * -plant - plant*math.sin(sine/6)*-60), math.rad(-plant4 - -plant4/5*math.sin(sine/6)*40), math.rad(-plant4 - -plant4*math.sin(sine/6)*20)), 0.3)
else
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.2)
if not equipping then
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0.5,0.1)*CFrame.Angles(math.rad(167.5),math.rad(1.7),math.rad(-4.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.3 - .3 * math.sin(sine/6),.45 -.45 * math.sin(sine/6),-.3 + .26*math.sin(sine/6)) * CFrame.Angles(math.rad(75*-math.sin(sine/6)),math.rad(30 + 40*math.sin(sine/6)),math.rad(10, math.sin(-20 * math.sin(sine/4)))),.3)
end
LEFTLEGLERP.C1 = LEFTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.1)
RIGHTLEGLERP.C1 = RIGHTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(0),0,0),.1)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.3 + 0.31*math.sin(sine/3), 0) * CFrame.Angles(math.rad(plant-plant/5)*-20, math.rad(-plant4 - -plant4/5*math.sin(sine/6))*35, math.rad(-plant4 - plant4*15) + Root.RotVelocity.Y / 30) * CFrame.Angles(0,math.rad(12 * -math.cos(sine/6)), 0),.1)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.52, 1.62 - .54 * math.cos(sine/6)/2.8,.2 - .5 * math.sin(sine/6)) * CFrame.Angles(math.rad(-20 * -plant - plant*math.sin(sine/6)*60), math.rad(-plant4 - -plant4/5*math.sin(sine/6)*40),math.rad(-plant4 - plant4*math.sin(sine/6)*20)), 0.3)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.52, 1.62 + .54 * math.cos(sine/6)/2.8,.2 + .5 * math.sin(sine/6)) * CFrame.Angles(math.rad(-20 * -plant - plant*math.sin(sine/6)*-60), math.rad(-plant4 - -plant4/5*math.sin(sine/6)*40), math.rad(-plant4 - -plant4*math.sin(sine/6)*20)), 0.3)
end
elseif position == "Idle" and not attacking then
change = 1
if equip then
if not equipping then
whandelweld.C0 = whandelweld.C0:lerp(CFrame.new(0,-1.1 + .1 * math.sin(sine/16),1.6) * CFrame.Angles(0,math.rad(0),math.rad(-60 + 1 * math.sin(sine/16))),.2)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,0.2,0.2)*CFrame.Angles(math.rad(-96.2 + 2 * math.sin(sine/16)),math.rad(19 + 1 * math.sin(sine/16)),math.rad(4.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.3,0.1,0.2)*CFrame.Angles(math.rad(-60.7+3*math.sin(sine/16)),math.rad(-25 + 2 * math.sin(sine/16)),math.rad(5.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
end
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2 + -.1 * math.sin(sine/16), 0) * CFrame.Angles(math.rad(0), math.rad(30), math.rad(0)),.2)
RIGHTLEGLERP.C1 = RIGHTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(0),0,0),.2)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-.4, 2 - .1 * math.sin(sine/16), .2) * CFrame.Angles(math.rad(-5), math.rad(30 + 0 * math.sin(sine/16)), math.rad(-5)), 0.2)
LEFTLEGLERP.C1 = LEFTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.1)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.55, 2.0 - .1 * math.sin(sine/16), .31) * CFrame.Angles(math.rad(5), math.rad(-20 + 0 * math.sin(sine/16)), math.rad(5)), 0.2)
else
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.2)
if not equipping then
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.55,.3+.08*math.sin(sine/16),.02 * -math.sin(sine/16)) * CFrame.Angles(math.rad(5 * math.sin(sine/16)),math.rad(0),math.rad(15 + 3 * math.sin(sine/16))), 0.2)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0.5,0.1)*CFrame.Angles(math.rad(167.5),math.rad(1.7),math.rad(-4.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
end
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2 + -.1 * math.sin(sine/16), 0) * CFrame.Angles(math.rad(0), math.rad(30), math.rad(0)),.2)
RIGHTLEGLERP.C1 = RIGHTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(0),0,0),.2)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-.4, 2 - .1 * math.sin(sine/16), .2) * CFrame.Angles(math.rad(-5), math.rad(30 + 0 * math.sin(sine/16)), math.rad(-5)), 0.2)
LEFTLEGLERP.C1 = LEFTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.1)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.55, 2.0 - .1 * math.sin(sine/16), .31) * CFrame.Angles(math.rad(5), math.rad(-20 + 0 * math.sin(sine/16)), math.rad(5)), 0.2)
end
end
swait()
end
end)
anims()
warn("Brutal legend. Made by Supr14")
