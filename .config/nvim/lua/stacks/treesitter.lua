local M = {}

function M.setup()
    local treesitter_configs_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
    if not treesitter_configs_ok then
        return
    end

    treesitter_configs.setup({
        ensure_installed = { "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx", "css", "rust", "yaml", "markdown", "markdown_inline", "go" },
        ignore_install = { "phpdoc" },
        highlight = {
            enable = true,
            disable = { "css", "markdown", "markdown_inline" },
        },
        autopairs = {
            enable = true,
        },
        indent = { enable = true, disable = { "python", "css" } },
    })
end

return M
