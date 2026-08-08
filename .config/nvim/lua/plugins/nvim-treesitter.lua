local function check_treesitter_cli ()
  if vim.fn.executable("tree-sitter") == 1 then
    return true
  else
    vim.notify(
      "`tree-sitter-cli` is missing.",
      vim.log.levels.WARN,
      { title = "nvim-treesitter" }
    )
    return false
  end
end

local group = vim.api.nvim_create_augroup("my_ts_autocmds", { clear = true })

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Run TSUpdate on nvim-treesitter update",
  group = group,
  callback = function (ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if
      name == "nvim-treesitter" and (kind == "install" or kind == "update")
    then
      if not check_treesitter_cli() then return end
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
})

local ts = require("nvim-treesitter")
vim.api.nvim_create_autocmd("FileType", {
  desc = "Automatically install/start treesitter parsers",
  group = group,
  pattern = "*",
  callback = function (ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then return end
    local available_langs = ts.get_available()
    local is_available = vim.tbl_contains(available_langs, lang)
    if is_available then
      local installed_langs = ts.get_installed()
      local installed = vim.tbl_contains(installed_langs, lang)
      if not installed then
        if not check_treesitter_cli() then return end
        ts.install(lang):await(function ()
          if not vim.api.nvim_buf_is_valid(ev.buf) then return end
          vim.treesitter.start(ev.buf, lang)
          vim.notify(
            "Installed and started " .. lang .. " parser",
            vim.log.levels.INFO,
            { title = "nvim-treesitter" }
          )
        end)
      else
        if not vim.api.nvim_buf_is_valid(ev.buf) then return end
        vim.treesitter.start(ev.buf, lang)
      end
    end
  end,
})
