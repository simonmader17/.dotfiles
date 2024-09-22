function ColorMyPencils()
	-- here can be color customizations
end

ColorMyPencils()

-- highlight/preview colors
require("nvim-highlight-colors").setup({
	render = "foreground",
	enable_named_colors = true,
	enable_tailwind = true
})
