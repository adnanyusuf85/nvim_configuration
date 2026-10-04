--------------------------------------------------------------------------------
-- 1. Leader Keys
--------------------------------------------------------------------------------
-- Leader key must be set before any mappings or plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------------------------------------
-- 2. General Options
--------------------------------------------------------------------------------
-- Line numbers
vim.opt.number = true             -- Show absolute line number on the cursor line
vim.opt.relativenumber = true     -- Show relative line numbers for jumping

-- Mouse & Clipboard
vim.opt.mouse = "a"               -- Enable mouse support in all modes
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- Indentation & Tabs
vim.opt.tabstop = 4               -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4            -- Number of spaces for indent
vim.opt.expandtab = true          -- Use spaces instead of tabs

-- Interface & Command Line Completion
vim.opt.laststatus = 2            -- Show statusline: 2 = always, 3 = global statusline
vim.o.wildmode = "longest:full,full" -- Pressing tab cycles subfolders & command completions

--------------------------------------------------------------------------------
-- 3. General Keymaps
--------------------------------------------------------------------------------
-- Diagnostics: Open floating diagnostics preview
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open diagnostic float" })

-- Terminal Mode: Return to normal mode with Esc
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Bufferline Tab Navigation:
-- Next buffer/tab (or jump directly to buffer [count], e.g. 3gt)
vim.keymap.set("n", "gt", function()
  local count = vim.v.count
  if count > 0 then
    vim.cmd("BufferLineGoToBuffer " .. count)
  else
    vim.cmd("BufferLineCycleNext")
  end
end, { noremap = true, silent = true, desc = "Next tab or Go to tab [count]" })

-- Previous buffer/tab (or jump back by [count], e.g. 2gT)
vim.keymap.set("n", "gT", function()
  local count = vim.v.count
  if count > 0 then
    for _ = 1, count do
      vim.cmd("BufferLineCyclePrev")
    end
  else
    vim.cmd("BufferLineCyclePrev")
  end
end, { noremap = true, silent = true, desc = "Previous tab" })

--------------------------------------------------------------------------------
-- 4. Plugin Manager (lazy.nvim)
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugin specs located in lua/plugins/
require("lazy").setup("plugins")

--------------------------------------------------------------------------------
-- 5. Autocommands
--------------------------------------------------------------------------------
-- Open file explorer on session restore
vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = vim.api.nvim_create_augroup("SessionTreeOpen", { clear = true }),
  callback = function()
    pcall(function()
      require("nvim-tree.api").tree.open()
    end)
  end,
  desc = "Open nvim-tree on session load",
})

--------------------------------------------------------------------------------
-- 6. LSP & Package Management (Mason + Native LSP)
--------------------------------------------------------------------------------
-- 1. Setup Mason to install language servers
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright" },
})

-- 2. Define language servers to enable
local servers = { "lua_ls", "pyright" }

-- 3. Configure and activate each server using Neovim's native LSP API
for _, server in ipairs(servers) do
  -- vim.lsp.config merges defaults from nvim-lspconfig (overrides can be passed in the 2nd argument)
  vim.lsp.config(server, {})
  vim.lsp.enable(server)
end

--------------------------------------------------------------------------------
-- 7. Colorscheme
--------------------------------------------------------------------------------
vim.cmd("colorscheme neofusion")
