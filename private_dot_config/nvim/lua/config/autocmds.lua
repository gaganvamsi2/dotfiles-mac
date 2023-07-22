-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- local function augroup(name)
--   return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
-- end
--
-- vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
--   group = augroup("open_folds"),
--   pattern = { "*" },
--   command = "normal zR",
-- })

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

augroup("open_folds")
vim.api.nvim_command("autocmd BufWinEnter * normal! zR")
