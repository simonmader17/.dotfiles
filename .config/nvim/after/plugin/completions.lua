local cmp = require('cmp')
local ls = require('luasnip')

local function create_cmp_mapping(ifthis, dothat)
	return cmp.mapping(function(fallback)
		if ifthis() then
			dothat()
		else
			fallback()
		end
	end, { "i", "s" })
end

cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'lua-latex-symbols', option = { cache = true } },
		{ name = 'async_path' },
	},
	mapping = {
		["<Tab>"] = create_cmp_mapping(ls.expand_or_jumpable, ls.expand_or_jump),
		["<S-Tab>"] = create_cmp_mapping(ls.expand_or_jumpable, function() ls.jump(-1) end),
		["<down>"] = create_cmp_mapping(cmp.visible, cmp.select_next_item),
		["<C-n>"] = create_cmp_mapping(cmp.visible, cmp.select_next_item),
		["<up>"] = create_cmp_mapping(cmp.visible, cmp.select_prev_item),
		["<C-p>"] = create_cmp_mapping(cmp.visible, cmp.select_prev_item),
	},
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body)
		end,
	},
})

-- my snippets
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

local tex_snippets = {
	s("snip", {
		t("s(\""), i(1, "SNIPPET_NAME"), t({ "\", {", "" }),
		t("\t"), i(2, "SNIPPET_CONTENT"),
		t({ "", "})," }), i(0)
	}),
	s("qq", {
		t("\\enquote{"), i(1, "TEXT"), t("}"), i(0)
	}),
	s("mysection", {
		t("\\"), i(1, "SECTION_TYPE"), t("*{"), i(2, "SECTION_NAME"), t({ "}", "" }),
		t("\\addcontentsline{toc}{"), rep(1), t("}{"), rep(2), t({ "}", "" }), i(0)
	}),
	s("bfm", {
		t("$\\boldsymbol{"), i(1, "BOLD_MATH"), t("}$"), i(0)
	}),
	s("bf", {
		t("\\textbf{"), i(1, "BOLD_TEXT"), t("}"), i(0)
	}),
	s("it", {
		t("\\textit{"), i(1, "ITALIC_TEXT"), t("}"), i(0)
	}),
	s("tt", {
		t("\\texttt{"), i(1, "TYPEWRITTEN_TEXT"), t("}"), i(0)
	}),
	s("sc", {
		t("\\textsc{"), i(1, "SMALLCAPS_TEXT"), t("}"), i(0)
	}),
	s("inc", {
		t("\\includegraphics[width="), i(1, "\\textwidth"), t("]{"), i(2, "FILENAME"), t("}"), i(0)
	}),
	s("\\begin", {
		t("\\begin{"), i(1, "ENV"), t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{" }), rep(1), t("}")
	}),
	s("\\frac", {
		t("\\frac{"), i(1, "NUMERATOR"), t("}{"), i(2, "DENOMINATOR"), t("}"), i(0)
	}),
	s("\\binom", {
		t("\\binom{"), i(1, "n"), t("}{"), i(2, "k"), t("}"), i(0)
	}),
	s("fig", {
		t({ "\\begin{figure}[H]", "\t\\centering", "\t\\includegraphics[width=" }),
		i(1, "\\textwidth"), t("]{"), i(2, "FILENAME"), t({ "}", "\t\\caption{" }),
		i(3, "CAPTION"), t({ "}", "\t\\label{" }),
		i(4, "LABEL"), t({ "}", "\\end{figure}", "", "" }),
		i(0)
	}),
}
ls.add_snippets("tex", tex_snippets)
ls.add_snippets("plaintex", tex_snippets)

ls.add_snippets("markdown", {
	s("bf", { t("**"), i(1, "BOLD_TEXT"), t("**"), i(0) }),
	s("it", { t("*"), i(1, "ITALIC_TEXT"), t("*"), i(0) }),
	s("tt", { t("`"), i(1, "TYPEWRITTEN_TEXT"), t("`"), i(0) }),
	s("sc", { t("["), i(1, "SMALLCAPS_TEXT"), t("]{.smallcaps}"), i(0) }),
})

ls.add_snippets("typst", {
	s("bf", { t("*"), i(1, "BOLD_TEXT"), t("*"), i(0) }),
	s("hi", { t("#highlight["), i(1, "IMPORTANT_TEXT"), t("]"), i(0)}),
	s("it", { t("_"), i(1, "ITALIC_TEXT"), t("_"), i(0) }),
	s("low", { t("#lower["), i(1, "LOWERCASE_TEXT"), t("]"), i(0)}),
	s("ov", { t("#overline["), i(1, "OVERLINED_TEXT"), t("]"), i(0)}),
	s("sc", { t("#smallcaps["), i(1, "SMALLCAPS_TEXT"), t("]"), i(0) }),
	s("str", { t("#strike["), i(1, "STRIKE_THROUGH_TEXT"), t("]"), i(0)}),
	s("sub", { t("#sub["), i(1, "TEXT_IN_SUBSCRIPT"), t("]"), i(0)}),
	s("sup", { t("#super["), i(1, "TEXT_IN_SUPERSCRIPT"), t("]"), i(0)}),
	s("tt", { t("`"), i(1, "TYPEWRITTEN_TEXT"), t("`"), i(0) }),
	s("un", { t("#underline["), i(1, "UNDERLINED_TEXT"), t("]"), i(0)}),
})

ls.add_snippets("c", {
	s("***", {
		t { "/************************************************", " * " },
		i(1, "COMMENT_TEXT"),
		t { "", " ***********************************************/" }, i(0)
	})
})
-- load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()
