local api = vim.api

api.nvim_create_augroup("formatting", { clear = true })
api.nvim_create_autocmd({ "BufWritePre" }, {
    group = "formatting",
    callback = function(args)
        local filetype = vim.bo[args.buf].filetype
        if filetype == "markdown" then
            vim.lsp.buf.format({
                filter = function(client)
                    return client.name == "marksman"
                end,
            })
            return
        end

        vim.lsp.buf.format()
    end,
})
api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*.js", "*.blade.php", "*.css", "*.html" },
    group = "formatting",
    callback = function()
        vim.cmd("Prettier")
    end,
})
-- api.nvim_create_autocmd({ "BufWritePre" }, {
--     pattern = { "*.html", "*.templ", "*.css", "*.blade.php" },
--     group = "formatting",
--     callback = function()
--         vim.cmd("TailwindSortSync")
--     end,
-- })

api.nvim_create_augroup("lsp_ft", { clear = true })
api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = { "docker-compose*.yml", "docker-compose*.yaml", "*.docker-compose.yml", "*.docker-compose.yaml" },
    group = "lsp_ft",
    callback = function()
        vim.bo.filetype = "yaml.docker-compose"
    end,
})

api.nvim_create_autocmd('VimEnter',
    { pattern = { "*.ps*", "*.pde" }, command = ":set colorcolumn=115" })
-- api.nvim_create_autocmd('VimEnter', { command = ":if argc() == 0 | Explore! | endif | set autoindent" })
api.nvim_create_autocmd('VimEnter',
    { pattern = { "*.tf" }, command = ":setlocal commentstring=#\\ %s | setlocal ft=terraform" })
api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions() end, opts)
        -- vim.keymap.set("n", "gr", function() require('telescope.builtin').lsp_references() end, opts)
    end,
})
