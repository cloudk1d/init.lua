local telescope = require("telescope")
local builtin = require('telescope.builtin') -- Telescope provides some builtin finding functions
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local previewers_utils = require('telescope.previewers.utils')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>bf', builtin.buffers)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
-- vim.keymap.set('n', '<leader>fs', ':Telescope grep_string initial_mode=n search=<C-R><C-W><CR>')

-- THANKS: https://github.com/nvim-telescope/telescope.nvim/issues/623
local max_size = 100000
local truncate_large_files = function(filepath, bufnr, opts)
    opts = opts or {}

    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then return end
        if stat.size > max_size then
            local cmd = { "head", "-c", max_size, filepath }
            previewers_utils.job_maker(cmd, bufnr, opts)
        else
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
    end)
end

telescope.setup({
    defaults = {
        layout_strategy = "horizontal",
        layout_config = {
            preview_cutoff = 120,
            prompt_position = "top",
            horizontal = {
                mirror = false,
                height = { padding = 0 },
                width = { padding = 0 },
                preview_width = 0.5
            }
        },
        hidden = true,
        no_ignore = true,
        sorting_strategy = "ascending",
        file_ignore_patterns = {
            "%.git", "node_modules"
        },
        buffer_previewer_maker = truncate_large_files,
        results_title = (function()
            local cwd = vim.fn.getcwd()
            return " (" .. cwd .. ")"
        end)(),
        border = true,
        mappings = {
            n = {
                ["dd"] = actions.delete_buffer,
                ["q"] = actions.close,
                ["<C-p>"] = require('telescope.actions.layout').toggle_preview,
            },
            i = {
                ["<esc>"] = actions.close,
                ["<C-p>"] = require('telescope.actions.layout').toggle_preview,
            }
        }
    },
    pickers = {
        find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            initial_mode = "insert"
        },
        git_files = {
            initial_mode = "normal"
        },
        buffers = {
            initial_mode = "normal",
            sort_lastused = true,
            -- previewer = false,
        },
        live_grep = {
            find_command = { "rg", "--hidden", "--glob", "!**/.git/*" },
            initial_mode = "insert"
        },
        lsp_definitions = {
            file_ignore_patterns = {},
        },
        lsp_type_definitions = {
            file_ignore_patterns = {},
        },
        lsp_implementations = {
            file_ignore_patterns = {},
        },
        lsp_references = {
            file_ignore_patterns = {},
        }
    },
})

require('telescope').load_extension('terraform_doc')
