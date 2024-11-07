-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- tty环境把东西拷贝到tmux
-- if os.getenv("XDG_SESSION_TYPE") ~= "x11" and os.getenv("XDG_SESSION_TYPE") ~= "wayland" then
if os.getenv("XDG_SESSION_TYPE") == "tty" then
  vim.g.clipboard = {
    name = 'tmuxClipboard',
    copy = {
      ['+'] = {'tmux', 'load-buffer', '-'},
      ['*'] = {'tmux', 'load-buffer', '-'},
    },
    paste = {
      ['+'] = {'tmux', 'save-buffer', '-'},
      ['*'] = {'tmux', 'save-buffer', '-'},
    },
    cache_enabled = true,
  }
end

-- ::continue::

vim.opt.hidden = false


-- neovide switch
if vim.g.neovide then
  local neovide = require("utils.neovide")
  neovide.init()
end

vim.opt.number = true
vim.opt.relativenumber = false

-- color-pick
vim.cmd([[hi FloatBorder guibg=NONE]])

-- vim.opt.clipboard = "unnamedplus"
vim.opt.clipboard = "unnamedplus"

vim.g.autoformat = false

-- vim.cmd("colorscheme everforest")
vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme gruvbox-material")
vim.cmd([[highlight Cursorline guibg=#3c3836]])
