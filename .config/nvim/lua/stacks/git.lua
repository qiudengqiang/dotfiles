local M = {}

function M.setup()
    local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
    if gitsigns_ok then
        gitsigns.setup({})
    end
end

local ignored_filetypes = {
    NvimTree = true,
    fugitive = true,
    fugitiveblame = true,
    qf = true,
    trouble = true,
}

local function is_normal_file_window(winid)
    if not vim.api.nvim_win_is_valid(winid) then
        return false
    end

    local bufnr = vim.api.nvim_win_get_buf(winid)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return false
    end

    local bo = vim.bo[bufnr]
    return bo.buftype == "" and not ignored_filetypes[bo.filetype]
end

local function blame_winbar()
    return "%#Special# blame%*"
end

function M.align_fugitive_blame(blame_bufnr)
    local blame_win
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_buf(winid) == blame_bufnr then
            blame_win = winid
            break
        end
    end

    if not blame_win then
        return
    end

    local source_win
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if winid ~= blame_win and is_normal_file_window(winid) and vim.wo[winid].scrollbind then
            source_win = winid
            break
        end
    end

    if not source_win then
        return
    end

    local topline = vim.fn.line("w0", source_win)
    local cursor = vim.api.nvim_win_get_cursor(source_win)
    local source_has_winbar = vim.wo[source_win].winbar ~= ""

    vim.api.nvim_win_call(blame_win, function()
        vim.wo.wrap = false
        vim.wo.scrollbind = true
        if source_has_winbar then
            vim.wo.winbar = blame_winbar()
        end
        vim.fn.winrestview({ topline = topline })
        vim.api.nvim_win_set_cursor(0, { cursor[1], 0 })
        vim.cmd("normal! zt")
        vim.cmd("syncbind")
        vim.cmd("redraw!")
    end)
end

return M
