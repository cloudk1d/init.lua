local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {
    s("props.toAttrs", { t("$props.toAttrs()") }),
    s("props.merge", {
        t("$props.merge({ "),
        i(1),
        t(" }).toAttrs()"),
    }),
    s("props.only", {
        t("$props.only(['"),
        i(1),
        t("']).toAttrs()"),
    }),
    s("props.except", {
        t("$props.except(['"),
        i(1),
        t("']).toAttrs()"),
    }),
    s("slots", {
        t("await $slots."),
        i(1),
    }),
    s("filename", { t("$filename") }),
    s("caller", {
        t("$caller."),
        c(1, { t("filename"), t("line"), t("col") }),
    }),
    s("nl2br", {
        t("nl2br(html.escape("),
        i(1, "contents"),
        t("))"),
    }),
    s("inspect", {
        t("inspect("),
        i(1, "value"),
        t(")"),
    }),
    s("truncate", {
        t("truncate("),
        i(1, "value"),
        t(", "),
        i(2, "100"),
        t(")"),
    }),
    s("excerpt", {
        t("excerpt("),
        i(1, "value"),
        t(", "),
        i(2, "100"),
        t(")"),
    }),
    s("html", {
        t("html."),
        c(1, { t("escape"), t("safe"), t("classNames"), t("attrs") }),
        t("("),
        i(2),
        t(")"),
    }),
    s("stringify", {
        t("js.stringify("),
        i(1),
        t(")"),
    }),
    s("camelCase", {
        t("camelCase('"),
        i(1, "value"),
        t("')"),
    }),
    s("snakeCase", {
        t("snakeCase('"),
        i(1, "value"),
        t("')"),
    }),
    s("dashCase", {
        t("dashCase('"),
        i(1, "value"),
        t("')"),
    }),
    s("pascalCase", {
        t("pascalCase('"),
        i(1, "value"),
        t("')"),
    }),
    s("capitalCase", {
        t("capitalCase('"),
        i(1, "value"),
        t("')"),
    }),
    s("sentenceCase", {
        t("sentenceCase('"),
        i(1, "value"),
        t("')"),
    }),
    s("dotCase", {
        t("dotCase('"),
        i(1, "value"),
        t("')"),
    }),
    s("noCase", {
        t("noCase('"),
        i(1, "value"),
        t("')"),
    }),
    s("titleCase", {
        t("titleCase('"),
        i(1, "value"),
        t("')"),
    }),
    s("pluralize", {
        t("pluralize("),
        i(1, "value"),
        t(")"),
    }),
    s("sentence", {
        t("sentence(["),
        i(1, "'car'"),
        t(", "),
        i(2, "'truck'"),
        t(", "),
        i(3, "'van'"),
        t("], { separator: ', ', lastSeparator: ', or ' })"),
    }),
    s("prettyMs", {
        t("prettyMs("),
        i(1, "60000"),
        t(")"),
    }),
    s("toMs", {
        t("toMs('"),
        i(1, "1min"),
        t("')"),
    }),
    s("prettyBytes", {
        t("prettyBytes("),
        i(1, "1024"),
        t(")"),
    }),
    s("toBytes", {
        t("toBytes('"),
        i(1, "1MB"),
        t("')"),
    }),
    s("ordinal", {
        t("ordinal("),
        i(1, "value"),
        t(")"),
    }),
    s("route", {
        t("route('"),
        i(1, "routeName"),
        t("', ["),
        i(2),
        t("])"),
    }),
    s("signedRoute", {
        t("signedRoute('"),
        i(1, "routeName"),
        t("', ["),
        i(2, "args"),
        t("])"),
    }),
    s("flashMessages", {
        t("flashMessages."),
        c(1, { t("has"), t("get") }),
        t("("),
        i(2, "key"),
        t(")"),
    }),
    s("asset", {
        t("asset('"),
        i(1, "filePath"),
        t("')"),
    }),
    s("csrfField", { t("csrfField()") }),
    s("cspNonce", { t("cspNonce()") }),
    s("auth", {
        t("auth."),
        c(1, { t("user"), t("isAuthenticated") }),
    }),
    s("config", {
        t("config('"),
        i(1, "key"),
        t("')"),
    }),
    s("t", {
        t("t('"),
        i(1, "key"),
        t("', { "),
        i(2),
        t(" })"),
    }),
}
