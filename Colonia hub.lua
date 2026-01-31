COLONIA HUB | M == Enum.KeyCode.F then flying = not flying; noclip = flying end
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
Toggle.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end
