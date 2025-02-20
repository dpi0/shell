local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("lua", {
	s("h", t("hello world")),
})

ls.add_snippets("lua", {
	s("var", {
		t("local "),
		i(1, "name"),
		t(" = "),
		i(2, "'some text'"),
	}),
})

ls.add_snippets("markdown", {
	s("ccl", {
		t({ "```bash", "" }),
		i(1, ""),
		t({ "", "```" }),
	}),
})

ls.add_snippets("markdown", {
	s("img", {
		t("![image]("),
		i(1, "link"),
		t(")"),
	}),
})
