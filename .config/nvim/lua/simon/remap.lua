-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- spell checking
vim.keymap.set("n", "<F8>", ":set spell! spelllang=de_at<CR>")
vim.keymap.set("i", "<F8>", ":set spell! spelllang=de_at<CR>")

-- nvim-tree
vim.keymap.set("n", "<leader>pv", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

vim.keymap.set("i", "{<CR>", "{<CR>}<ESC>O")

-- when nothing works anymore...
vim.keymap.set("n", "<leader>fml", function()
	vim.cmd("CellularAutomaton make_it_rain")
	vim.opt.wrap = false
end)
vim.keymap.set("n", "<leader>gol", function()
	vim.cmd("CellularAutomaton game_of_life")
	vim.opt.wrap = false
end)

-- move multiple lines
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv") -- "x" mode is visual mode without select mode
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search terms in the middle of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- LaTeX mappings
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "tex", "plaintex" },
	callback = function()
		-- LaTeX save and compile
		vim.keymap.set("n", "<F4>", ":w<CR>:!lualatex --shell-escape %<CR><CR>")
		vim.keymap.set("i", "<F4>", "<ESC>:w<CR>:!lualatex --shell-escape %<CR><CR>a")
		vim.keymap.set("n", "<F5>", ":w<CR>:!pdflatex --shell-escape %<CR><CR>")
		vim.keymap.set("i", "<F5>", "<ESC>:w<CR>:!pdflatex --shell-escape %<CR><CR>a")
		-- LaTeX save and compile with biber
		vim.keymap.set("n", "<F17>",
			":w<CR>:!pdflatex --shell-escape %<CR><CR>:!biber %<<CR><CR>:!pdflatex --shell-escape %<CR><CR>")
		vim.keymap.set("i", "<F17>",
			"<ESC>:w<CR>:!pdflatex --shell-escape %<CR><CR>:!biber %<<CR><CR>:!pdflatex --shell-escape %<CR><CR>a")
		-- LaTeX open pdf
		vim.keymap.set("n", "<F6>", function()
			local pdfName = vim.fn.expand("%"):gsub("[.]tex", ".pdf")
			return ":!zathura \"" .. pdfName .. "\" &<CR><CR>"
		end, { expr = true })
		vim.keymap.set("i", "<F6>", function()
			local pdfName = vim.fn.expand("%"):gsub("[.]tex", ".pdf")
			return "<ESC>:!zathura \"" .. pdfName .. "\" &<CR><CR>a"
		end, { expr = true })
	end
})

-- markdown mappings
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "markdown",
	callback = function()
		-- markdown save and compile
		vim.keymap.set("n", "<F5>", function()
			local pdfName = vim.fn.expand("%"):gsub("[.]md", ".pdf")
			return ":w<CR>:!pandoc --verbose --template eisvogel -H ~/.local/share/pandoc/disable_float.tex -o \"" ..
				pdfName .. "\" \"%\"<CR><CR>"
		end, { expr = true })
		vim.keymap.set("i", "<F5>", function()
			local pdfName = vim.fn.expand("%"):gsub("[.]md", ".pdf")
			return "<ESC>:w<CR>:!pandoc --verbose --template eisvogel -H ~/.local/share/pandoc/disable_float.tex -o \"" ..
				pdfName .. "\" \"%\"<CR><CR>a"
		end, { expr = true })
		-- markdown save and compile to html
		vim.keymap.set("n", "<F17>", function()
			local htmlName = vim.fn.expand("%"):gsub("[.]md", ".html")
			return ":w<ESC>:!pandoc --verbose -f markdown -s -t html -o \"" .. htmlName .. "\" \"%\"<CR><CR>"
		end, { expr = true })
		vim.keymap.set("i", "<F17>", function()
			local htmlName = vim.fn.expand("%"):gsub("[.]md", ".html")
			return "<ESC>:w<ESC>:!pandoc --verbose -f markdown -s -t html -o \"" .. htmlName .. "\" \"%\"<CR><CR>a"
		end, { expr = true })

		-- markdown save and compile with marp
		vim.keymap.set("n", "<F4>", ":w<CR>:!marp --pdf \"%\"<CR><CR>")
		vim.keymap.set("i", "<F4>", "<ESC>:w<CR>:!marp --pdf \"%\"<CR><CR>a")
		-- markdown save and compile with marp to html
		vim.keymap.set("n", "<F16>", ":w<CR>:!marp \"%\"<CR><CR>")
		vim.keymap.set("i", "<F16>", "<ESC>:w<CR>:!marp \"%\"<CR><CR>a")

		-- markdown open pdf
		vim.keymap.set("n", "<F6>", function()
			local pdfName = vim.fn.expand("%"):gsub("[.]md", ".pdf")
			return ":!zathura \"" .. pdfName .. "\" &<CR><CR>"
		end, { expr = true })
		vim.keymap.set("i", "<F6>", function()
			local pdfName = vim.fn.expand("%"):gsub("[.]md", ".pdf")
			return "<ESC>:!zathura \"" .. pdfName .. "\" &<CR><CR>a"
		end, { expr = true })
		-- markdown open html
		vim.keymap.set("n", "<F18>", function()
			local pdfName = vim.fn.expand("%"):gsub("[.]md", ".html")
			return ":!zathura \"" .. pdfName .. "\" &<CR><CR>"
		end, { expr = true })
		vim.keymap.set("i", "<F18>", function()
			local pdfName = vim.fn.expand("%"):gsub("[.]md", ".html")
			return "<ESC>:!zathura \"" .. pdfName .. "\" &<CR><CR>a"
		end, { expr = true })
	end
})

-- c mappings
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "c",
	callback = function()
		-- format file
		vim.keymap.set("n", "<leader>f",
			":w<CR>:!clang-format -i %  -style=\"{BasedOnStyle: llvm, IndentWidth: 4}\"<CR><CR>")
	end
})

-- java mappings
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "java",
	callback = function()
		-- format file
		vim.keymap.set("n", "<leader>f", ":w<CR>:!clang-format -i %<CR><CR>")
	end
})
