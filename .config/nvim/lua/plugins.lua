-- Automatically install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
local is_macos = vim.fn.has("macunix") == 1

require("lazy").setup({
    { "kylechui/nvim-surround" },
    { "farmergreg/vim-lastplace" },
    { "windwp/nvim-autopairs" },
    { "akinsho/bufferline.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },

    -- git
    { "tpope/vim-fugitive" },
    { "lewis6991/gitsigns.nvim" },
    { "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- ui
    { "rebelot/kanagawa.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "ahmedkhalf/project.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
    { "lukas-reineke/indent-blankline.nvim" },

    -- LSP
    { "neovim/nvim-lspconfig" }, -- enable LSP
    { "williamboman/mason.nvim" }, -- simple to use language server installer

    -- lsp ui 增强
    { "folke/trouble.nvim", dependencies = "kyazdani42/nvim-web-devicons" },

    -- test
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-go",
            "nvim-neotest/nvim-nio",
        },
    },

    -- quickfix
    { "kevinhwang91/nvim-bqf", ft = "qf" },

    -- find/search
    { "folke/flash.nvim", event = "BufEnter" },
    { "folke/which-key.nvim", dependencies = { "echasnovski/mini.nvim" }, event = "BufEnter" },
    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- debug, test
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui" },
    { "leoluz/nvim-dap-go" },
    { "theHamsta/nvim-dap-virtual-text" },
    { "nvim-telescope/telescope-dap.nvim" },
})
