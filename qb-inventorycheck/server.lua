local ox_inventory = exports.ox_inventory

-- 権限チェック関数
local function hasPermission(source)
    local player = source
    return IsPlayerAceAllowed(player, "command.checkinv")
end

-- プレイヤーのインベントリ内のアイテム情報を取得し表示する関数
local function showPlayerInventory(source, targetPlayer)
    local inventory = ox_inventory:GetInventory(targetPlayer, true)
    
    if inventory then
        local itemList = "インベントリ内のアイテム:\n"
        for _, item in pairs(inventory.items) do
            if item.count and item.count > 0 then
                itemList = itemList .. string.format("- %s: (%d)\n", item.label, item.count)
            end
        end
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 0},
            multiline = true,
            args = {"システム", itemList}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"システム", "指定されたプレイヤーのインベントリ情報を取得できませんでした。"}
        })
    end
end

-- コマンドを登録して関数を呼び出せるようにする
RegisterCommand('checkinv', function(source, args)
    if not hasPermission(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"システム", "このコマンドを使用する権限がありません。"}
        })
        return
    end

    local targetPlayer
    if not args[1] then
        targetPlayer = source
    else
        targetPlayer = tonumber(args[1])
    end

    if targetPlayer then
        showPlayerInventory(source, targetPlayer)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"システム", "指定されたプレイヤーが見つかりません。"}
        })
    end
end, false)