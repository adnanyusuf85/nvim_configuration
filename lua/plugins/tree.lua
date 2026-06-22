return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        -- FORCE THE TREE TO FOLLOW DISK CHANGING COMMANDS
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        actions = {
          change_dir = {
            enable = true,
            global = true, -- Crucial for Windows drive switching
          },
        },
        view = {
          width = 30,
        },
      })

      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true })
    end,
  }
}
