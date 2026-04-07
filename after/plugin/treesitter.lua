local treesitter = require('nvim-treesitter')

treesitter.setup({})

local ensure_parsers = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "go",
    "javascript",
    "php",
    "php_only",
    "hcl",
    "blade",
}

vim.api.nvim_create_user_command('TSEnsure', function()
    if vim.fn.executable('tree-sitter') ~= 1 then
        vim.notify('tree-sitter CLI not found. Install it first (e.g. `brew install tree-sitter`).', vim.log.levels.WARN)
        return
    end

    treesitter.install(ensure_parsers, { summary = true })
end, { desc = 'Install/update required tree-sitter parsers' })

local ts_filetypes = {
    blade = true,
    c = true,
    edge = true,
    go = true,
    hcl = true,
    ["html.edge"] = true,
    javascript = true,
    lua = true,
    markdown = true,
    php = true,
    query = true,
    terraform = true,
    vim = true,
}

vim.api.nvim_create_autocmd('FileType', {
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        if not ts_filetypes[ft] then
            return
        end

        pcall(vim.treesitter.start, ev.buf)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

vim.treesitter.language.register("html", "edge")
vim.treesitter.language.register("html", "html.edge")
