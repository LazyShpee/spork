-- SPORK Init and base functions

if spork then return end

spork = setmetatable({}, {
    __type = "spork",
    __modules = {},

    -- vanilla method backups
    __old_type = type
})

function spork.require(file, ...)
    local args = {...}
    local _, filename = args[2]:match("([\\/]?)([^\\/]+)%.[^.]+$")
    return require(string.gsub(args[1], filename.."$", file, 1))
end