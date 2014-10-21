M = {}

function M.msg(pattern)
    return '^:(.+)!(.+)@(.+) PRIVMSG (.+) :' .. pattern
end

return M
