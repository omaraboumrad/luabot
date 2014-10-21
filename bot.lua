require('protocol')

-- Configuration

account = {
    nickname = "luadukes",
    username = "username",
    hostname = "hostname",
    servername = "servername",
    realname = "realname"
}

server = {
    address = "irc.freenode.net",
    port = 6667,
    channel = "#betterhangout"
}

-- Connectivity
local socket = require("socket")
local tcp = assert(socket.tcp())

tcp:connect(server.address, server.port)

tcp:send(("USER %s %s %s %s\n"):format(
             account.username,
             account.hostname,
             account.servername,
             account.realname))

tcp:send(("NICK %s\n"):format(account.nickname))
tcp:send(("JOIN %s\n"):format(server.channel))

while true do
    local s, status, partial = tcp:receive()
    local msg = s or partial
    print(msg)
    handle(msg, tcp)
end
tcp:close()
