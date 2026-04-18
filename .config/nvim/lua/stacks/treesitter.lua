local M = {}

local parser_install_dir = vim.fn.stdpath("data") .. "/site/parser"

local disabled_languages = {
    css = true,
}

local filetype_language_map = {
    ["yaml.docker-compose"] = "yaml",
    ["yaml.gitlab"] = "yaml",
    ["yaml.helm-values"] = "yaml",
}

local function get_language(bufnr)
    local filetype = vim.bo[bufnr].filetype
    if filetype_language_map[filetype] then
        return filetype_language_map[filetype]
    end

    return vim.treesitter.language.get_lang(filetype) or filetype
end

local function start_treesitter(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    if vim.bo[bufnr].buftype ~= "" then
        return
    end

    local lang = get_language(bufnr)
    if not lang then
        return
    end

    if disabled_languages[lang] then
        pcall(vim.treesitter.stop, bufnr)
        return
    end

    if not pcall(vim.treesitter.start, bufnr, lang) then
        return
    end
end

function M.setup()
    vim.opt.runtimepath:prepend(parser_install_dir)

    local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
    if configs_ok then
        configs.setup({
            parser_install_dir = parser_install_dir,
        })
    end

    local group = vim.api.nvim_create_augroup("dotfiles_treesitter_native", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
        group = group,
        callback = function(args)
            start_treesitter(args.buf)
        end,
    })

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        start_treesitter(bufnr)
    end
end

return M
