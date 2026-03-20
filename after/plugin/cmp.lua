local cmp = require('cmp')

require('copilot_cmp').setup()

cmp.setup({
    sources = {
        { name = 'nvim_lsp', priority = 60 },
        { name = 'copilot',  priority = 50 },
        { name = 'buffer',   priority = 40 },
        { name = 'path',     priority = 30 },
        { name = 'luasnip',  priority = 20 },
        { name = 'marksman', priority = 10 },
    },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
            -- require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- elseif luasnip.expand_or_jumpable() then
                -- luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
                -- elseif luasnip.jumpable(-1) then
                -- luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<M-j>'] = cmp.mapping.scroll_docs(4),
        ['<M-k>'] = cmp.mapping.scroll_docs(-4),
        ['q'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    window = {
        documentation = {
            max_height = 30,
            max_width = 80,
            border = 'rounded'
        },
        completion = {
            border = 'rounded'
        }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})


local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.tab_complete = function()
    if vim.fn.call("vsnip#available", { 1 }) == 1 then
        return t("<Plug>(vsnip-expand-or-jump)")
    elseif vim.fn.pumvisible() then
        return t("<C-n>")
    else
        return t("<Tab>")
    end
end

vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.tab_complete()", { expr = true })
