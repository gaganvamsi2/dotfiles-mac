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

vim.api.nvim_command("autocmd BufWinEnter * normal! zR")
vim.api.nvim_command("autocmd BufReadPost * normal! zR")

vim.api.nvim_command("autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply")

-- Run gofmt + goimport on save

local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').gofmt()
    require('go.format').goimport()
  end,
  group = format_sync_grp,
})
