-- Авто трейд скрипт для GAG
-- Конфигурация

-- Сервисы
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- GUI для сообщений
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoTradeGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 350, 0, 250)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Авто Трейд Статус"
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Title

-- Кнопка копирования
local CopyButton = Instance.new("TextButton")
CopyButton.Name = "CopyButton"
CopyButton.Size = UDim2.new(0, 80, 0, 25)
CopyButton.Position = UDim2.new(1, -170, 0, 5)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "Copy All"
CopyButton.TextScaled = true
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Parent = Title

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 4)
UICorner4.Parent = CopyButton

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 80, 0, 25)
CloseButton.Position = UDim2.new(1, -85, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "Close"
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Title

local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 4)
UICorner5.Parent = CloseButton

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "LogFrame"
ScrollingFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = Frame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = ScrollingFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.Padding = UDim.new(0, 2)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Массив для хранения всех сообщений
local allMessages = {}

-- Функция для добавления сообщений в GUI
local function AddMessage(message, messageType)
    messageType = messageType or "info"
    
    local colors = {
        info = Color3.fromRGB(255, 255, 255),
        success = Color3.fromRGB(0, 255, 0),
        warning = Color3.fromRGB(255, 255, 0),
        error = Color3.fromRGB(255, 0, 0)
    }
    
    -- Добавляем сообщение в массив
    table.insert(allMessages, message)
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 0, 20)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = colors[messageType] or colors.info
    TextLabel.Text = message
    TextLabel.TextScaled = true
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = ScrollingFrame
    
    -- Ограничиваем количество сообщений
    local children = ScrollingFrame:GetChildren()
    if #children > 50 then
        children[1]:Destroy()
    end
    
    -- Автоматическая прокрутка вниз
    ScrollingFrame.CanvasPosition = Vector2.new(0, ScrollingFrame.CanvasSize.Y.Offset)
end

-- Функция для копирования всех сообщений
local function CopyAllMessages()
    local clipboard = table.concat(allMessages, "\n")
    
    -- Используем setclipboard если доступен
    if setclipboard then
        setclipboard(clipboard)
        AddMessage("Все сообщения скопированы в буфер обмена!", "success")
    else
        -- Альтернативный способ через GUI
        local clipboardGui = Instance.new("ScreenGui")
        clipboardGui.Name = "ClipboardGui"
        clipboardGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        
        local clipboardFrame = Instance.new("Frame")
        clipboardFrame.Size = UDim2.new(0, 400, 0, 300)
        clipboardFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
        clipboardFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        clipboardFrame.BorderSizePixel = 0
        clipboardFrame.Parent = clipboardGui
        
        local UICorner5 = Instance.new("UICorner")
        UICorner5.CornerRadius = UDim.new(0, 8)
        UICorner5.Parent = clipboardFrame
        
        local clipboardTitle = Instance.new("TextLabel")
        clipboardTitle.Size = UDim2.new(1, 0, 0, 30)
        clipboardTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        clipboardTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        clipboardTitle.Text = "Скопированные сообщения"
        clipboardTitle.TextScaled = true
        clipboardTitle.Font = Enum.Font.GothamBold
        clipboardTitle.Parent = clipboardFrame
        
        local clipboardTextBox = Instance.new("TextBox")
        clipboardTextBox.Size = UDim2.new(1, -20, 1, -40)
        clipboardTextBox.Position = UDim2.new(0, 10, 0, 35)
        clipboardTextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        clipboardTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        clipboardTextBox.Text = clipboard
        clipboardTextBox.TextXAlignment = Enum.TextXAlignment.Left
        clipboardTextBox.TextYAlignment = Enum.TextYAlignment.Top
        clipboardTextBox.TextWrapped = true
        clipboardTextBox.Font = Enum.Font.Gotham
        clipboardTextBox.Parent = clipboardFrame
        
        local closeButton = Instance.new("TextButton")
        closeButton.Size = UDim2.new(0, 80, 0, 25)
        closeButton.Position = UDim2.new(0.5, -40, 1, -30)
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeButton.Text = "Закрыть"
        closeButton.TextScaled = true
        closeButton.Font = Enum.Font.GothamBold
        closeButton.Parent = clipboardFrame
        
        closeButton.MouseButton1Click:Connect(function()
            clipboardGui:Destroy()
        end)
        
        AddMessage("Сообщения показаны в окне. Скопируйте текст вручную.", "info")
    end
