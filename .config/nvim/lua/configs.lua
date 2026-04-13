local lspconfig_ensure_installed = {
    "gopls",
    "bashls",
    "yamlls",
    "lua_ls",
}

local mason_lsp_servers = {}
local system_managed_lsp_servers = {
    gopls = true,
}

for _, server in ipairs(lspconfig_ensure_installed) do
    if not system_managed_lsp_servers[server] then
        table.insert(mason_lsp_servers, server)
    end
end

require("stacks.ui").setup()
require("stacks.editor").setup()
require("stacks.lsp").setup(lspconfig_ensure_installed)
require("stacks.treesitter").setup()
require("stacks.tools").setup(mason_lsp_servers)
