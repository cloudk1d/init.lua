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

        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if client and client.name == "terraformls" and vim.api.nvim_get_current_buf() == e.buf and vim.fn.mode() == "i" then
            vim.schedule(function()
                local ok, cmp = pcall(require, "cmp")
                if ok then
                    cmp.complete()
                end
            end)
        end
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

local terraform_restart_pending = {}

local function cleanup_orphan_terraform_clients()
    local clients = vim.lsp.get_clients({ name = "terraformls" })
    for _, client in ipairs(clients) do
        if #vim.lsp.get_buffers_by_client_id(client.id) == 0 then
            vim.lsp.stop_client(client.id, true)
        end
    end
end

local function schedule_terraform_restart(bufnr)
    if terraform_restart_pending[bufnr] then
        return
    end

    terraform_restart_pending[bufnr] = true

    vim.defer_fn(function()
        terraform_restart_pending[bufnr] = nil
        cleanup_orphan_terraform_clients()

        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        local clients = vim.lsp.get_clients({ name = "terraformls", bufnr = bufnr })
        for _, client in ipairs(clients) do
            vim.lsp.buf_detach_client(bufnr, client.id)

            local attached_bufs = vim.lsp.get_buffers_by_client_id(client.id)
            if #attached_bufs == 0 then
                vim.lsp.stop_client(client.id, true)
            end
        end

        vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(bufnr) then
                return
            end

            if #vim.lsp.get_clients({ name = "terraformls", bufnr = bufnr }) > 0 then
                cleanup_orphan_terraform_clients()
                return
            end

            vim.api.nvim_buf_call(bufnr, function()
                pcall(vim.cmd, "LspStart terraformls")
            end)

            vim.defer_fn(cleanup_orphan_terraform_clients, 200)
        end, 100)
    end, 300)
end

api.nvim_create_augroup("terraform_lsp_sync", { clear = true })
api.nvim_create_autocmd({ "BufWritePost" }, {
    group = "terraform_lsp_sync",
    pattern = { "*.tf", "*.tfvars" },
    callback = function(args)
        schedule_terraform_restart(args.buf)
    end,
})
