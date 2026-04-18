local general_group = vim.api.nvim_create_augroup("dotfiles_general_settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = general_group,
    pattern = { "qf", "help", "man", "lspinfo" },
    callback = function(args)
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = args.buf,
            silent = true,
            noremap = true,
        })
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = general_group,
    callback = function()
        vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = general_group,
    callback = function(args)
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
        if vim.bo[args.buf].filetype == "qf" then
            vim.bo[args.buf].buflisted = false
        end
    end,
})

local git_group = vim.api.nvim_create_augroup("dotfiles_git_settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = git_group,
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

local resize_group = vim.api.nvim_create_augroup("dotfiles_auto_resize", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
    group = resize_group,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})
