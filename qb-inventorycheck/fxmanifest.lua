fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'インベントリ確認プラグイン - ox_inventoryを使用してプレイヤーのインベントリ内のアイテム情報を取得し、チャットに表示します。'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'qb-core',
    'ox_inventory'
}

lua54 'yes'