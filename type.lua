-- This block required to init spork if it isn't already loaded
-- And it should be at the beginning of every spork modules
if not(spork) then
    local args = {...}
    local _, filename = args[2]:match("([\\/]?)([^\\/]+)%.[^.]+$")
    require(string.gsub(args[1], filename.."$", "init", 1))
end

function spork.type(var)
    local _type = getmetatable(spork).__old_type
    local t = _type(var)
    if t == "table" then
        local mt = getmetatable(var)
        if mt and mt.__type then
            local mtt = _type(mt.__type)
            if mtt == "function" then
                return mtt(var)
            end
            return mt.__type
        end
    end
    return t
end

function spork.setType(var, newType)
    local mt = getmetatable(var) or {}
    mt.__type = newType
    setmetatable(var, mt)
    return var
end

if spork_global then type = spork.type setType = spork.setType end