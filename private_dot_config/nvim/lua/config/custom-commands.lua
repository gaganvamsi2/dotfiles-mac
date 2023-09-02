local M = {}

local function get_text(start_row, start_col, end_row, end_col)
  return vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
end

local function get_lines(start_row, end_row) return vim.api.nvim_buf_get_lines(0, start_row, end_row, true) end

local function is_visual_mode() return vim.tbl_contains({ 'v', 'V', '\22' }, vim.fn.mode(1)) end

local function get_current_region()
  local from_expr, to_expr = "'[", "']"
  if is_visual_mode() then
    from_expr, to_expr = '.', 'v'
  end

  -- Add offset (*_pos[4]) to allow position go past end of line
  local from_pos = vim.fn.getpos(from_expr)
  local from = { line = from_pos[2], col = from_pos[3] + from_pos[4] }
  local to_pos = vim.fn.getpos(to_expr)
  local to = { line = to_pos[2], col = to_pos[3] + to_pos[4] }

  -- Ensure correct order
  if to.line < from.line or (to.line == from.line and to.col < from.col) then
    from, to = to, from
  end

  return { from = from, to = to }
end

local function region_get_text(region, mode)
  local from, to = region.from, region.to
  if mode == 'char' then
    local to_col_offset = vim.o.selection == 'exclusive' and 1 or 0
    return get_text(from.line - 1, from.col - 1, to.line - 1, to.col - to_col_offset)
  end

  if mode == 'line' then return get_lines(from.line - 1, to.line) end
end

function M.addVimUserCommand()
  vim.api.nvim_create_user_command('SendToTmuxPane', function()
    local mode = 'line'
    local region = {}
    if not is_visual_mode() then
      local currentLine = vim.api.nvim_win_get_cursor(0)[1]
      region = { from = { line = currentLine, col = 1 }, to = { line = currentLine, col = 1 } }
    else
      region = get_current_region()
    end
    local register = vim.fn.getreg('m')
    local text = region_get_text(region, mode)
    vim.print(text)
    text = table.concat(text, '\n')
    vim.print(text)
    -- trim white space in register
    register = register:gsub('^%s*(.-)%s*$', '%1')
    local cmd = string.format([[! tmux send-keys -t %s '%s' Enter]], register, text)
    local parsedCmd = vim.api.nvim_parse_cmd(cmd, {})
    vim.api.nvim_cmd(parsedCmd, {})
  end, {})
end

-- Export the module
return M