end

-- Подключаем кнопку копирования
CopyButton.MouseButton1Click:Connect(CopyAllMessages)

-- Подключаем кнопку закрытия
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    AddMessage("UI закрыт. Скрипт продолжает работать в фоне.", "info")
end)

-- Переменные
local PetGiftingService = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetGiftingService")
local AcceptPetGift = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("AcceptPetGift")
local GiftPet = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("GiftPet")

-- Функция для получения данных питомца
local function GetPetData(tool)
    if not tool or not tool:IsA("Tool") then
        return nil
    end
    
    local petUUID = tool:GetAttribute("PET_UUID")
    if not petUUID then
        return nil
    end
    
    return {
        Name = tool.Name,
        UUID = petUUID,
        Tool = tool
    }
end

-- Функция для получения всего инвентаря
local function GetFullInventory()
    local inventory = {}
    local character = LocalPlayer.Character
    
    if not character then
        return inventory
    end
    
    -- Ищем предметы в персонаже (в руках)
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(inventory, item)
        end
    end
    
    -- Ищем предметы в рюкзаке
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(inventory, item)
            end
        end
    end
    
    return inventory
end

-- Функция для поиска питомцев в инвентаре
local function GetPetsInInventory()
    local pets = {}
    local character = LocalPlayer.Character
    
    if not character then
        return pets
    end
    
    -- Ищем питомцев в персонаже (в руках)
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("PET_UUID") then
            local petData = GetPetData(item)
            if petData then
                table.insert(pets, petData)
            end
        end
    end
    
    -- Ищем питомцев в рюкзаке
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("PET_UUID") then
                local petData = GetPetData(item)
                if petData then
                    table.insert(pets, petData)
                end
            end
        end
    end
    
    return pets
end

-- Функция для взятия питомца в руки
local function EquipPet(petData)
    if not petData or not petData.Tool then
        return false
    end
    
    local character = LocalPlayer.Character
    if not character then
        return false
    end
    
    -- Проверяем, не держим ли уже этот питомец
    local currentTool = character:FindFirstChildWhichIsA("Tool")
    if currentTool and currentTool == petData.Tool then
        return true -- Уже держим нужного питомца
    end
    
    -- Берем питомца в руки
    if petData.Tool.Parent == LocalPlayer.Backpack then
        petData.Tool.Parent = character
        AddMessage("Взял в руки питомца: " .. petData.Name, "info")
    else
        AddMessage("Питомец уже в руках: " .. petData.Name, "info")
    end
    
    return true
end

-- Функция для извлечения основного имени питомца (без веса и возраста)
local function GetBasePetName(fullPetName)
    -- Убираем информацию о весе и возрасте
    local baseName = fullPetName:match("^([^%[]+)")
    if baseName then
        return baseName:gsub("%s+$", "") -- Убираем пробелы в конце
    end
    return fullPetName
end

-- Функция для проверки, является ли питомец в списке для трейда
local function IsPetInTradeList(petName)
    local basePetName = GetBasePetName(petName)
    
    for _, pet in pairs(getgenv().Config.PetsToTrade) do
        if pet == basePetName then
            return true
        end
    end
    return false
end

