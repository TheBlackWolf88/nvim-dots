return {
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "undotree toggle" }
        }
    },
    {
        "tpope/vim-fugitive"
    },
    {
        "eandrju/cellular-automaton.nvim"
    },
    {
        "laytan/cloak.nvim"
    },
    {
        'aklt/plantuml-syntax',
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    }
}
