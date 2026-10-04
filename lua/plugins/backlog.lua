-- lua/plugins/backlog.lua
return {
    dir = vim.fn.stdpath("config"),
    name = "backlog",
    config = function()
        local group = vim.api.nvim_create_augroup("BacklogKeymaps", { clear = true })

        vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
            group = group,
            pattern = "backlog.md",
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                -- 1. Create a new story template
                vim.keymap.set('n', '<leader>an', function()
                    local id = os.time() % 1000
                    local priority = vim.fn.input("Enter Priority (P1, P2, P3): ")
                    if priority == "" then priority = "P2" end
                    local size = vim.fn.input("Enter Story Estimate Points (1, 2, 3, 5, 8): ")
                    if size == "" then size = "3" end
                    
                    local template = string.format("- [ ] #%d | %s | As a ..., I want to ..., So that ... | [Size: %s] | @unassigned", id, priority, size)
                    vim.api.nvim_put({ template }, 'l', true, true)
                end, vim.tbl_extend("force", opts, { desc = "Agile: New Story with Metadata" }))

                -- 2. Sort Selection by Priority Tag (P1 -> P2 -> P3)
                vim.keymap.set('v', '<leader>as', function()
                    local start_line = vim.fn.line("v")
                    local end_line = vim.fn.line(".")
                    if start_line > end_line then start_line, end_line = end_line, start_line end
                    
                    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
                    
                    table.sort(lines, function(a, b)
                        local p_a = a:match("|%s*(P%d)%s*|") or "P9"
                        local p_b = b:match("|%s*(P%d)%s*|") or "P9"
                        return p_a < p_b
                    end)
                    
                    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
                    print("Tasks sorted by priority level.")
                end, vim.tbl_extend("force", opts, { desc = "Agile: Sort Selected Tasks by Priority" }))

                -- 3. Drag tasks manually up/down
                vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', opts)
                vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', opts)

                -- 4. Mark task as IN PROGRESS [/]
                vim.keymap.set('n', '<leader>ai', function()
                    vim.api.nvim_set_current_line(vim.api.nvim_get_current_line():gsub("%[%s%]", "[/]"):gsub("%[x%]", "[/]"))
                end, vim.tbl_extend("force", opts, { desc = "Agile: Progress [/]" }))

                -- 5. Mark task as DONE [x]
                vim.keymap.set('n', '<leader>ad', function()
                    vim.api.nvim_set_current_line(vim.api.nvim_get_current_line():gsub("%[%s%]", "[x]"):gsub("%[/%]", "[x]"))
                end, vim.tbl_extend("force", opts, { desc = "Agile: Done [x]" }))
            end,
        })
    end
}