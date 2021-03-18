--[[
    Created by Dremov Aleksandr
    16.03.2021
    -----
    Доработал так чтобы обрабатывались пути при запросе.
--]]
local function processConfig()
    local configName = 'config.yml'

    local configHandle = require('fio').open(configName, {'O_RDONLY'})

    if configHandle == nil then
        print("Config file " .. configName .. ' is not found')
        return nil
    end

    local config = require('yaml').decode(configHandle:read());
    configHandle:close()

    if config == nil then
        print("Wrong config structure")
        return nil
    end

    local uri = require('uri')
    local uriReq   = uri.parse(config.proxy.bypass.host)
    uriReq.service = tostring(config.proxy.bypass.port)
    config.proxy.uri = uriReq
    return config.proxy
end

local function bypassEnv(config)
    local uri = require('uri')
    local client = require('http.client')

    local function bypass(req)
        local http_client = client.new({max_connections = 1})
        local uriReq = config.uri
        uriReq.path = req:path()
        local result = http_client:request(req:method(), uri.format(uriReq) , nil, {
            verify_host = false,
            verify_peer = false,
            accept_encoding = true
        })
        return result
    end

    return bypass
end

local config = processConfig()
if config == nil then return 1 end

local router = require('http.router').new()
local handler = bypassEnv(config)

router:route({ method = 'GET', path = '/.*' }, handler)

-- эта строчка для обхода бага где пустой путь не соответствует /.* 
-- (на Github есть такой pull request)
router:route({ method = 'GET', path = '/' }, handler)  

local server = require('http.server').new('localhost', config.port)

server:set_router(router)
server:start()