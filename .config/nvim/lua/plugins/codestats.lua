vim.pack.add({ "https://gitlab.com/code-stats/code-stats-vim" })

vim.g.codestats_api_key = os.getenv("CODESTATS_API_KEY")
