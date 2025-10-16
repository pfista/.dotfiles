-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup mapleader before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import plugins from the plugins folder
    { import = "plugins" },
    -- Inline plugin specs
    {"nvim-tree/nvim-web-devicons"},
    { "junegunn/vim-easy-align" },
    { "preservim/nerdcommenter" },
    { "jistr/vim-nerdtree-tabs" },
    { "easymotion/vim-easymotion" },
    { "chriskempson/base16-vim" },
    { "altercation/vim-colors-solarized" },
    { "fatih/vim-go" },
    { "majutsushi/tagbar" },
    { "pangloss/vim-javascript" },
    { "mxw/vim-jsx" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-rhubarb" },
    { "w0rp/ale" },
    { "cloudhead/neovim-fuzzy" },
    { "folke/tokyonight.nvim" },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      }
    },
    {
      "f-person/auto-dark-mode.nvim",
      opts = {
        update_interval = 1000,
        set_dark_mode = function()
          vim.api.nvim_set_option_value("background", "dark", {})
          vim.cmd("colorscheme tokyonight")
        end,
        set_light_mode = function()
          vim.api.nvim_set_option_value("background", "light", {})
          vim.cmd("colorscheme base16-default-light")
        end,
      },
    },
  },
  -- Set colorscheme during installation
  -- install = { colorscheme = { "tokyonight", "habamax" } },
  -- Automatically check for plugin updates
  checker = { enabled = true },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require('config/autocmds')
require('config/keymaps')
require('config/options')
