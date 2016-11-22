-- SPORK Init and base functions

if spork then return end

spork = setmetatable({}, {
    __type = "spork",
    __modules = {},

    -- vanilla method backups
    __old_type = type
})