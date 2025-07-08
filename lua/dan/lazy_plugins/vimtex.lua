return {
	"lervag/vimtex",
	init = function()
		vim.g.vimtex_view_method = "zathura" -- Or 'sioyek', 'skim', etc.
		vim.g.vimtex_compiler_method = "latexmk"
	end,
}
