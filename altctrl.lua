getgenv().alts = { 
	4291796146,
	4291812263,
	4292761654,
	4294346964,
	4294353674,
	4294410165,
        4294417558,
        7048199627,
        7048214049,
        7048225533,
        10908411,
        7048214049,
        4289962452,
        7134798569,
        7160595744,
        7162563630,
        7162594376,
        7162600703,
        7170736602,
        7170753512,
        7171510592,
        7171513809,
        7171550388,
        2268805149,
        7162563630,
        7162594376,
        7162600703,
        7170736602,
        7170753512,
        7171510592,
        7171513809,
        7171550388,
        7196463669,
        7208244806,
        7216275048,
        7210785505,
        7249747171,
        7171510592,
}

--getgenv().alts2 = { 
--	123,
--}

getgenv().dont_kick = {
	4291796146,
	4291812263,
	4292761654,
	4294346964,
	4294353674,
	4294410165,
        4294417558,
        7048199627,
        7048214049,
        7048225533,
        10908411,
        7048214049,
        4289962452,
        7134798569,
        7160595744,
        7162563630,
        7162594376,
        7162600703,
        7170736602,
        7170753512,
        7171510592,
        7171513809,
        7171550388,
        1940551269,
        2268805149,
        7162563630,
        7162594376,
        7162600703,
        7170736602,
        7170753512,
        7171510592,
        7171513809,
        7171550388,
        7196463669,
        7208244806,
        7216275048,
        7210785505,
        7249747171,
        7171510592,
}
local ps_owner1 = 4289962452
--local ps_owner2 = 123
local IPV4 = "192.168.1.9"

-- Note: Only ps_owner1 is supported in V1, ps_owner2 is not implemented - Maybe in V2 (later)
-- Following the note above, dont use lines 7-9 and line 16

local Players = game:GetService('Players')
local Terrain = Workspace:FindFirstChild('Terrain')
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService('Workspace')
local replicatedStorage = game:GetService("ReplicatedStorage")
local mainEvent = replicatedStorage:WaitForChild("MainEvent")
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")	

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DropperHUD"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Fullscreen black background (behind everything else)
local bg = Instance.new("Frame")
bg.Name = "Background"
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.BackgroundColor3 = Color3.new(0, 0, 0)
bg.BorderSizePixel = 0
bg.ZIndex = 0
bg.Parent = screenGui

-- Central stats panel
local panel = Instance.new("Frame")
panel.Name = "StatsPanel"
panel.Size = UDim2.new(0, 320, 0, 170)
panel.Position = UDim2.new(0.5, -160, 0.5, -85)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
panel.BorderColor3 = Color3.fromRGB(60, 60, 60)
panel.BorderSizePixel = 1
panel.BackgroundTransparency = 0.05
panel.ZIndex = 5
panel.Parent = screenGui

-- Rounded corners (if supported)
pcall(function()
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = panel
end)

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.PaddingBottom = UDim.new(0, 10)
uiPadding.PaddingLeft = UDim.new(0, 12)
uiPadding.PaddingRight = UDim.new(0, 12)
uiPadding.Parent = panel

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 8)
uiList.Parent = panel

