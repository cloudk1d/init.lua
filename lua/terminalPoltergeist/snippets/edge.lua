local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function edge_prefix()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    if col > 0 and line:sub(col, col) == "@" then
        return ""
    end
    return "@"
end

return {
    s("if", {
        f(edge_prefix, {}),
        t("if("),
        i(1),
        t({ ")", "\t" }),
        i(2),
        t({ "", "@end" }),
    }),
    s("elseif", {
        f(edge_prefix, {}),
        t("elseif("),
        i(1),
        t({ ")", "\t" }),
        i(2),
    }),
    s("else", {
        f(edge_prefix, {}),
        t("else"),
        t({ "", "\t" }),
        i(1),
    }),
    s("if-else", {
        f(edge_prefix, {}),
        t("if("),
        i(1),
        t({ ")", "\t" }),
        i(2),
        t({ "", "@else", "\t" }),
        i(3),
        t({ "", "@end" }),
    }),
    s("unless", {
        f(edge_prefix, {}),
        t("unless("),
        i(1),
        t({ ")", "\t" }),
        i(2),
        t({ "", "@end" }),
    }),
    s("each", {
        f(edge_prefix, {}),
        t("each("),
        i(1, "item"),
        t(" in "),
        i(2, "collection"),
        t({ ")", "\t" }),
        i(3),
        t({ "", "@end" }),
    }),
    s("each-index", {
        f(edge_prefix, {}),
        t("each(("),
        i(1, "value"),
        t(", "),
        i(2, "index"),
        t(") in "),
        i(3, "collection"),
        t({ ")", "\t" }),
        i(4),
        t({ "", "@end" }),
    }),
    s("component", {
        f(edge_prefix, {}),
        t("component('"),
        i(1, "components/"),
        t("')"),
        i(2),
        t({ "", "\t" }),
        i(3),
        t({ "", "@end" }),
    }),
    s("component-inline", {
        f(edge_prefix, {}),
        t("!component('"),
        i(1, "components/"),
        t("')"),
    }),
    s("slot", {
        f(edge_prefix, {}),
        t("slot('"),
        i(1),
        t({ "')", "\t" }),
        i(2),
        t({ "", "@end" }),
    }),
    s("inject", {
        f(edge_prefix, {}),
        t("inject("),
        i(1, "values"),
        t(")"),
    }),
    s("eval", {
        f(edge_prefix, {}),
        t("eval("),
        i(1, "expression"),
        t(")"),
    }),
    s("newError", {
        f(edge_prefix, {}),
        t("newError('"),
        i(1, "message"),
        t("', $caller.filename, $caller.line, $caller.col)"),
    }),
    s("include", {
        f(edge_prefix, {}),
        t("include('"),
        i(1, "partials/"),
        t("')"),
    }),
    s("include-if", {
        f(edge_prefix, {}),
        t("includeIf("),
        i(1, "conditional"),
        t(", '"),
        i(2, "partials/"),
        t("')"),
    }),
    s("svg", {
        f(edge_prefix, {}),
        t("svg('"),
        i(1),
        t("')"),
    }),
    s("debugger", {
        f(edge_prefix, {}),
        t("debugger"),
    }),
    s("let", {
        f(edge_prefix, {}),
        t("let("),
        i(1, "variableName"),
        t(" = '"),
        i(2, "value"),
        t("')"),
    }),
    s("assign", {
        f(edge_prefix, {}),
        t("assign("),
        i(1, "expression"),
        t(" = '"),
        i(2, "value"),
        t("')"),
    }),
    s("vite", {
        f(edge_prefix, {}),
        t("vite('"),
        i(1, "resources/js/app.js"),
        t("')"),
    }),
}
