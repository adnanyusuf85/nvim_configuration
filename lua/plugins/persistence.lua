return {
  "folke/persistence.nvim",
  lazy = false, -- Force loading immediately on startup
  opts = {
    need = 0, -- Save even if zero or one file is present
    -- Fix Windows path processing by forcing a clean folder inside AppData
    dir = vim.fn.expand("$LOCALAPPDATA/nvim-data/persistence_sessions/"),
  },
  init = function()
    -- Set global native options required to save hidden background buffers
    vim.opt.sessionoptions = { "buffers", "curdir", "winsize", "help", "globals", "folds", "blank" }
  end,
  config = function(_, opts)
    -- Ensure the save directory physically exists on Windows before doing anything
    vim.fn.mkdir(opts.dir, "p")

    require("persistence").setup(opts)

    -- AUTOMATIC RESTORE
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("persistence_auto_load", { clear = true }),
      nested = true,
      callback = function()
        if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
          -- FIXED: Safe modern check to see if a valid session file exists for this directory
          local session_file = require("persistence").current()
          if session_file and vim.fn.filereadable(session_file) == 1 then
            vim.schedule(function()
              require("persistence").load()

              -- Refresh barbar tab interface structures
              pcall(function()
                require("barbar.state").prune_invalid_buffers()
                vim.cmd("redrawtabline")
              end)
            end)
          end
        end
      end,
    })
  end,
  keys = {
    -- Manual emergency restore keymap: Press <leader>qs if auto-load skips it
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
  },
}