-- Функция для HTTP запросов к бекенду
local function MakeHttpRequest(url, method, data)
    -- Пробуем разные варианты HTTP запросов
    local request = http_request or syn.request or request or HttpService.RequestAsync
    
    -- Отладочная информация о доступных методах
    if http_request then
        AddMessage("Используется http_request", "info")
    elseif syn and syn.request then
        AddMessage("Используется syn.request", "info")
    elseif request then
        AddMessage("Используется request", "info")
    elseif HttpService.RequestAsync then
        AddMessage("Используется HttpService.RequestAsync", "info")
    else
        AddMessage("Нет доступных методов HTTP запросов", "error")
        return nil
    end
    
    local success, result = pcall(function()
        if method == "GET" then
            if request == HttpService.RequestAsync then
                -- Используем HttpService.RequestAsync как fallback
                local response = request(HttpService, {
                    Url = url,
                    Method = "GET"
                })
                return response.Body
            else
                -- Используем http_request или syn.request
                local response = request({
                    Url = url,
                    Method = "GET"
                })
                return response.Body
            end
        elseif method == "POST" then
            if request == HttpService.RequestAsync then
                -- Используем HttpService.RequestAsync как fallback
                local response = request(HttpService, {
                    Url = url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = HttpService:JSONEncode(data)
                })
                return response.Body
            else
                -- Используем http_request или syn.request
                local response = request({
                    Url = url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = HttpService:JSONEncode(data)
                })
                return response.Body
            end
        elseif method == "DELETE" then
            if request == HttpService.RequestAsync then
                -- Используем HttpService.RequestAsync как fallback
                local response = request(HttpService, {
                    Url = url,
                    Method = "DELETE"
                })
                return response.Body
            else
                -- Используем http_request или syn.request
                local response = request({
                    Url = url,
                    Method = "DELETE"
                })
                return response.Body
            end
        end
    end)
    
    if success and result then
        local success2, decoded = pcall(function()
            return HttpService:JSONDecode(result)
        end)
        
        if success2 then
            return decoded
        else
            AddMessage("Ошибка декодирования JSON: " .. tostring(decoded), "error")
            return nil
        end
    else
        AddMessage("Ошибка HTTP запроса: " .. tostring(result), "error")
        return nil
    end
end

-- Функция для проверки получателей через бекенд
local function CheckReceiversViaBackend()
    if not getgenv().Config.UseBackend then
        return nil
    end
    
    local usernames = table.concat(getgenv().Config.Recipients, ",")
    local url = getgenv().Config.BackendURL .. "/api/check-receivers?usernames=" .. usernames
    
    local response = MakeHttpRequest(url, "GET")
    if response and response.success and response.availableReceivers and #response.availableReceivers > 0 then
        return response.availableReceivers[1] -- Возвращаем первого доступного
    end
    
    return nil
end

-- Функция для телепорта к получателю
local function TeleportToReceiver(receiverData)
    if not getgenv().Config.AutoTeleport or not receiverData then
        return false
    end
    
    local placeId = 126884695634066 -- ID игры GAG
    local serverId = receiverData.serverId
    
    AddMessage("Телепорт к получателю: " .. receiverData.username .. " на сервер: " .. serverId, "info")
    
    local success, error = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, serverId)
    end)
    
    if success then
        AddMessage("Телепорт запущен...", "success")
        return true
    else
        AddMessage("Ошибка телепорта: " .. tostring(error), "error")
        return false
    end
end

-- Функция для поиска первого доступного игрока из списка получателей
local function FindFirstAvailableRecipient()
    -- Сначала проверяем, есть ли получатель на текущем сервере
    for _, username in pairs(getgenv().Config.Recipients) do
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name == username then
                AddMessage("Найден получатель на текущем сервере: " .. player.Name, "success")
                return player
            end
        end
    end
    
    -- Если получателя нет на текущем сервере, проверяем через бекенд
    if getgenv().Config.UseBackend then
        local backendReceiver = CheckReceiversViaBackend()
        if backendReceiver then
            AddMessage("Найден получатель через бекенд: " .. backendReceiver.username, "success")
            
            -- Если включен автотелепорт И мы НЕ получатель, то телепортируемся
            if getgenv().Config.AutoTeleport and LocalPlayer.Name ~= backendReceiver.username then
                TeleportToReceiver(backendReceiver)
                return nil -- Возвращаем nil, так как телепортируемся
            elseif LocalPlayer.Name == backendReceiver.username then
                -- Мы сами получатель, не телепортируемся
                AddMessage("Мы являемся получателем, ожидаем отправителя...", "info")
                return nil
            end
        end
    end
    
    return nil
end

-- Функция для поиска игрока по имени
local function FindPlayerByName(username)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name == username then
            return player
        end
    end
    return nil
end

