return {
    'https://gitlab.com/itaranto/preview.nvim',
    version = '*',
    opts = {
        previewers_by_ft = {
            markdown = {
                name = 'pandoc_wkhtmltopdf',
                renderer = { type = 'command', opts = { cmd = { 'zathura' } } },
            },
            plantuml = {
                name = 'plantuml_png',
                renderer = { type = 'command', opts = { cmd = { 'feh' } } },
            },
            groff = {
                name = 'groff_ms_pdf',
                renderer = { type = 'command', opts = { cmd = { 'zathura' } } },
            },
        },
        render_on_write = false,
    },
}
