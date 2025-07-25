return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "python",
                    "c",
                },
                highlight = {
                    auto_install = true,
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",

            {
                {
                    "L3MON4D3/LuaSnip",
                    -- follow latest release.
                    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                    -- install jsregexp (optional!).
                    build = "make install_jsregexp",
                    dependencies = {
                        "rafamadriz/friendly-snippets",
                    },
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                        local ls = require("luasnip")
                        local s = ls.snippet
                        local t = ls.text_node
                        local f = ls.function_node

                        ls.add_snippets("python", {
                            s("switchworld", {
                                f(function()
                                    -- Get cursor position
                                    local row = vim.api.nvim_win_get_cursor(0)[1]
                                    local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)

                                    for i = #lines, 1, -1 do
                                        local func_name = string.match(lines[i], "^%s*def%s+([%w_]+)%s*%(")
                                        if func_name then
                                            local fmtd = func_name .. ".__name__"
                                            return {
                                                "esper.switch_world(" .. fmtd .. ")",
                                                "logger.info(" .. fmtd .. ")",
                                            }
                                        end
                                    end

                                    -- fallback
                                    return {
                                        "esper.switch_world('func')",
                                        "logger.info('func')",
                                    }
                                end, {}),
                            }),
                        })
                    end,
                },
            },
        },
        lazy = false,
        keys = {
            {
                "gd",
                function()
                    vim.lsp.buf.definition()
                end,
            },
            {
                "K",
                function()
                    vim.lsp.buf.hover()
                end,
            },
            {
                "<leader>vws",
                function()
                    vim.lsp.buf.workspace_symbol()
                end,
            },
            {
                "gl",
                function()
                    vim.diagnostic.open_float()
                end,
            },
            {
                "[d",
                function()
                    vim.diagnostic.goto_next()
                end,
            },
            {
                "]d",
                function()
                    vim.diagnostic.goto_prev()
                end,
            },
            {
                "<leader>vca",
                function()
                    vim.lsp.buf.code_action()
                end,
            },
            {
                "<leader>vrr",
                function()
                    vim.lsp.buf.references()
                end,
            },
            {
                "<leader>vrn",
                function()
                    vim.lsp.buf.rename()
                end,
            },
            {
                "<C-h>",
                function()
                    vim.lsp.buf.signature_help()
                end,
                mode = "i",
            },
        },
        config = function()
            local lspconfig = require("lspconfig")
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls" },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({})
                    end,
                },
            })
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
            lspconfig.basedpyright.setup({
                capabilities = vim.lsp.protocol.make_client_capabilities(),
                settings = {
                    basedpyright = {
                        typeCheckingMode = "standard",
                    },
                },
            })
            lspconfig.phpactor.setup({

                capabilities = vim.lsp.protocol.make_client_capabilities(),
                settings = {
                    phpactor = {
                        cmd = { "phpactor", "language-server" },
                        filetypes = { "php" },
                        --root_dir = require("lspconfig.util").root_pattern(".git", ".phpactor.json", ".phpactor.yml"),
                        init_options = {
                            ["indexer.exclude_patterns"] = {
                                "/vendor/**/Tests",
                                "/vendor/**/tests/**/*",
                                "/vendor/composer/**/*",
                                "/generated/**/*",
                                "/pub/static/**/*",
                                "/var/**/*",
                                "/dev/**/*",
                            },
                            ["language_server_phpstan.enabled"] = true,
                            ["language_server_phpstan.level"] = 4,
                        },
                    },
                },
            })

            local cmp = require("cmp")
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- For luasnip users.
                }, {
                    { name = "buffer" },
                }),
            })
            require("fidget").setup({})
        end,
    },
}
