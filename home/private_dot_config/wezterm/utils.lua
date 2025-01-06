local utils = {}

function utils.merge(t1, t2)
  print(type(t1), type(t2))
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      utils.merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

--- Merge all the given tables into a single one and return it.
---@param ... table
---@return table
function utils.merge_all(...)
  local ret = {}
  for _, tbl in ipairs({ ... }) do
    if (type(tbl) == "table") then
      ret = utils.merge(ret, tbl)
    end
  end
  return ret
end

return utils
