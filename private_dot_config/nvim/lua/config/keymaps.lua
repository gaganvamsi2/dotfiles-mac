-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- This file is automatically loaded by lazyvim.plugins.config

-- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

vim.keymap.del({ "n", "i", "v" }, "<A-j>")
vim.keymap.del({ "n", "i", "v" }, "<A-k>")
-- Move Lines
-- map("n", "J", ":m .+1<cr>==", { desc = "Move down" })
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- map("i", "J", "<Esc>:m .+1<cr>==gi", { desc = "Move down" })
-- map("n", "K", ":m .-2<cr>==", { desc = "Move up" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up" })
-- map("i", "K", "<Esc>:m .-2<cr>==gi", { desc = "Move up" })

-- lazy
map("n", "<leader>L", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- Paste over currently selected text without yanking it
map("v", "p", '"_dP', { desc = "Paste over currently selected text without yanking it" })

--use <space>h to go beggining of line
--
map("n", "<leader>h", "^", { desc = "go to beggining of the line" })
map("v", "<leader>h", "^", { desc = "go to beggining of the line" })

--use <space>l to go end of line
map("n", "<leader>l", "g_", { desc = "go  to end of the line" })
map("v", "<leader>l", "g_", { desc = "go  to end of the line" })

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- map("n", "zR", require("ufo").openAllFolds, { desc = "open all folds (ufo)" })
-- map("n", "zM", require("ufo").closeAllFolds, { desc = "close all folds (ufo)" })
--

-- floating terminal
local lazyterm = function()
  Util.float_term(nil, { cwd = Util.get_root() })
end
map("n", "<c-_>", lazyterm, { desc = "Open Terminal" })

map("t", "<c-_>", "<cmd>close<cr>", { desc = "Close terminal" })

map("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { desc = "Select left pane" })
map("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { desc = "Select pane below" })
map("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { desc = "Select pane above" })
map("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { desc = "Select pane right" })
map("n", "<C->", "<Cmd>NvimTmuxNavigateLastActive<CR>", { desc = "select last used pane" })

-- unmap windows
map("n", "<leader>ww", "<Nop>", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<Nop>", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<Nop>", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<Nop>", { desc = "Split window right", remap = true })

-- save file
map("n", "<leader>w", "<cmd>w<cr><esc>", { desc = "Save file" })

--center after scroll
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

--Go back and forward
map("n", "gb", "<C-o>", { desc = "go back" })
map("n", "gp", "<C-i>", { desc = "go forward" })

-- source current file
map("n", "gp", "<C-i>", { desc = "go forward" })

map({ "n", "v" }, "<leader>S", "<Cmd>source % | ls<CR>", { desc = "source current file" })

--custom command
require("config.custom-commands").addVimUserCommand()
map({ 'n', 'v' }, '<leader>a', "<Cmd>SendToTmuxPane<CR>", { desc = "send to tmux pane" })
