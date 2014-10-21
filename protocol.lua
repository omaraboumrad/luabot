local utils = require('utils')

local M = {}

local map = {
    ["^PING :(.+)"] = function(match, sock)
        local target = table.unpack(match)
        sock:send(("PONG %s\n"):format(target))
    end,

    [(utils.msg("hello"))] = function(match, sock)  -- note the change
        local nick, user, host, target = table.unpack(match)
        sock:send(("PRIVMSG %s :%s: hi there :-)\n"):format(target, nick))
    end,

    [(utils.msg("= (.+)"))] = function(match, sock)
        local nick, user, host, target, code = table.unpack(match)
        local status, res = pcall(loadstring("return " .. code))
        local result = status and res or "Error!"
        sock:send(("PRIVMSG %s :%s: %s\n"):format(target, nick, result))
    end
}

function M.handle(msg, sock)
    for pattern, handler in pairs(map) do
        local match = {msg:match(pattern)}
        if #match > 0 then
            print(("=== CAUGHT %s ==="):format(pattern))
            handler(match, sock)
        end
    end
end

return M
