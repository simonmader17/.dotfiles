vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
  {
    src = "https://github.com/L3MON4D3/LuaSnip",
    version = vim.version.range("2.*"),
  },
})

require("luasnip.loaders.from_vscode").lazy_load()

local ls = require("luasnip")
local types = require("luasnip.util.types")
ls.setup({
  ext_opts = {
    [types.insertNode] = {
      passive = { virt_text = { { "<>", "DiffDelete" } } },
    },
  },
})

local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

ls.add_snippets("c", {
  s(
    "***",
    fmta(
      [[
        /************************************************
         * <>
         ***********************************************/
        <>
      ]],
      { i(1, "COMMENT"), i(0) }
    )
  ),
})

ls.add_snippets("markdown", {
  s("bf", fmta("**<>**<>", { i(1, "BOLD_TEXT"), i(0) })),
  s("it", fmta("*<>*<>", { i(1, "ITALIC_TEXT"), i(0) })),
  s("sc", fmta("[<>]{.smallcaps}<>", { i(1, "SMALLCAPS_TEXT"), i(0) })),
  s("tt", fmta("`<>`<>", { i(1, "TYPEWRITTEN_TEXT"), i(0) })),
})
ls.filetype_extend("vimwiki", { "markdown" })

ls.add_snippets("tex", {
  s("qq", fmta([[\enquote{<>}<>]], { i(1, "TEXT"), i(0) })),
  s("bfm", fmta([[$\boldsymbol{<>}$<>]], { i(1, "BOLD_MATH"), i(0) })),
  s("bf", fmta([[\textbf{<>}<>]], { i(1, "BOLD_TEXT"), i(0) })),
  s("it", fmta([[\textit{<>}<>]], { i(1, "ITALIC_TEXT"), i(0) })),
  s("tt", fmta([[\texttt{<>}<>]], { i(1, "TYPEWRITTEN_TEXT"), i(0) })),
  s("sc", fmta([[\textsc{<>}<>]], { i(1, "SMALLCAPS_TEXT"), i(0) })),
  s("\\binom", fmta([[\binom{<>}{<>}<>]], { i(1, "n"), i(2, "k"), i(0) })),
  s(
    "mysection",
    fmta(
      [[
        \<>*{<>}
        \addcontentsline{toc}{<>}{<>}
        <>
      ]],
      { i(1, "SECTION_TYPE"), i(2, "SECTION_NAME"), rep(1), rep(2), i(0) }
    )
  ),
  s(
    "inc",
    fmta(
      [[\includegraphics[width=<>]{<>}<>]],
      { i(1, "\\textwidth"), i(2, "FILENAME"), i(0) }
    )
  ),
  s(
    "\\begin",
    fmta(
      [[
        \begin{<>}
          <>
        \end{<>}
      ]],
      { i(1, "ENV"), i(0), rep(1) }
    )
  ),
  s(
    "\\frac",
    fmta([[\frac{<>}{<>}<>]], { i(1, "NUMERATOR"), i(2, "DENOMINATOR"), i(0) })
  ),
  s(
    "fig",
    fmta(
      [[
        \begin{figure}[H]
          \centering
          \includegraphics[width=<>]{<>}
          \caption{<>}
          \label{<>}
        \end{figure}

        <>
      ]],
      {
        i(1, "\\textwidth"),
        i(2, "FILENAME"),
        i(3, "CAPTION"),
        i(4, "LABEL"),
        i(0),
      }
    )
  ),
})
ls.filetype_extend("plaintex", { "tex" })
ls.filetype_extend("context", { "tex" })

ls.add_snippets("typst", {
  s("bf", fmta("*<>*<>", { i(1, "BOLD_TEXT"), i(0) })),
  s("hi", fmta("#highlight[<>]<>", { i(1, "IMPORTANT_TEXT"), i(0) })),
  s("it", fmta("_<>_<>", { i(1, "ITALIC_TEXT"), i(0) })),
  s("low", fmta("#lower[<>]<>", { i(1, "LOWERCASE_TEXT"), i(0) })),
  s("ov", fmta("#overline[<>]<>", { i(1, "OVERLINED_TEXT"), i(0) })),
  s("sc", fmta("#smallcaps[<>]<>", { i(1, "SMALLCAPS_TEXT"), i(0) })),
  s("str", fmta("#strike[<>]<>", { i(1, "STRIKE_THROUGH_TEXT"), i(0) })),
  s("sub", fmta("#sub[<>]<>", { i(1, "TEXT_IN_SUBSCRIPT"), i(0) })),
  s("sup", fmta("#super[<>]<>", { i(1, "TEXT_IN_SUPERSCRIPT"), i(0) })),
  s("tt", fmta("`<>`<>", { i(1, "TYPEWRITTEN_TEXT"), i(0) })),
  s("un", fmta("#underline[<>]<>", { i(1, "UNDERLINED_TEXT"), i(0) })),
  s(
    "code",
    fmta(
      [[
        ```<>
        <>
        ```

        <>
      ]],
      { i(1, "PROGRAMMING_LANGUAGE"), i(2), i(0) }
    )
  ),
})