-- Функция для отправки питомца
local function SendPet(petData, targetPlayer)
    if not petData or not targetPlayer then
        return false
    end
    
    -- Проверяем, что питомец все еще в инвентаре
    if not petData.Tool or not petData.Tool.Parent then
        AddMessage("Питомец больше не найден: " .. petData.Name, "error")
        return false
    end
    
    local args = {
        "GivePet",
        targetPlayer
    }
    
    PetGiftingService:FireServer(unpack(args))
    AddMessage("Отправлен питомец: " .. petData.Name .. " игроку: " .. targetPlayer.Name, "success")
    
    -- Небольшая задержка для обработки сервером
    task.wait(0.2)
    
    return true
end

-- Функция для принятия подарка
local function AcceptGift(giftId)
    local args = {
        true,
        giftId
    }
    
    AcceptPetGift:FireServer(unpack(args))
    AddMessage("Принят подарок с ID: " .. giftId, "success")
end

-- Функция для регистрации получателя в бекенде
local function RegisterAsReceiver()
    if not getgenv().Config.UseBackend then
        return
    end
    
    local username = LocalPlayer.Name
    local jobId = "job-" .. username .. "-" .. tostring(tick())
    local serverId = game.JobId
    
    local data = {
        receiver = username,
        jobId = jobId,
        serverId = serverId
    }
    
    local url = getgenv().Config.BackendURL .. "/api/register-job"
    local response = MakeHttpRequest(url, "POST", data)
    
    if response and response.success then
        AddMessage("Зарегистрирован как получатель в бекенде", "success")
        AddMessage("Job ID: " .. jobId, "info")
        AddMessage("Server ID: " .. serverId, "info")
        
        -- Сохраняем jobId для последующего удаления
        getgenv().CurrentJobId = jobId
        return true
    else
        AddMessage("Ошибка регистрации в бекенде", "error")
        return false
    end
end

-- Функция для удаления регистрации получателя
local function UnregisterAsReceiver()
    if not getgenv().Config.UseBackend or not getgenv().CurrentJobId then
        return
    end
    
    local url = getgenv().Config.BackendURL .. "/api/job/" .. getgenv().CurrentJobId
    local response = MakeHttpRequest(url, "DELETE")
    
    if response and response.success then
        AddMessage("Удалена регистрация получателя", "success")
        getgenv().CurrentJobId = nil
        return true
    else
        AddMessage("Ошибка удаления регистрации", "error")
        return false
    end
end

-- Функция для обновления статуса получателя
local function UpdateReceiverStatus()
    if not getgenv().Config.UseBackend then
        return
    end
    
    local username = LocalPlayer.Name
    local serverId = game.JobId
    
    local data = {
        receiver = username,
        serverId = serverId
    }
    
    local url = getgenv().Config.BackendURL .. "/api/update-receiver"
    local response = MakeHttpRequest(url, "POST", data)
    
    if response and response.success then
        AddMessage("Статус получателя обновлен", "info")
        return true
    else
        AddMessage("Ошибка обновления статуса", "error")
        return false
    end
end

