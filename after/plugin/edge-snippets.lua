local ls = require("luasnip")
local util = require("lspconfig.util")

local edge_snippets_loaded = false
local js_helpers_loaded = false

local function load_edge_snippets()
    if edge_snippets_loaded then
        return
    end

    local edge_snippets = require("terminalPoltergeist.snippets.edge")
    ls.add_snippets("edge", edge_snippets, { key = "edge" })
    edge_snippets_loaded = true
end

local function load_js_helper_snippets()
    if js_helpers_loaded then
        return
    end

    local js_helpers = require("terminalPoltergeist.snippets.edge_js_helpers")
    local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "edge" }
    for _, ft in ipairs(filetypes) do
        ls.add_snippets(ft, js_helpers, { key = "edge_js_helpers" })
    end
    js_helpers_loaded = true
end

local function is_adonis_project(bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then
        return false
    end
    return util.root_pattern("adonisrc.ts")(fname) ~= nil
end

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "edge", "html.edge" },
    callback = function()
        load_edge_snippets()
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if ft ~= "javascript" and ft ~= "javascriptreact" and ft ~= "typescript" and ft ~= "typescriptreact" and ft ~= "edge" and ft ~= "html.edge" then
            return
        end

        if is_adonis_project(args.buf) then
            load_js_helper_snippets()
        end
    end,
})
