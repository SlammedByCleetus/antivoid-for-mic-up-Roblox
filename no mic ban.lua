local voiceChatService = game:GetService("VoiceChatService")
local voiceChatInternal = game:GetService("VoiceChatInternal")

local function generateRandomId()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local id = ""
    for i = 1, math.random(8, 16) do
        id = id .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return id
end

pcall(function()
    local randomGroupId = generateRandomId()
    voiceChatInternal:JoinByGroupId(randomGroupId, false)
end)
task.wait(0.1)

pcall(function()
    local randomGroupId = generateRandomId()
    voiceChatInternal:JoinByGroupIdToken(randomGroupId, false, true)
end)
