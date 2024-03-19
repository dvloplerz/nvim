return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
    },
    config = function()
        require("telescope").setup {
            extensions = {
                ['ui-select'] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        }
        pcall(require("telescope").load_extension, 'fzf')
        pcall(require("telescope").load_extension, 'ui-select')

        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>H', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[S]earch Recent Files' })
        vim.keymap.set('n', '<leader>bl', builtin.buffers, { desc = '[B]uffers list' })
    end
}
