-- https://htlin222.medium.com/neovim-tips-utilizes-the-luasnip-and-ripgrep-tools-to-create-backlinks-in-markdown-9e5d245a2930
local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

local function findFilesWithSameName(_, _, _)
    local current_buf = vim.fn.bufname("%")
    local current_file_name = vim.fn.fnamemodify(current_buf, ":t:r")
    local command_template = [[
    rg -i -l "\[\[.*%s.*\]\]" *.md
  ]]
    local command = string.format(command_template, current_file_name)
    local file = io.popen(command, "r")
    local friends = {}
    -- table.insert(friends, "whatever.md")
    for line in file:lines() do
        if line == current_buf then
            -- if same as current_buf then escape
        else
            if line:sub(-3) == ".md" then
                line = "- [[" .. line:sub(1, -4) .. "]] "
            end
            table.insert(friends, line)
        end
    end
    -- delete the last empty line
    return friends
end

ls.add_snippets("markdown", {
    s("backlinks", {
        i(0),
        t("### Backlinks"),
        t({ "", "" }),
        t({ "", "" }),
        f(findFilesWithSameName, {}, {}),
    }),
})

ls.add_snippets("markdown", {
    s("frontmatter", {
        i(0),
        t({ '---', '' }),
        t({ 'title: ""', '' }),
        t({ 'summary: ""', '' }),
        t({ 'public: false', '' }),
        t({ '---', '' }),
    }),
})

ls.add_snippets("html", {
    ls.snippet("html5", { -- "html5" is the trigger
        ls.text_node("<!DOCTYPE html>"),
        ls.text_node("<html lang=\"en\">"),
        ls.text_node("<head>"),
        ls.text_node("    <meta charset=\"UTF-8\">"),
        ls.text_node("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"),
        ls.text_node("    <title>"),
        ls.insert_node(1, "Document"), -- Placeholder 1
        ls.text_node("</title>"),
        ls.text_node("</head>"),
        ls.text_node("<body>"),
        ls.insert_node(0), -- Final cursor position (Placeholder 0)
        ls.text_node("</body>"),
        ls.text_node("</html>")
    })
})
