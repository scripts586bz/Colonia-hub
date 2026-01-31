-- COLONIA HUB | MENÚ COMPLETO SIN KEY
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- POSICIONES
local TP1, TP2, TP3 = nil, nil, nil

-- NOCLIP
local noclip = false
RunService.Stepped:Connect(function()
	if noclip and char then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.ResetOnSpawn = false

-- BOTÓN ABRIR / CERRAR
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0,150,0,40)
Toggle.Position = UDim2.new(0,20,0.5,-20)
Toggle.Text = "Colonia hub"
Toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.BorderSizePixel = 0
Toggle.Active = true
Toggle.Draggable = true

-- FRAME PRINCIPAL
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,500,0,300)
Frame.Position = UDim2.new(0.5, -250, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BackgroundTransparency = 0.4 -- medio transparente
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true

-- BORDES REDONDEADOS
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,20)
UICorner.Parent = Frame

-- SCROLL FRAME PARA BOTONES
local ScrollFrame = Instance.new("ScrollingFrame", Frame)
ScrollFrame.Size = UDim2.new(1,-20,1,-40)
ScrollFrame.Position = UDim2.new(0,10,0,30)
ScrollFrame.CanvasSize = UDim2.new(0,0,0,600) -- espacio para scroll
ScrollFrame.ScrollBarThickness = 10
ScrollFrame.BackgroundTransparency = 1

-- FUNCIÓN BOTÓN
local function boton(text,y)
	local b = Instance.new("TextButton", ScrollFrame)
	b.Size = UDim2.new(1,0,0,35)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(80,80,80)
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	return b
end

-- BOTONES
local G1 = boton("Guardar TP 1",10)
local T1 = boton("TP 1",60)
local G2 = boton("Guardar TP 2",110)
local T2 = boton("TP 2",160)
local G3 = boton("Guardar TP 3",210)
local T3 = boton("TP 3",260)
local Skip = boton("Skip Base",310)
local Up = boton("Elevar arriba",360)
local FlyBtn = boton("Fly (F)",410)

-- VARIABLES
local elevando = false
local flying = false
local flySpeed = 80
local moveVector = Vector3.new(0,0,0)

-- FUNCIONES TP
G1.MouseButton1Click:Connect(function() TP1 = hrp.CFrame end)
T1.MouseButton1Click:Connect(function() if TP1 then hrp.CFrame = TP1 end end)

G2.MouseButton1Click:Connect(function() TP2 = hrp.CFrame end)
T2.MouseButton1Click:Connect(function() if TP2 then hrp.CFrame = TP2 end end)

G3.MouseButton1Click:Connect(function() TP3 = hrp.CFrame end)
T3.MouseButton1Click:Connect(function() if TP3 then hrp.CFrame = TP3 end end)

-- SKIP BASE (TP FORWARD + NOCLIP)
Skip.MouseButton1Click:Connect(function()
	noclip = true
	hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 40)
	task.wait(0.3)
	noclip = false
end)

-- ELEVAR ARRIBA
Up.MouseButton1Down:Connect(function() elevando = true end)
Up.MouseButton1Up:Connect(function() elevando = false end)

-- FLY + NOCLIP
FlyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	noclip = flying
end)

-- MOVIMIENTO FLY
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector + Vector3.new(0,0,-1)
	elseif input.KeyCode == Enum.KeyCode.S then moveVector = moveVector + Vector3.new(0,0,1)
	elseif input.KeyCode == Enum.KeyCode.A then moveVector = moveVector + Vector3.new(-1,0,0)
	elseif input.KeyCode == Enum.KeyCode.D then moveVector = moveVector + Vector3.new(1,0,0)
	elseif input.KeyCode == Enum.KeyCode.Space then moveVector = moveVector + Vector3.new(0,1,0)
	elseif input.KeyCode == Enum.KeyCode.LeftShift then moveVector = moveVector + Vector3.new(0,-1,0)
	elseif input.KeyCode == Enum.KeyCode.F then flying = not flying; noclip = flying end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector - Vector3.new(0,0,-1)
	elseif input.KeyCode == Enum.KeyCode.S then moveVector = moveVector - Vector3.new(0,0,1)
	elseif input.KeyCode == Enum.KeyCode.A then moveVector = moveVector - Vector3.new(-1,0,0)
	elseif input.KeyCode == Enum.KeyCode.D then moveVector = moveVector - Vector3.new(1,0,0)
	elseif input.KeyCode == Enum.KeyCode.Space then moveVector = moveVector - Vector3.new(0,1,0)
	elseif input.KeyCode == Enum.KeyCode.LeftShift then moveVector = moveVector - Vector3.new(0,-1,0)
	end
end)

-- RUN SERVICE
RunService.Heartbeat:Connect(function(delta)
	if elevando then hrp.CFrame = hrp.CFrame + Vector3.new(0, 30*delta, 0) end
	if flying then
		local cam = workspace.CurrentCamera
		local dir = (cam.CFrame.LookVector*moveVector.Z) + (cam.CFrame.RightVector*moveVector.X) + Vector3.new(0, moveVector.Y, 0)
		if dir.Magnitude > 0 then
			hrp.CFrame = hrp.CFrame + dir.Unit * flySpeed * delta
		end
	end
end)

-- TOGGLE
Toggle.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
