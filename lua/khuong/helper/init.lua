---@return string
function Find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd() -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  -- local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, "/") .. "/ rev-parse --show-toplevel")[1]
  local git_root = vim.fn.systemlist("git -C . rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return current_dir
  end
  return git_root
end

---@param path string
---@return string[]
local readPath = function(path) -- turn path into easy to parse array
  local cells = vim.split(path, "/", { trimempty = true })
  return cells
end

---@param arg string
---@return string
function RealPath(arg)
  local currentPath
  if string.sub(arg, 1, 1) == '/' then
    currentPath = "/" -- path is in root directory
  else
    currentPath = vim.fn.expand("%:p:h")
    assert(currentPath ~= nil, "current dir not found")
  end

  local currentCells = readPath(currentPath);
  for cell in string.gmatch(arg, "[^/]+") do
    if cell == ".." then
      table.remove(currentCells) -- remove last element
    elseif cell ~= "." then
      table.insert(currentCells, cell)
    end
  end

  return "/" .. table.concat(currentCells, "/")
end

---@param target_type string
---@return TSNode|nil
function Select_smallest_node(target_type)
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    print("No Tree-sitter parser available for this filetype.")
    return nil
  end

  local root = parser:parse()[1]:root()
  local node = vim.treesitter.get_node()

  local current_node = node

  while current_node do
    local node_type = current_node:type()

    if node_type and node_type:find(target_type) then
      return current_node;
    end

    if current_node:parent() == root then
      return nil
    end
    current_node = current_node:parent()
  end

  return nil
end

---@param node TSNode
function Select_node_visual(node)
    local srow, scol, erow, ecol = node:range()
    vim.api.nvim_win_set_cursor(0, {srow + 1, scol + 1})
    vim.cmd("normal v")
    vim.api.nvim_win_set_cursor(0, {erow + 1, ecol + 1})
end

-- Call the function
-- local node = select_smallest_node("function_call")
-- if node then
--   select_node(0, node)
-- end




