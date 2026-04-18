vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1                           -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = ""                              -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = true                         -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 2                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 300                        -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 300                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program) it is not allowed to be edited
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.softtabstop=4
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.cursorcolumn = true                     -- highlight the current column
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true                   -- set relative numbered lines
vim.opt.numberwidth = 5                         -- set number column width to 2 {default 4}
vim.opt.redrawtime=10000			            -- big file syntax disable
vim.opt.maxmempattern=2000000			        -- max mem

vim.opt.signcolumn = "yes"                      -- always show the sign column otherwise it would shift the text each time
vim.opt.wrap = true                             -- display lines as one long line
vim.opt.linebreak = true                        -- companion to wrap don't split words
vim.opt.scrolloff = 8                           -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8                       -- minimal number of screen columns either side of cursor if wrap is `false`
vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
vim.opt.whichwrap = "bs<>[]hl"                  -- which "horizontal" keys are allowed to travel to prev/next line
-- Use Neovim's built-in treesitter foldexpr instead of the old vimscript foldexpr.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"

-- vim.opt.shortmess = "ilmnrx"                 -- flags to shorten vim messages, see :help 'shortmess'
vim.opt.shortmess:append "c"                           -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append "-"                           -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" })        -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")  -- separate vim plugins from neovim in case vim still in use
vim.opt.termguicolors = true                    -- enable 24-bit RGB color in the TUI

vim.filetype.add({
    filename = {
        ["go.mod"] = "gomod",
    },
    extension = {
        go = "go",
        txt = "text",
        jsonnet = "jsonnet",
        ts = "typescript",
        tsx = "typescript",
        js = "javascript",
        jsx = "javascript",
        yaml = "yaml",
        yml = "yaml",
        wxml = "html",
        vue = "html",
        wxs = "css",
        css = "css",
        less = "css",
    },
})

local indent_group = vim.api.nvim_create_augroup("dotfiles_indent", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = indent_group,
    pattern = { "html", "json", "xml" },
    callback = function(args)
        vim.bo[args.buf].expandtab = true
        vim.bo[args.buf].smarttab = true
        vim.bo[args.buf].shiftwidth = 4
        vim.bo[args.buf].softtabstop = 4
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = indent_group,
    pattern = { "css", "javascript", "typescript", "yaml" },
    callback = function(args)
        vim.bo[args.buf].expandtab = true
        vim.bo[args.buf].smarttab = true
        vim.bo[args.buf].shiftwidth = 2
        vim.bo[args.buf].softtabstop = 2
    end,
})
