-- Automatically install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "numToStr/Comment.nvim" },
    { "kylechui/nvim-surround" },
    { "farmergreg/vim-lastplace" },
    { "stevearc/aerial.nvim" },
    { "windwp/nvim-autopairs" },
    { "akinsho/bufferline.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },

    -- git
    { 'tpope/vim-fugitive'},
    { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup({
      signcolumn = true,
      numhl      = false,
      linehl     = false,
      word_diff  = false,
    }) end },
    { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' },

    -- ui
    { "rebelot/kanagawa.nvim" },
    { "nvim-telescope/telescope.nvim", dependencies = {"nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim"} },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-tree/nvim-tree.lua", dependencies = {"nvim-tree/nvim-web-devicons"} },
    { "ahmedkhalf/project.nvim", requires = {"nvim-telescope/telescope.nvim"} },
    { "lukas-reineke/indent-blankline.nvim",},

    -- Cmp 
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },

    -- LSP
    { "neovim/nvim-lspconfig" }, -- enable LSP
    { "williamboman/mason.nvim" }, -- simple to use language server installer
    { "williamboman/mason-lspconfig.nvim" },
    { "RRethy/vim-illuminate" },
    { "nvimtools/none-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    -- { "jose-elias-alvarez/null-ls.nvim" },
    { "fatih/vim-go" },

    -- lsp ui 增强 
    { "nvimdev/lspsaga.nvim" },
    { "folke/trouble.nvim", dependencies = "kyazdani42/nvim-web-devicons" },

    -- test
    { "nvim-neotest/neotest",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "antoinemadec/FixCursorHold.nvim", "nvim-neotest/neotest-go", "nvim-neotest/nvim-nio" },
    },

    -- quickfix
    { "kevinhwang91/nvim-bqf", ft = "qf" },

    --find/search
    { "folke/flash.nvim", event = "BufEnter" },
    { "folke/which-key.nvim", requires = { "echasnovski/mini.nvim" }, event = "BufEnter" },
    { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" },

    -- {{{ debug, test
    { "mfussenegger/nvim-dap"},
    { "rcarriga/nvim-dap-ui" },
    { "leoluz/nvim-dap-go" },
    { "theHamsta/nvim-dap-virtual-text" },
    { "nvim-telescope/telescope-dap.nvim" },
})
