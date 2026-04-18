local lspconfig_ensure_installed = {
    "gopls",
    "clangd",
    "bashls",
    "yamlls",
    "lua_ls",
}

require("stacks.ui").setup()
require("stacks.editor").setup()
require("stacks.git").setup()
require("stacks.lsp").setup(lspconfig_ensure_installed)
require("stacks.treesitter").setup()
require("stacks.tools").setup()
