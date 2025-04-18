
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters

		-- list of formatters & linters for mason to install
		require("mason-null-ls").setup({
			ensure_installed = {
				"checkmake",
				"prettier", -- ts/js formatter
				"stylua", -- lua formatter
				"eslint_d", -- ts/js linter
				"shfmt",
				"black",
				"isort",
				"pyproject_flake8",
				"mypy",
			},
			-- auto-install configured formatters & linters (with null-ls)
			automatic_installation = false,
			handlers = {},
		})

		local sources = {
			diagnostics.checkmake,
			formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.terraform_fmt,
			--null_ls.builtins.formatting.isort.with({
			--	prefer_local = ".venv/bin",
			--}),
			null_ls.builtins.formatting.black.with({
				prefer_local = ".venv/bin",
			}),
			--require("none-ls.diagnostics.flake8").with({
			--	prefer_local = ".venv/bin",
			--}),
			--null_ls.builtins.diagnostics.mypy.with({
			--	extra_args = function()
			--		return { "--ignore-missing-imports" }
			--	end,
			--	prefer_local = ".venv/bin",
			--}),
		}

		null_ls.setup({
			-- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
			sources = sources,
			-- you can reuse a shared lspconfig on_attach callback here
			debug = true,
		})
	end,
}