local function makeLabel(name, text, size)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.Size = UDim2.new(1, 0, 0, size or 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 18
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = panel
    return lbl
end

local title = makeLabel("Title", "Dropper Monitor", 26)
title.TextSize = 20
title.Font = Enum.Font.GothamBold

local walletLabel = makeLabel("Wallet", "Wallet: …")
local deltaLabel = makeLabel("Delta", "Dropped: …")

-- FPS row container
local fpsRow = Instance.new("Frame")
fpsRow.Name = "FPSRow"
fpsRow.BackgroundTransparency = 1
fpsRow.Size = UDim2.new(1, 0, 0, 34)
fpsRow.ZIndex = 6
fpsRow.Parent = panel

local fpsList = Instance.new("UIListLayout")
fpsList.FillDirection = Enum.FillDirection.Horizontal
fpsList.SortOrder = Enum.SortOrder.LayoutOrder
fpsList.Padding = UDim.new(0, 6)
fpsList.Parent = fpsRow

local fpsBox = Instance.new("TextBox")
fpsBox.Name = "FPSBox"
fpsBox.Size = UDim2.new(0, 120, 1, 0)
fpsBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
fpsBox.BorderSizePixel = 0
fpsBox.TextColor3 = Color3.new(1,1,1)
fpsBox.PlaceholderText = "FPS cap"
fpsBox.Text = ""
fpsBox.ClearTextOnFocus = false
fpsBox.Font = Enum.Font.Gotham
fpsBox.TextSize = 16
fpsBox.ZIndex = 7
fpsBox.Parent = fpsRow
pcall(function()
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = fpsBox
end)

local setBtn = Instance.new("TextButton")
setBtn.Name = "SetFPS"
setBtn.Size = UDim2.new(0, 90, 1, 0)
setBtn.BackgroundColor3 = Color3.fromRGB(50, 90, 180)
setBtn.BorderSizePixel = 0
setBtn.TextColor3 = Color3.new(1,1,1)
setBtn.Text = "Set"
setBtn.Font = Enum.Font.GothamBold
setBtn.TextSize = 16
setBtn.AutoButtonColor = true
setBtn.ZIndex = 7
setBtn.Parent = fpsRow
pcall(function()
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = setBtn
end)


-- Make panel draggable
local dragging, dragStart, startPos
panel.Active = true
panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)
panel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ================= Tracking Logic =================
local currencyValueObj = localPlayer:WaitForChild("DataFolder"):WaitForChild("Currency")
local startWallet = tonumber(currencyValueObj.Value)
local lastWallet = startWallet

local function formatNumber(n)
    if type(n) ~= "number" then return tostring(n) end
    if n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n/1e3)
    else return tostring(n) end
end

local function updateDisplay()
    local current = tonumber(currencyValueObj.Value)
    local delta = current - startWallet
    local sign = delta > 0 and "+" or (delta < 0 and "-" or "")
    local absDelta = math.abs(delta)
    walletLabel.Text = "Wallet: " .. formatNumber(current)
    deltaLabel.Text = ("Dropped: %s%s"):format(sign, formatNumber(absDelta))
    if delta > 0 then
        deltaLabel.TextColor3 = Color3.fromRGB(60, 220, 120)
    elseif delta < 0 then
        deltaLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
    else
        deltaLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    lastWallet = current
end

currencyValueObj:GetPropertyChangedSignal("Value"):Connect(updateDisplay)

-- Fallback heartbeat (in case property signal missed)
task.spawn(function()
    while task.wait(1) do
        updateDisplay()
    end
end)

updateDisplay()

-- ============== FPS Setter ==============
local function applyFPS()
    local txt = fpsBox.Text:gsub("%s+", "")
    local v = tonumber(txt)
    if not v or v < 1 then
        statusLabel.Text = "Status: Invalid FPS"
        statusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
        return
    end
    if typeof(setfpscap) == "function" then
        local ok, err = pcall(function() setfpscap(v) end)
        if ok then
            statusLabel.Text = "Status: FPS set to " .. v
            statusLabel.TextColor3 = Color3.fromRGB(80, 200, 120)
        else
            statusLabel.Text = "Status: setfpscap error"
            statusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
        end
    else
        statusLabel.Text = "Status: setfpscap unavailable"
        statusLabel.TextColor3 = Color3.fromRGB(220, 160, 60)
    end
end

setBtn.MouseButton1Click:Connect(applyFPS)
fpsBox.FocusLost:Connect(function(enter)
    if enter then applyFPS() end
end)


