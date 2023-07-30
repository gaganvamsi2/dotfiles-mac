return {
  {
    "norcalli/nvim-colorizer.lua",
  },
  {
    "alexghergh/nvim-tmux-navigation",
    opts = {
      disable_when_zoomed = true, -- defaults to false
      keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
        last_active = "<C-\\>",
      },
    },
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "ziontee113/icon-picker.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    config = function()
      require("icon-picker").setup({
        disable_legacy_commands = true,
      })
    end,
  },
}
