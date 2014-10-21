protocol = require("protocol")

-- Testing Helpers
local MockSock = {}
function MockSock:new()
    local sock = {sent = {}}
    setmetatable(sock, self)
    self.__index = self
    return sock
end

function MockSock:send(str)
    table.insert(self.sent, str)
end

local startswith = function(self, piece)
      return string.sub(self, 1, string.len(piece)) == piece
end

-- Tests
local tests = {
    test_ping = function()
        sock = MockSock:new()
        str = "PING :server"
        expected = "PONG server\n"
        result = protocol.handle(str, sock)
        assert(1 == #sock.sent)
        assert(expected == sock.sent[1])
    end,

    test_hello = function()
        sock = MockSock:new()
        str = ":xterm!omar@aboumrad.info PRIVMSG #betterhangout :hello"
        expected = "PRIVMSG #betterhangout :xterm: hi there :-)\n"
        result = protocol.handle(str, sock)
        assert(1 == #sock.sent)
        assert(expected == sock.sent[1])
    end,

    test_eval = function()
        sock = MockSock:new()
        str = ":xterm!omar@aboumrad.info PRIVMSG #betterhangout := 1+1"
        expected = "PRIVMSG #betterhangout :xterm: 2\n"
        result = protocol.handle(str, sock)
        assert(1 == #sock.sent)
        assert(expected == sock.sent[1])
    end,

    test_failing_eval = function()
        sock = MockSock:new()
        str = ":xterm!omar@aboumrad.info PRIVMSG #betterhangout := kjwkejrkje"
        expected = "PRIVMSG #betterhangout :xterm: Error!"
        result = protocol.handle(str, sock)
        assert(1 == #sock.sent)
        assert(startswith(sock.sent[1], expected))
    end,
}

for name, test in pairs(tests) do
    test()
end