if table.find(getgenv().alts, localPlayer.UserId) then
		local client_id = "Server-1"
		settings().Rendering.QualityLevel = 1
		for _,v in ipairs(game:GetService("Workspace"):GetDescendants()) do
			-- Remove all seating in the game (prevents bugs)
			if v:IsA('Seat') or string.lower(v.Name):match('seat') then 
				v:remove()
			-- Handle parts and their properties
			elseif v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") or v:IsA("WedgePart") then
				v.Material = "SmoothPlastic"
				v.Reflectance = 0
				if v.Name ~= "Radius" and v.Name ~= "Siren" and v.Name ~= "SNOWs_" and not v:IsA("VehicleSeat") and not v:IsDescendantOf(ITEMS_DROP) and not v:IsDescendantOf(PLAYERS_FOLDER) and not v:IsDescendantOf(SHOP) and not v:IsDescendantOf(SPAWN) and not v:IsDescendantOf(LIGHTS) and not v:IsDescendantOf(PLAYER.Character) then
					v:Destroy()
				elseif v.Parent == SPAWN then
					v.CanCollide = true
				elseif v.Parent == ITEMS_DROP then
					-- Platform the item drop locations
					local platform = Instance.new("Part")
					platform.Name = "ItemPlatform"
					platform.Anchored = true
					platform.Transparency = 1
					platform.Size = Vector3.new(5, 0.1, 5)
					platform.Position = v.Position - Vector3.new(0, 3, 0)
					platform.Parent = SPAWN
				end
			-- Destroy decals
			elseif v:IsA("Decal") then
				v:Destroy()
			-- Handle particle effects
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0)
			-- Modify explosion properties
			elseif v:IsA("Explosion") then
				v.BlastPressure = 1
				v.BlastRadius = 1
			end
		end


		local optimize = pcall(function()
			local names = {"Players", "Camera", "Terrain", localplayer.Name}
			for _, instance in workspace:GetChildren() do
				if not table.find(names, instance.Name) then
					instance:Destroy()
				end
			end
		
			local names = {"Drop", localplayer.Name}
			for _, instance in workspace.Ignored:GetChildren() do
				if not table.find(names, instance.Name) then
					instance:Destroy()
				end
			end
		
			for _, instance in workspace.Ignored.HouseItemSale:GetChildren() do
				instance:Destroy()
			end
		
		
		end)
		
		local teleportPositions = {
			{ -393.01, 15, -338 },
			{ -381.01, 15, -338 },
			{ -369.01, 15, -338 },
			{ -357.01, 15, -338 },
			{ -393.01, 15, -325 },
			{ -381.01, 15, -325 },
			{ -369.01, 15, -325 },
			{ -357.01, 15, -325 },
			{ -393.01, 15, -312 },
			{ -381.01, 15, -312 },
			{ -369.01, 15, -312 },
			{ -357.01, 15, -312 },
			{ -393.01, 15, -299 },
			{ -381.01, 15, -299 },
			{ -369.01, 15, -299 },
			{ -357.01, 15, -299 },
			{ -393.01, 15, -286 },
			{ -381.01, 15, -286 },
			{ -369.01, 15, -286 },
			{ -357.01, 15, -286 },
			{ -393.01, 15, -273 },
			{ -381.01, 15, -273 },
			{ -369.01, 15, -273 },
			{ -357.01, 15, -273 },
			{ -393.01, 15, -260 },
			{ -381.01, 15, -260 },
			{ -369.01, 15, -260 },
			{ -357.01, 15, -260 },
			{ -393.01, 15, -247 },
			{ -381.01, 15, -247 },
			{ -369.01, 15, -247 },
			{ -357.01, 15, -247 },
			{ -393.01, 15, -233 },
			{ -381.01, 15, -233 },
			{ -369.01, 15, -233 },
			{ -357.01, 15, -233 },
			{ -405.01, 15, -299 },
			{ -405.01, 15, -286 },
			{ -405.01, 15, -273 },
		}
		
		function getAltNumber(userId)
			local alts = getgenv().alts
			for i, id in ipairs(alts) do
				if userId == id then
					return i
				end
			end
			return false
		end
		
		local function teleport(position)
			local position = CFrame.new(position[1], position[2], position[3])
			task.spawn(function()
				while task.wait() do
					pcall(function()
						localPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = position
						localPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0, 0, 0)
					end)
				end
			end)
		end
		
		local allowedusers = {}
		local userList = {}
		
		local function printUserList()
			for userId, value in pairs(userList) do
				print(userId .. ": " .. value)
			end
		end
		
		local function isProtectedPlayer(userId)
			for _, id in ipairs(getgenv().alts) do
				if userId == id then
					return true
				end
			end
			for _, id in ipairs(getgenv().dont_kick) do
				if userId == id then
					return true
				end
			end
			return false
		end
		
		local function vipKick(player)
		
			if not isProtectedPlayer(player.UserId) then
				game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Kick", player)
			end
			
		end
		
		local function shout(message)
			game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("Shout", message)
		end
		
		
		local function addUser(userId, value)
			userList[userId] = value  
		end
		
		local function addUseralloweduser(userId, channelId)
			table.insert(allowedusers, { userId = userId, channelId = channelId })
		end
		
		local function getChannelIdByUserId(userId)
			for _, user in ipairs(allowedusers) do
				-- Check if the userId matches
				if user.userId == userId then
					return user.channelId  -- Return the associated channelId
				end
			end
			-- If userId is not found
			return nil  -- Return nil if the userId is not found
		end
		
		
		local function userExists(userId)
			-- Iterate over the allowedusers table
			for _, user in ipairs(allowedusers) do
				-- Check if the userId matches
				if user.userId == userId then
					return true
				end
			end
			-- Return false if no match is found
			return false
		end
		
		
		local function deleteUser(userId)
			userList[userId] = nil
		end
		
		
		local function removeUser(userId)
			for index, user in ipairs(allowedusers) do
				-- Check if the userId matches
				if user.userId == userId then
					-- Remove the user from the list
					table.remove(allowedusers, index)
					print("User " .. userId .. " has been removed.")
					return  -- Exit the function after removing the user
				end
			end
			-- If user was not found, print this message
			print("User " .. userId .. " not found.")
		end
		
		function teleportBasedOnAltNumber(player)
			local userId = player.UserId
			local altNumber = getAltNumber(userId)
			local position = teleportPositions[altNumber] or { -381.01, 35.75, -286 }
		
			teleport(position)
		end
		
	



		if localPlayer.UserId == ps_owner1 then
			local ws = WebSocket.connect("ws://" .. IPV4 .. ":8080")
			ws:Send(client_id)


			local currencyPostFixes = {
				["k"] = 1000,
				["m"] = 1000000,
				["b"] = 1000000000,
			}
			local function Track(user, amount, D_user_id, D_guild)
				print("running track for " .. user)
				print("Raw input amount: ", amount)
				-- Process amount with currency post-fix
				for postFix, value in pairs(currencyPostFixes) do
					if string.find(amount, postFix) then
						local rawNumberString = string.gsub(amount, postFix, "")
						local amountNumber = tonumber(rawNumberString)
						amount = amountNumber * value
						break
					end
				end

				amount = tonumber(amount)
				if not amount then
					warn("Invalid amount for user: " .. tostring(user))
					return
				end
			
				-- Update amount based on userList
				if userList[user] then
					local value = tonumber(userList[user])
					amount = tonumber(amount)
					if value and amount then
						if value < amount then
							amount = amount + value
						else
							print("User:" .. user .. " has a higher or equal amount in userList, not updating.")
						end
					else
						warn("Invalid value or amount for user: " .. tostring(user))
					end
					deleteUser(user)
				end
			
				print("amount", amount)
			
				-- Wait for the player to be found in the game
				repeat task.wait()
				until game:GetService("Players"):FindFirstChild(user)
				
				-- Localize the target variable for each coroutine (this avoids shared state)
				local target = game:GetService("Players"):FindFirstChild(user)
				
				print("target found: ", target)
			
				local oldcurrency = tonumber(target:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
				local need = oldcurrency + amount
				local Channel_ID = getChannelIdByUserId(user)
				local User_ID = target.UserId  -- Correct User_ID from the localized 'target'
				print("Channel_ID", Channel_ID)
				print("User_ID", User_ID)
				print("oldcurrency", oldcurrency)
				print("need", need)
			
				local discord_id = D_user_id or "False"
				local discord_guild = D_guild or "False"
				
				-- Send starter data with correct User_ID
				local starter_data = string.format("%s %s %s %s %s %s %s %s", client_id, "ADD-USER", Channel_ID, User_ID, oldcurrency, need, discord_id, discord_guild)
				ws:Send(starter_data)
				
				local new = 0  -- Track the current currency value
				local last_cash_value = 0  -- Track the previous currency value
				local CASH_SPENT = 0  -- Track the total amount spent
				local last_change_value = 0  -- Track if the currency changed
				
                local last_change_value = 0  -- Track if the currency changed
                local last_sent_time = 0  -- Track when the last message was sent
                local send_interval = 10  -- Interval in seconds between sends
                
                -- Monitor balance until the target has enough currency
                repeat
                    task.wait()
                
                    -- Ensure the target player exists and is active
                    local target = game:GetService("Players"):FindFirstChild(user)
                
                    if target then
                        -- Get the current currency value
                        new = tonumber(target:WaitForChild("DataFolder"):WaitForChild("Currency").Value)
                
                        -- Only calculate CASH_SPENT when there is a decrease in the currency
                        if last_cash_value == 0 then
                            -- Initial setup for last_cash_value
                            last_cash_value = new
                        else
                            -- Track if the value has decreased (player spent currency)
                            if last_cash_value > new then
                                -- Calculate how much has been spent
                                local spent = last_cash_value - new
                                -- Accumulate spent amount to CASH_SPENT
                                CASH_SPENT = CASH_SPENT + spent
                            end
                            -- Update last_cash_value with the most recent value
                            last_cash_value = new
                        end
                
                        -- Check if 10 seconds have passed since the last message
                        local current_time = tick()  -- Returns current time in seconds
                        if current_time - last_sent_time >= send_interval then
                            -- Prepare the update message to send
                            local updated = string.format("%s %s %s %s %s", client_id, "UPDATE-BALANCE", Channel_ID, new, CASH_SPENT)
                            ws:Send(updated)
                
                            -- Update last_sent_time to current time
                            last_sent_time = current_time
                        end
                
                        -- Check if there is no change in currency for this iteration
                        if new ~= last_change_value then
                            last_change_value = new  -- Update last_change_value if it changed
                        end
                    end
                
                -- Loop until the player's currency reaches the target or the player is not found
                until new + CASH_SPENT >= need or target == nil
                
		
				print("Bello")
				if new + CASH_SPENT >= need then
					print("Target reached their goal: " .. tostring(new))
					removeUser(user)
					local updated2 = string.format("%s %s %s %s %s", client_id, "UPDATE-BALANCE", Channel_ID, new, CASH_SPENT)
					ws:Send(updated2)
					--local finished_M = string.format("%s %s %s", client_id, "BLOCK", user)
					--ws:Send(finished_M)
					local finished_M = string.format("%s %s %s", client_id, "UNFRIEND-USER", Channel_ID)
					ws:Send(finished_M)
					shout("Please leave the game " .. user .. " or you will be kicked.")
					wait(5)
					shout("Last chance to leave " .. user .. "!")
					wait(5)
					vipKick(target)
					wait(5)
					if game:GetService("Players"):FindFirstChild(target.Name) then
						print("Kick failed, trying again...")
						vipKick(target)
						wait(5)
						if game:GetService("Players"):FindFirstChild(target.Name) then
							print("Kick failed after retry, notifying Discord bot.")
							local error_msg = string.format("%s %s %s %s %s", client_id, "KICK-ERROR", Channel_ID, target.Name, target.UserId)
							ws:Send(error_msg)
						end
					end
					return true
				else
					print("target left game")
					local remaining = need - new
					addUser(user, remaining)
					return false
				end
			end



			local function formatCurrency(value)
				if value >= 1e9 then
					return string.format("%.1fB", value / 1e9)
				elseif value >= 1e6 then
					return string.format("%.1fM", value / 1e6)
				elseif value >= 1e3 then
					return string.format("%.1fK", value / 1e3)
				else
					return tostring(value)
				end
			end
			
			
			local function sendserveralts()
				local output = ""
				for _, player in pairs(game.Players:GetPlayers()) do
					if table.find(getgenv().alts, player.UserId) then
						local currency = player:WaitForChild("DataFolder"):WaitForChild("Currency")
						local formattedCurrency = formatCurrency(currency.Value)
						output = output .. player.Name .. ":" .. player.UserId .. ":" .. formattedCurrency .. ","
					end
				end
				if #output > 0 then
					output = output:sub(1, -2)
				end
				local dataaa = string.format("%s %s %s", client_id, "SERVER-STOCK", output)
				ws:Send(dataaa)
			end
			
			local function sendservercash()
				local totalCurrency = 0  -- Initialize total currency to 0
				for _, player in pairs(game.Players:GetPlayers()) do
					if table.find(getgenv().alts, player.UserId) then
						local currency = player:WaitForChild("DataFolder"):WaitForChild("Currency")
						totalCurrency = totalCurrency + currency.Value 
					end
				end
			
				local formattedCurrency = formatCurrency(totalCurrency)
			
				local dataaa = string.format("%s %s %s", client_id, "SERVER-CASH", formattedCurrency)
				
				print(formattedCurrency)
			
				ws:Send(dataaa)
			end




			local function printTable(tbl, name)
				print(name .. ":")
				for k, v in pairs(tbl) do
					print("  ", k, v)
				end
			end
		
			local loadingPlayers = {}

			local function onPlayerAdded(player)
				
				if localPlayer.UserId == ps_owner1 then
					loadingPlayers[player.Name] = {
									userId = player.UserId,
									joinTime = tick(),
									channelId = userExists(player.Name) and getChannelIdByUserId(player.Name) or nil
								}
					local success = pcall(function()
						player.CharacterAdded:Wait()
						repeat
							task.wait()
						until player.Character and player.Character:FindFirstChild("FULLY_LOADED_CHAR") ~= nil        
					end)
                   
					loadingPlayers[player.Name] = nil

					print("Player joined:", player.Name)
					printTable(userList, "userList")
					printTable(allowedusers, "allowedusers")
					if userList[player.Name] then
						print("player is in userlist adding them")
						local remaining = userList[player.Name]
						print("Remaining amount for " .. player.Name .. ": " .. remaining)
						Track(player.Name, tostring(remaining))
						game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
					elseif userExists(player.Name) then
						print("user exists in list not kicking")
						game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
					else
						if not isProtectedPlayer(player.UserId) then
							print(player.Name, " is not in blocking them")
							shout("Please leave the game " .. player.Name .. " or you will be kicked.")
							wait(20)
							
							-- Use a localized variable for target2 here
							local target2 = game:GetService("Players"):FindFirstChild(player.Name)
							
							-- Only proceed if target2 is found
							if target2 then
								local finished_L = string.format("%s %s %s", client_id, "BLOCK", player.Name)
								ws:Send(finished_L)
								wait(10)
								vipKick(target2)  -- Kick the player if target2 is found
							else
								print("Target2 not found for player:", player.Name)
							end
						else
							print("player is an admin, not kicking")
							game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("VIP_CMD", "Summon", player)
						end
					end
				end
			end			
			
			Players.PlayerAdded:Connect(onPlayerAdded)


			local function onPlayerRemoving(player)
					if localPlayer.UserId == ps_owner1 then
						if loadingPlayers[player.Name] then
							local playerData = loadingPlayers[player.Name]
							local loadTime = tick() - playerData.joinTime
							
							print("Player left during loading:", player.Name, "after", loadTime, "seconds")

							local channelId = playerData.channelId or "UNKNOWN"
							local error_msg = string.format("%s %s %s %s %s %s", client_id, "LOAD-ERROR", channelId, player.Name, player.UserId, loadTime)
							ws:Send(error_msg)

							loadingPlayers[player.Name] = nil
						end
					end
				end

				Players.PlayerRemoving:Connect(onPlayerRemoving)

			ws.OnMessage:Connect(function(message)
					print("Message received:", message)
					local parts = {}
					
					for word in string.gmatch(message, "%S+") do
						table.insert(parts, word)
					end
					print("Part[1] is equal to", parts[1])
					if parts[1] == "drop" then
						print("Drop command received")
						if #parts > 2 then
							print("more than 2 parts, checking...")
							local money = parts[2]
							local name = parts[3]
							local Channel = parts[4]
							local d_id = parts[5]
							local g_id = parts[6]
							
							local co = coroutine.create(function()
								print("Drop command received")
								if localPlayer.UserId == ps_owner1 then
									print("Running stuff")
									addUser(name, money) -- <-- Add this line!
									addUseralloweduser(name, Channel)
									Track(name, money, d_id, g_id)
								end
							end)
							coroutine.resume(co)
						else
							print("Invalid drop command format")
						end
					elseif parts[1] == "leaderboard" then
						local co = coroutine.create(function()
							print("Running leaderboard")
							sendserveralts()
						end)
						coroutine.resume(co)
					elseif parts[1] == "stock" then
						local co = coroutine.create(function()
							print("Running sendservercash command")
							sendservercash()
						end)
						coroutine.resume(co)
					elseif parts[1] == "kick" then
						if #parts > 1 then
							local targetUsername = parts[2]
							
							local co = coroutine.create(function()
								print("Kick command received for player: " .. targetUsername)

								local targetPlayer = nil
								for _, player in pairs(game:GetService("Players"):GetPlayers()) do
									if player.Name:lower() == targetUsername:lower() then
										targetPlayer = player
										break
									end
								end
								
								if targetPlayer then
									print("Found target player: " .. targetPlayer.Name)
									if not isProtectedPlayer(targetPlayer.UserId) then
										print("Kicking player: " .. targetPlayer.Name)
										shout("You have been kicked from this server: " .. targetPlayer.Name)
										vipKick(targetPlayer)

										wait(5)
										if game:GetService("Players"):FindFirstChild(targetPlayer.Name) then
											print("Kick failed, trying again...")
											vipKick(targetPlayer)
											wait(5)
											if game:GetService("Players"):FindFirstChild(targetPlayer.Name) then
												print("Kick failed after retry.")
												local error_msg = string.format("%s %s %s %s %s", client_id, "KICK-COMMAND-ERROR", "UNKNOWN", targetPlayer.Name, targetPlayer.UserId)
												ws:Send(error_msg)
											else
												local success_msg = string.format("%s %s %s", client_id, "KICK-SUCCESS", targetPlayer.Name)
												ws:Send(success_msg)
											end
										else
											local success_msg = string.format("%s %s %s", client_id, "KICK-SUCCESS", targetPlayer.Name)
											ws:Send(success_msg)
										end
									else
										print("Player is protected, not kicking: " .. targetPlayer.Name)
										local error_msg = string.format("%s %s %s %s", client_id, "KICK-COMMAND-ERROR", "PROTECTED", targetPlayer.Name, targetPlayer.UserId)
										ws:Send(error_msg)
									end
								else
									print("Target player not found: " .. targetUsername)
									local error_msg = string.format("%s %s %s %s", client_id, "KICK-COMMAND-ERROR", "NOT_FOUND", targetUsername, "unknown")
									ws:Send(error_msg)
								end
							end)

							coroutine.resume(co)
						else
							print("Invalid kick command format. Expected: kick username")
						end
					else
						print("Unknown command")
					end
			end)
		end
		
		
		local function cashToInt(stringValue)
			local noDollarSign = string.sub(stringValue, 2, #stringValue)
			local noComma = string.gsub(noDollarSign, ",", "")
			local toInt = tonumber(noComma)
			
			return toInt
		end
		
		local function countFloorCash()
			local totalFloorCashAmount = 0
		
			for _,v in pairs(workspace.Ignored.Drop:GetChildren()) do
				if v:IsA("Part") then
					local amount = cashToInt(v.BillboardGui.TextLabel.Text)
					totalFloorCashAmount += amount
				end
			end
		
			return totalFloorCashAmount
		end
		
		
		local function isOwnerInGame()
			for _, player in pairs(Players:GetPlayers()) do
				if player.UserId == ps_owner1 then
					return true
				end
			end
			return false
		end
		
		

		local function dropCashIfNeeded()
			while true do
				task.wait(15.5)
				if countFloorCash() < 6000000 then
					if localPlayer.UserId == ps_owner1 then
						mainEvent:FireServer("DropMoney", 15000)
					elseif table.find(getgenv().alts, localPlayer.UserId) and isOwnerInGame() then
						mainEvent:FireServer("DropMoney", 15000)
					else
						local ReplicatedStorage = game:GetService("ReplicatedStorage")
						local chatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents")
						local CHAT_EVENT = chatEvents:WaitForChild("SayMessageRequest")
						CHAT_EVENT:FireServer("Waiting for ps owner to be in server.", "All")
					end
				end
			end
		end
		local co1 = coroutine.create(function()
			dropCashIfNeeded()
		end)
		coroutine.resume(co1)
		

		settings().Rendering.QualityLevel = 1
		UserSettings().GameSettings.MasterVolume = 0
		setfpscap(3)
		RunService:Set3dRenderingEnabled(false)    
		
		
		
		local GC = getconnections or get_signal_cons
			if GC then
				for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
					if v["Disable"] then
						v["Disable"](v)
					elseif v["Disconnect"] then
						v["Disconnect"](v)
					end
				end
			end
		print("Ran")
		
		
		function ismacro() 
			return game:GetService("Lighting"):GetAttribute("MacroAllow") or false 
		end 
		
        local isroleplay = function()
        local roleplay = game:GetService("Players"):GetAttribute("Roleplay")
            return roleplay or false 
        end 
		
		
		if localPlayer.UserId ~= ps_owner1 then
			teleportBasedOnAltNumber(localPlayer)
		else
			if isroleplay() == false then
				game:GetService("ReplicatedStorage"):WaitForChild("MainEvent"):FireServer("RoleplayModeChange")
			end
			teleportBasedOnAltNumber(localPlayer)
		end
end
