vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) 
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end

]]

local fugitive_blame_group = vim.api.nvim_create_augroup("dotfiles_fugitive_blame", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = fugitive_blame_group,
    pattern = "fugitiveblame",
    callback = function()
        vim.schedule(function()
            if vim.bo.filetype == "fugitiveblame" then
                require("stacks.git").align_fugitive_blame(vim.api.nvim_get_current_buf())
            end
        end)
    end,
})
