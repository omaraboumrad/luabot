utils = require('utils')

map = {
    ["^PING :(.+)"] = function(match, sock)
        target = table.unpack(match)
        sock:send(("PONG %s\n"):format(target))
    end,

    [(msg("hello"))] = function(match, sock)
        nick, user, host, target = table.unpack(match)
        sock:send(("PRIVMSG %s :%s: hi there :-)\n"):format(target, nick))
    end,

    [(msg("= (.+)"))] = function(match, sock)
        nick, user, host, target, code = table.unpack(match)
        local result = loadstring("return " .. code)()
        sock:send(("PRIVMSG %s :%s: %s\n"):format(target, nick, result))
    end
}

function handle(msg, sock)
    for pattern, handler in pairs(map) do
        local match = {msg:match(pattern)}
        if #match > 0 then
            print(("=== CAUGHT %s ==="):format(pattern))
            handler(match, sock)
        end
    end
end
