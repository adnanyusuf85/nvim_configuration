-- Set leader key (usually space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic Options
vim.opt.number = true        -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.mouse = "a"          -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.tabstop = 4          -- Number of spaces tabs count for
vim.opt.shiftwidth = 4       -- Size of an indent
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.laststatus = 2  -- 3 activates a single global bar across all screen splits

vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

-- Go to next tab, or jump to specific tab if a count is given (e.g., 3gt)
vim.keymap.set('n', 'gt', function()
  local count = vim.v.count
  if count > 0 then
    vim.cmd('BufferGoto ' .. count)
  else
    vim.cmd('BufferNext')
  end
end, { noremap = true, silent = true, desc = 'Next tab or Go to tab [count]' })

-- Go to previous tab, or jump backward by X tabs if a count is given (e.g., 2gT)
vim.keymap.set('n', 'gT', function()
  local count = vim.v.count
  if count > 0 then
    -- Loops BufferPrevious 'count' times
    for _ = 1, count do
      vim.cmd('BufferPrevious')
    end
  else
    vim.cmd('BufferPrevious')
  end
end, { noremap = true, silent = true, desc = 'Previous tab' })


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("SessionLoadPost", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

-- LSP
-- 1. Setup Mason as normal to handle installations
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright" }, 
})

-- 2. Define the servers you want to run
local servers = { "lua_ls", "pyright" }

-- 3. Initialize and enable them using the new native API
for _, server in ipairs(servers) do
  -- vim.lsp.config automatically merges default configurations from nvim-lspconfig
  -- You can pass overrides inside the second argument table {} if needed
  vim.lsp.config(server, {})
  
  -- Explicitly turn on the server configuration
  vim.lsp.enable(server)
end

-- END LSP

-- End Mason LSP
vim.cmd("colorscheme tokyonight")