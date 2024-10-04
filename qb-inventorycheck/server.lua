local QBCore = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory

-- 権限チェック関数
-- @param source プレイヤーのソースID
-- @return boolean 管理者権限を持っているかどうか
local function hasPermission(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.group == "admin"
end

-- プレイヤーのインベントリ内のアイテム情報を取得し表示する関数
-- @param source コマンドを実行したプレイヤーのソースID
-- @param targetPlayer インベントリを確認する対象プレイヤーのソースID
local function showPlayerInventory(source, targetPlayer)
    local inventory = ox_inventory:GetInventory(targetPlayer)
    
    if inventory then
        local itemList = "インベントリ内のアイテム:\n"
        -- インベントリ内の各アイテムをリストに追加
        for _, item in pairs(inventory.items) do
            if item.count and item.count > 0 then
                itemList = itemList .. string.format("- %s(%d)\n", item.label, item.count)
            end
        end
        -- チャットにアイテムリストを表示
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 0},
            multiline = true,
            args = {"システム", itemList}
        })
    else
        -- プレイヤーが見つからない場合のエラーメッセージ
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"システム", "指定されたプレイヤーのインベントリ情報を取得できませんでした。"}
        })
    end
end

-- コマンドを登録して関数を呼び出せるようにする
QBCore.Commands.Add('checkinv', '指定したプレイヤーのインベントリを確認します', {{name = 'playerid/name', help = 'プレイヤーIDまたは名前'}}, false, function(source, args)
    -- 権限チェック
    if not hasPermission(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"システム", "このコマンドを使用する権限がありません。"}
        })
        return
    end

    local targetPlayer
    -- 引数がない場合は自分自身のインベントリを確認
    if not args[1] then
        targetPlayer = source
    else
        -- プレイヤーIDが数値の場合
        local target = tonumber(args[1])
        if target then
            targetPlayer = target
        else
            -- プレイヤー名または電話番号で検索
            targetPlayer = findPlayer(args[1])
        end
    end

    -- 対象プレイヤーが見つかった場合はインベントリを表示
    if targetPlayer then
        showPlayerInventory(source, targetPlayer)
    else
        -- プレイヤーが見つからない場合のエラーメッセージ
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"システム", "指定されたプレイヤーが見つかりません。"}
        })
    end
end, 'admin')

-- プレイヤー検索の効率化
-- @param identifier プレイヤーの識別子（電話番号または名前）
-- @return number|nil 見つかった場合はプレイヤーのソースID、見つからない場合はnil
local function findPlayer(identifier)
    local players = QBCore.Functions.GetPlayers()
    for _, v in ipairs(players) do
        local ply = QBCore.Functions.GetPlayer(v)
        if ply and (ply.PlayerData.charinfo.phone == identifier or 
                    ply.PlayerData.charinfo.firstname .. " " .. ply.PlayerData.charinfo.lastname == identifier) then
            return ply.PlayerData.source
        end
    end
    return nil
end