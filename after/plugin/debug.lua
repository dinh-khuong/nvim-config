function Log(table, _deep)
  local deep = _deep or 1
  local space = ""
  string.rep(space, deep)
  if type(table) == "table" then
    for name, value in pairs(table) do
      print(space, name, ": ")
      Log(value, deep + 1)
    end
  else
    print(space, table)
  end
end



-- Log({
--  dfd = 3,
--   heloo = {
--     dfsdf = "sdfsdf"
--   }
-- })
--
