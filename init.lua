vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 999

vim.opt.virtualedit = "block"

vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])





local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { 
            "rebelot/kanagawa.nvim",

            priority = 1000,
            config = function()
                vim.cmd("colorscheme kanagawa-wave")           
            end,
        },

        {
            "windwp/nvim-autopairs",

            event = "InsertEnter",
            config = true
        },

        {
            "hrsh7th/nvim-cmp",

            event = "InsertEnter",

            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
            },

            config = function() 
                local cmp = require("cmp")

                cmp.setup({
                    snippet = {
                        expand = function(args)
                            vim.snippet.expand(args.body)
                        end,
                    },                    

                    window = {
                        -- completion = cmp.config.window.bordered(),
                        -- documentation = cmp.config.window.bordered(),
                    },

                    mapping = cmp.mapping.preset.insert({
                        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-f>'] = cmp.mapping.scroll_docs(4),
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-e>'] = cmp.mapping.abort(),
                        ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    }),

                    sources = cmp.config.sources(
                        {{ name = 'nvim_lsp' }}, 
                        {{ name = 'buffer' }}
                    ),
                })
            end,
        },

        {
            'nvim-treesitter/nvim-treesitter',

            lazy = false,
            build = ':TSUpdate',
            config = function()
                require("nvim-treesitter.config").setup({
                    highlight = { enabled = true},
                })

                vim.api.nvim_create_autocmd('FileType', {
                    pattern = { 'c', 'cpp', 'lua' },
                    callback = function() vim.treesitter.start() end,
                })

                vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.wo[0][0].foldmethod = 'expr'
                vim.o.foldenable = true
                vim.o.foldlevelstart = 99
            end,
        },

        {
            "neovim/nvim-lspconfig",

            config = function()
                vim.lsp.config("clangd", {})
                vim.lsp.enable("clangd")
            end,
        },
    },

    checker = { enabled = true }
})
