-- This block required to init spork if it isn't already loaded
-- And it should be at the beginning of every spork modules
if not(spork) then
    local args = {...}
    require(string.gsub(args[1], "([/.]?)[^/.]+$", "%1init", 1))
end

function spork.pythonise(tbl)
    local mt = getmetatable(tbl) or {}
    function mt.__call(self, args)
        if not args then return end
        local new = {}
        local start, stop, step = string.match(tostring(args), '^([^:]*):?([^:]*):?([^:]*)$')
        start, stop, step = tonumber(start) or 1, tonumber(stop) or #self, tonumber(step) or 1
        if start < 0 then start = #self + start + 1 end
        if stop < 0 then stop = #self + stop + 1 end
        if step < 0 then start, stop = stop, start end
        print(start, stop, step)
        for i=start,stop,step do
            table.insert(new, tbl[i])
        end
        return new
    end
    return setmetatable(tbl, mt)
end

if spork_global then table.pythonise = spork.pythonise end