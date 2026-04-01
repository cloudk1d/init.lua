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

api.nvim_create_augroup("external_file_changes", { clear = true })
api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = "external_file_changes",
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
})

local terraform_restart_pending = false

local function schedule_terraform_restart()
    if terraform_restart_pending then
        return
    end

    terraform_restart_pending = true

    vim.defer_fn(function()
        terraform_restart_pending = false

        local clients = vim.lsp.get_clients({ name = "terraformls" })
        if #clients > 0 then
            for _, client in ipairs(clients) do
                client.stop()
            end
        end

        vim.defer_fn(function()
            pcall(vim.cmd, "LspStart terraformls")
        end, 100)
    end, 300)
end

api.nvim_create_augroup("terraform_lsp_sync", { clear = true })
api.nvim_create_autocmd({ "FocusGained" }, {
    group = "terraform_lsp_sync",
    pattern = { "*.tf", "*.tfvars" },
    callback = function()
        schedule_terraform_restart()
    end,
})
