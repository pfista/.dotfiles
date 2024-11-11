-- plugins/ctrlp.lua
return {
  "ctrlpvim/ctrlp.vim",
  config = function()
    vim.g.ctrlp_map = "<c-p>"
    vim.g.ctrlp_cmd = "CtrlPMixed"
    vim.g.ctrlp_working_path_mode = "ra"
    vim.g.ctrlp_extensions = { "buffertag", "tag", "line", "dir" }
    vim.g.ctrlp_user_command = { ".git", "cd %s && git ls-files -co --exclude-standard" }
  end,
}

