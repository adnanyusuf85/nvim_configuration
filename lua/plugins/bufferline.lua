return { 'akinsho/bufferline.nvim', 
	version = "*", 
	dependencies = 'nvim-tree/nvim-web-devicons',
	-- event = "VeryLazy",
    lazy = false,
	config = function(_, opts)
		require("bufferline").setup({options = opts.options})
	end,
	-- The config will automatically trigger require("bufferline").setup(opts)
	opts = {
		options = {
			mode = "buffers", -- Displays open buffers as tabs
			show_buffer_icons = true,
			-- Closes duplicate path prefixes and shows only the file name
			show_duplicate_prefix = false, 
			-- Safely format the name to strictly return the file's basename
			name_formatter = function(buf)
				return vim.fn.fnamemodify(buf.name, ':t')
			end,
		}
	}
}
