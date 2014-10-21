require("protocol")

-- Testing Helpers
MockSock = {}
function MockSock:new()
    local sock = {sent = {}}
    setmetatable(sock, self)
    self.__index = self
    return sock
end

function MockSock:send(str)
    table.insert(self.sent, str)
end

function init()
    return MockSock:new()
end

-- Tests
tests = {
    test_ping = function()
        sock = init()
        str = "PING :server"
        expected = "PONG server\n"
        result = handle(str, sock)
        assert(1 == #sock.sent)
        assert(expected == sock.sent[1])
    end,

    test_hello = function()
        sock = init()
        str = ":xterm!omar@aboumrad.info PRIVMSG #betterhangout :hello"
        expected = "PRIVMSG #betterhangout :xterm: hi there :-)\n"
        result = handle(str, sock)
        assert(1 == #sock.sent)
        assert(expected == sock.sent[1])
    end,

    test_eval = function()
        sock = init()
        str = ":xterm!omar@aboumrad.info PRIVMSG #betterhangout := 1+1"
        expected = "PRIVMSG #betterhangout :xterm: 2\n"
        result = handle(str, sock)
        assert(1 == #sock.sent)
        assert(expected == sock.sent[1])
    end,
}

for name, test in pairs(tests) do
    test()
end
