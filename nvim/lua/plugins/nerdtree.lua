return {
  "preservim/nerdtree",
  config = function()
    vim.g.NERDTreeShowHidden = 1
  end,
  keys = {
    { "<C-n>", ":NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
  },
  cmd = { "NERDTreeToggle", "NERDTreeFind" },
}
