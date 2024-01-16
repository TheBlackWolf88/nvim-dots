return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate"

    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',

            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        },
        lazy = false,
        keys = {
            { "gd",          function() vim.lsp.buf.definition() end },
            { "K",           function() vim.lsp.buf.hover() end },
            { "<leader>vws", function() vim.lsp.buf.workspace_symbol() end },
            { "<leader>vd",  function() vim.diagnostic.open_float() end },
            { "[d",          function() vim.diagnostic.goto_next() end },
            { "]d",          function() vim.diagnostic.goto_prev() end },
            { "<leader>vca", function() vim.lsp.buf.code_action() end },
            { "<leader>vrr", function() vim.lsp.buf.references() end },
            { "<leader>vrn", function() vim.lsp.buf.rename() end },
            { "<C-h>",       function() vim.lsp.buf.signature_help() end,  mode = "i" },
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer", "tsserver" },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup {}
                    end
                }
            })
            require("lspconfig").lua_ls.setup {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            }



            local cmp = require("cmp")
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                }),
            })
            require("fidget").setup {}
        end
    }
}