-- Основная функция авто трейда
local function AutoTrade()
    if not getgenv().Config.Enabled then
        return
    end
    
    -- Проверяем, являемся ли мы получателем
    local isReceiver = false
    for _, username in pairs(getgenv().Config.Recipients) do
        if username == LocalPlayer.Name then
            isReceiver = true
            break
        end
    end
    
    -- Если мы получатель, не выполняем логику отправки
    if isReceiver then
        AddMessage("Мы являемся получателем, ожидаем отправителя...", "info")
        return
    end
    
    local targetPlayer = FindFirstAvailableRecipient()
    if targetPlayer then
        AddMessage("Найден получатель: " .. targetPlayer.Name, "success")
    else
        -- Если получателя нет на текущем сервере и включен автотелепорт
        if getgenv().Config.UseBackend and getgenv().Config.AutoTeleport then
            AddMessage("Получатель не найден на текущем сервере, ожидание телепорта...", "info")
            return
        else
            local recipientList = table.concat(getgenv().Config.Recipients, ", ")
            AddMessage("Ни один из получателей не найден на сервере: " .. recipientList, "error")
            return
        end
    end
    
    -- Получаем весь инвентарь
    local fullInventory = GetFullInventory()
    AddMessage("Найдено предметов в инвентаре: " .. #fullInventory, "info")
    
    -- Ищем питомцев для трейда
    local petsToTrade = {}
    local foundPets = {}
    local usedUUIDs = {} -- Для отслеживания уникальных питомцев
    
    for _, item in pairs(fullInventory) do
        if item:IsA("Tool") then
            local petUUID = item:GetAttribute("PET_UUID")
            if petUUID then
                local petData = GetPetData(item)
                if petData then
                    table.insert(foundPets, petData)
                    local baseName = GetBasePetName(petData.Name)
                    AddMessage("Найден питомец: " .. petData.Name .. " (основное имя: " .. baseName .. ")", "info")
                    
                    if IsPetInTradeList(petData.Name) then
                        -- Проверяем, что этот питомец еще не добавлен (по UUID)
                        if not usedUUIDs[petUUID] then
                            table.insert(petsToTrade, petData)
                            usedUUIDs[petUUID] = true
                            AddMessage("Питомец добавлен в список трейда: " .. baseName, "success")
                        else
                            AddMessage("Питомец уже в списке трейда (дубликат): " .. baseName, "warning")
                        end
                    else
                        AddMessage("Питомец НЕ в списке трейда: " .. baseName, "warning")
                    end
                end
            else
                AddMessage("Предмет не является питомцем: " .. item.Name, "info")
            end
        end
    end
    
    AddMessage("Всего найдено питомцев: " .. #foundPets, "info")
    
    if #petsToTrade == 0 then
        AddMessage("Нет питомцев для трейда в инвентаре", "warning")
        return
    end
    
    AddMessage("Найдено питомцев для трейда: " .. #petsToTrade, "info")
    
    -- Показываем всех найденных питомцев для отладки
    for i, petData in pairs(petsToTrade) do
        AddMessage("Питомец " .. i .. ": " .. petData.Name, "info")
    end
    
    local sentCount = 0
    
    -- Создаем копию массива для безопасного удаления элементов
    local petsToSend = {}
    for i, petData in pairs(petsToTrade) do
        petsToSend[i] = petData
    end
    
    for i = #petsToSend, 1, -1 do
        local petData = petsToSend[i]
        
        -- Проверяем, что питомец все еще существует
        if petData and petData.Tool and petData.Tool.Parent then
            -- Сначала берем питомца в руки
            if EquipPet(petData) then
                task.wait(0.5) -- Небольшая задержка после взятия в руки
                
                -- Затем отправляем
                if SendPet(petData, targetPlayer) then
                    sentCount = sentCount + 1
                    task.wait(1) -- Задержка между отправками
                    
                    -- Удаляем питомца из списка после успешной отправки
                    table.remove(petsToSend, i)
                end
            end
        else
            -- Удаляем питомца из списка, если он больше не существует
            table.remove(petsToSend, i)
        end
    end
    
    if sentCount > 0 then
        AddMessage("Отправлено питомцев: " .. sentCount, "success")
    end
end

-- Обработчик входящих подарков
GiftPet.OnClientEvent:Connect(function(giftId, petName, senderName)
    AddMessage("Получен подарок от: " .. senderName .. " Питомец: " .. petName, "success")
    
    -- Автоматически принимаем все подарки
    AcceptGift(giftId)
end)

-- Основной цикл
local function MainLoop()
    while getgenv().Config.Enabled do
        task.wait(5) -- Проверяем каждые 5 секунд
        
        if LocalPlayer.Character then
            AutoTrade()
        end
    end
end

-- Цикл для получателя (регистрация и обновление статуса)
local function ReceiverLoop()
    -- Регистрируемся как получатель при запуске
    if getgenv().Config.UseBackend then
        task.wait(2) -- Небольшая задержка для загрузки
        RegisterAsReceiver()
    end
    
    while getgenv().Config.Enabled do
        task.wait(30) -- Обновляем статус каждые 30 секунд
        
        if getgenv().Config.UseBackend then
            UpdateReceiverStatus()
        end
    end
end

-- Запуск основного цикла
task.spawn(MainLoop)

-- Запуск цикла для получателя
task.spawn(ReceiverLoop)

-- Команды для управления
local function CreateCommands()
    local function ToggleAutoTrade()
        getgenv().Config.Enabled = not getgenv().Config.Enabled
        AddMessage("Авто трейд: " .. (getgenv().Config.Enabled and "Включен" or "Выключен"), "info")
    end
    
    local function SetTargetPlayer(username)
        -- Очищаем список получателей и добавляем одного игрока
        getgenv().Config.Recipients = {username}
        AddMessage("Целевой игрок установлен: " .. username, "info")
    end
    
    local function AddRecipient(username)
        -- Проверяем, нет ли уже такого игрока в списке
        for _, existingPlayer in pairs(getgenv().Config.Recipients) do
            if existingPlayer == username then
                AddMessage("Игрок " .. username .. " уже в списке получателей", "warning")
                return
            end
        end
        
        table.insert(getgenv().Config.Recipients, username)
        AddMessage("Получатель добавлен: " .. username, "success")
    end
    
    local function RemoveRecipient(username)
        for i, player in pairs(getgenv().Config.Recipients) do
            if player == username then
                table.remove(getgenv().Config.Recipients, i)
                AddMessage("Получатель удален: " .. username, "warning")
                break
            end
        end
    end
    
    local function ShowRecipients()
        AddMessage("=== Список получателей ===", "info")
        for i, player in pairs(getgenv().Config.Recipients) do
            AddMessage(i .. ". " .. player, "info")
        end
        AddMessage("=========================", "info")
    end
    
    local function AddPetToTradeList(petName)
        table.insert(getgenv().Config.PetsToTrade, petName)
        AddMessage("Питомец добавлен в список трейда: " .. petName, "success")
    end
    
    local function RemovePetFromTradeList(petName)
        for i, pet in pairs(getgenv().Config.PetsToTrade) do
            if pet == petName then
                table.remove(getgenv().Config.PetsToTrade, i)
                AddMessage("Питомец удален из списка трейда: " .. petName, "warning")
                break
            end
        end
    end
    
    local function ShowConfig()
        AddMessage("=== Конфигурация авто трейда ===", "info")
        AddMessage("Статус: " .. (getgenv().Config.Enabled and "Включен" or "Выключен"), "info")
        AddMessage("Бекенд: " .. (getgenv().Config.UseBackend and "Включен" or "Выключен"), "info")
        AddMessage("Автотелепорт: " .. (getgenv().Config.AutoTeleport and "Включен" or "Выключен"), "info")
        AddMessage("URL бекенда: " .. getgenv().Config.BackendURL, "info")
        AddMessage("Получатели:", "info")
        for i, player in pairs(getgenv().Config.Recipients) do
            AddMessage(i .. ". " .. player, "info")
        end
        AddMessage("Питомцы для трейда:", "info")
        for i, pet in pairs(getgenv().Config.PetsToTrade) do
            AddMessage(i .. ". " .. pet, "info")
        end
        AddMessage("================================", "info")
    end
    
    local function ToggleBackend()
        getgenv().Config.UseBackend = not getgenv().Config.UseBackend
        AddMessage("Бекенд: " .. (getgenv().Config.UseBackend and "Включен" or "Выключен"), "info")
    end
    
    local function ToggleAutoTeleport()
        getgenv().Config.AutoTeleport = not getgenv().Config.AutoTeleport
        AddMessage("Автотелепорт: " .. (getgenv().Config.AutoTeleport and "Включен" or "Выключен"), "info")
    end
    
    local function CheckBackendStatus()
        if not getgenv().Config.UseBackend then
            AddMessage("Бекенд отключен", "warning")
            return
        end
        
        local url = getgenv().Config.BackendURL .. "/api/stats"
        local response = MakeHttpRequest(url, "GET")
        
        if response and response.success then
            AddMessage("=== Статус бекенда ===", "info")
            AddMessage("Активных jobs: " .. response.stats.activeJobs, "info")
            AddMessage("Активных получателей: " .. response.stats.activeReceivers, "info")
            AddMessage("Время сервера: " .. response.stats.serverTime, "info")
            AddMessage("=======================", "info")
        else
            AddMessage("Ошибка подключения к бекенду", "error")
        end
    end
    
    local function RegisterReceiver()
        RegisterAsReceiver()
    end
    
    local function UnregisterReceiver()
        UnregisterAsReceiver()
    end
    
    local function UpdateReceiver()
        UpdateReceiverStatus()
    end
    
    local function CheckRole()
        local isReceiver = false
        for _, username in pairs(getgenv().Config.Recipients) do
            if username == LocalPlayer.Name then
                isReceiver = true
                break
            end
        end
        
        if isReceiver then
            AddMessage("Текущая роль: Получатель (ожидаем отправителя)", "success")
        else
            AddMessage("Текущая роль: Отправитель (ищем получателя)", "info")
        end
    end
    
    -- Глобальные команды
    _G.ToggleAutoTrade = ToggleAutoTrade
    _G.SetTargetPlayer = SetTargetPlayer
    _G.AddRecipient = AddRecipient
    _G.RemoveRecipient = RemoveRecipient
    _G.ShowRecipients = ShowRecipients
    _G.AddPetToTradeList = AddPetToTradeList
    _G.RemovePetFromTradeList = RemovePetFromTradeList
    _G.ShowConfig = ShowConfig
    _G.ToggleBackend = ToggleBackend
    _G.ToggleAutoTeleport = ToggleAutoTeleport
    _G.CheckBackendStatus = CheckBackendStatus
    _G.RegisterReceiver = RegisterReceiver
    _G.UnregisterReceiver = UnregisterReceiver
    _G.UpdateReceiver = UpdateReceiver
    _G.CheckRole = CheckRole
    
    AddMessage("=== Авто трейд скрипт загружен ===", "success")
    
    -- Проверяем роль текущего игрока
    local isReceiver = false
    for _, username in pairs(getgenv().Config.Recipients) do
        if username == LocalPlayer.Name then
            isReceiver = true
            break
        end
    end
    
    if isReceiver then
        AddMessage("РОЛЬ: Получатель (ожидаем отправителя)", "success")
    else
        AddMessage("РОЛЬ: Отправитель (ищем получателя)", "info")
    end
    
    AddMessage("Команды:", "info")
    AddMessage("ToggleAutoTrade() - включить/выключить авто трейд", "info")
    AddMessage("SetTargetPlayer('username') - установить одного целевого игрока", "info")
    AddMessage("AddRecipient('username') - добавить получателя в список", "info")
    AddMessage("RemoveRecipient('username') - удалить получателя из списка", "info")
    AddMessage("ShowRecipients() - показать список получателей", "info")
    AddMessage("AddPetToTradeList('PetName') - добавить питомца в список", "info")
    AddMessage("RemovePetFromTradeList('PetName') - удалить питомца из списка", "info")
    AddMessage("ShowConfig() - показать текущую конфигурацию", "info")
    AddMessage("ToggleBackend() - включить/выключить бекенд", "info")
    AddMessage("ToggleAutoTeleport() - включить/выключить автотелепорт", "info")
    AddMessage("CheckBackendStatus() - проверить статус бекенда", "info")
    AddMessage("RegisterReceiver() - зарегистрироваться как получатель", "info")
    AddMessage("UnregisterReceiver() - удалить регистрацию получателя", "info")
    AddMessage("UpdateReceiver() - обновить статус получателя", "info")
    AddMessage("CheckRole() - проверить текущую роль", "info")
    AddMessage("=====================================", "info")
    AddMessage("Текущий список получателей:", "info")
    for i, player in pairs(getgenv().Config.Recipients) do
        AddMessage(i .. ". " .. player, "info")
    end
    AddMessage("Текущий список питомцев для трейда:", "info")
    for i, pet in pairs(getgenv().Config.PetsToTrade) do
        AddMessage(i .. ". " .. pet, "info")
    end
    
    -- Проверяем статус бекенда при запуске
    if getgenv().Config.UseBackend then
        CheckBackendStatus()
    end
end

CreateCommands() 
