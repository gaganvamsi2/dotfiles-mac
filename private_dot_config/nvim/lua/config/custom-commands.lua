local M = {}

local function get_text(start_row, start_col, end_row, end_col)
  return vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
end

local function get_lines(start_row, end_row)
  return vim.api.nvim_buf_get_lines(0, start_row, end_row, true)
end

local function is_visual_mode()
  return vim.tbl_contains({ "v", "V", "\22" }, vim.fn.mode(1))
end

local function get_current_region()
  local from_expr, to_expr = "'[", "']"
  if is_visual_mode() then
    from_expr, to_expr = ".", "v"
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
  if mode == "char" then
    local to_col_offset = vim.o.selection == "exclusive" and 1 or 0
    return get_text(from.line - 1, from.col - 1, to.line - 1, to.col - to_col_offset)
  end

  if mode == "line" then
    return get_lines(from.line - 1, to.line)
  end
end

TmuxPaneIdentifiers = {
  ["{last}            !    The last (previously active) pane"] = "{last}",
  ["{next}            +    The next pane by number"] = "{next}",
  ["{previous}        -    The previous pane by number"] = "{previous}",
  ["{top}                  The top pane"] = "{top}",
  ["{bottom}               The bottom pane"] = "{bottom}",
  ["{left}                 The leftmost pane"] = "{left}",
  ["{right}                The rightmost pane"] = "{right}",
  ["{top-left}             The top-left pane"] = "{top-left}",
  ["{top-right}            The top-right pane"] = "{top-right}",
  ["{bottom-left}          The bottom-left pane"] = "{bottom-left}",
  ["{bottom-right}         The bottom-right pane"] = "{bottom-right}",
  ["{up-of}                The pane above the active pane"] = "{up-of}",
  ["{down-of}              The pane below the active pane"] = "{down-of}",
  ["{left-of}              The pane to the left of the active pane"] = "{left-of}",
  ["{right-of}             The pane to the right of the active pane"] = "{right-of}",
}

function M.addVimUserCommand()
  vim.api.nvim_create_user_command("SendToTmuxPane", function(opts)
    local mode = "line"
    local region = {}
    -- vim.print(opts)
    local default = opts.args == "default"
    if not is_visual_mode() then
      local currentLine = vim.api.nvim_win_get_cursor(0)[1]
      region = { from = { line = currentLine, col = 1 }, to = { line = currentLine, col = 1 } }
    else
      region = get_current_region()
    end
    -- local register = vim.fn.getreg('m')
    local listOfLines = region_get_text(region, mode)
    local text = table.concat(listOfLines, "\n")
    text = text:gsub("'", "'\\''")
    local keyset = {}
    local n = 0
    local selectedTmuxPaneId = "{down-of}"
    for k, _ in pairs(TmuxPaneIdentifiers) do
      n = n + 1
      keyset[n] = k
    end
    if default then
      sendOsCommand(selectedTmuxPaneId, text)
    else
      vim.ui.select(keyset, { prompt = "Select tmux pane: " }, function(selected)
        selectedTmuxPaneId = TmuxPaneIdentifiers[selected]
        sendOsCommand(selectedTmuxPaneId, text)
      end)
    end
  end, { nargs = "*" })
end

function sendOsCommand(selectedTmuxPaneId, text)
  local cmd = string.format([[! tmux send-keys -t %s '%s' Enter]], selectedTmuxPaneId, text)
  local parsedCmd = vim.api.nvim_parse_cmd(cmd, {})
  vim.api.nvim_cmd(parsedCmd, {})
end

-- Export the module
return M
