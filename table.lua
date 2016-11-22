--- Spork table utils

-- This block required to init spork if it isn't already loaded
-- And it should be at the beginning of every spork modules
if not(spork) then
    local args = {...}
    require(string.gsub(args[1], "([/.]?)[^/.]+$", "%1init", 1))
end
local realtype = getmetatable(spork).__old_type

--- Creates sorted iterator for table
-- if no compare function given, sorts by key value
-- @usage for k, v in spork.spair(t) do
-- @param t the table to iterate sort
-- @param f (optional) the compare function, is given keyA, keyB as params, return bool
-- @return sorted iterator
function spork.spair(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end
if spork_global then spair = spork.spair end

--- Finds an element in a table
-- @usage local index = spork.indexOf(tbl, "value")
-- @param t table to find element in
-- @param v element value to find
-- @param f (optional) function to compare v to table values
-- @return index of v in t, nil if not found
function spork.indexOf(t, v, f)
    f = f or function(a, b) return a == b end
    for key, val in pairs() do
        if f(v, val) then return key end
    end
    return nil
end
if spork_global then table.indexOf = spork.indexOf end

--- Fills a table
-- @usage spork.fill(tbl, 42)
-- @param t table to fill
-- @param v value to assign
-- @return t, the filled table
function spork.fill(t, v)
    local vtype = realtype(v)
    for key, val in pairs(t) do
        t[key] = vtype == 'table' and deepcopy(v) or v
    end
    return t
end
if spork_global then table.fill = spork.fill end

--- Merges 2 or more tables, shallow
-- Preserve from left to right
-- @usage spork.merge(table1, table2, ...)
-- @param tables
-- @return a new table of all params merged
function spork.merge(...)
-- @warning this provides as is reference and does NOT deepcopy
    local arg = {...}
    local new = {}
    for i=#arg,1,-1 do
        local t = arg[i]
        for k, v in pairs(t) do
            new[k] = v
        end
    end
    return new
end
if spork_global then table.merge = spork.merge end

--- Makes a deepcopy of a table
-- @usage local tbl = spork.deepcopy(otherTable)
-- @param t table to copy
-- @param cmt (boolean) copy metatable (default: true)
-- @return deepcopied table
function spork.deepcopy(t, cmt)
    local new = {}
    cmt = cmt or true
    for k, v in pairs(t) do
        if realtype(v) == "table" then
            new[k] = spork.deepcopy(v)
            if cmt then
                local mt = getmetatable(v)
                if mt then
                    setmetatable(new[k], deepcopy(mt, false))
                end
            end
        else
            new[k] = v
        end
    end
    return new
end
if spork_global then table.deepcopy = spork.deepcopy end

--- Create a new table
-- @usage local tbl = spork.newTable(10)
-- @param n new table size
-- @param v (optional) value to assign each new index, default: 0
-- @return new table of size n
function spork.newTable(n, v)
    v = v or 0
    local t = {}
    for i=1,n do
        if type(v) == 'function' then t[i] = v(i)
        elseif realtype(v) == 'table' then -- deep copy here
        else t[i] = v
        end
    end
    return t
end
if spork_global then table.newTable = spork.newTable end