function msg(pattern)
    return '^:(.+)!(.+)@(.+) PRIVMSG (.+) :' .. pattern
end
