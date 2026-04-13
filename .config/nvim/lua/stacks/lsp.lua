local M = {}

function M.setup(servers)
    local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    if vim.lsp.buf_get_clients then
        vim.lsp.buf_get_clients = function(opts)
            if type(opts) == "number" then
                opts = { bufnr = opts }
            end
            return vim.lsp.get_clients(opts or {})
        end
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    if cmp_nvim_lsp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    local function lsp_supports_method(bufnr, method)
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if client.name ~= "copilot" and type(client.supports_method) == "function" and client:supports_method(method, { bufnr = bufnr }) then
                return true
            end
        end
        return false
    end

    local format = require("stacks.format").new(lsp_supports_method)
    local format_buffer = format.format_buffer

    local function setup_document_highlight(client, bufnr)
        if not (type(client.supports_method) == "function" and client:supports_method("textDocument/documentHighlight", { bufnr = bufnr })) then
            return
        end

        local group = vim.api.nvim_create_augroup("dotfiles_lsp_document_highlight_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    local function hover_documentation()
        local bufnr = vim.api.nvim_get_current_buf()
        local util = require("vim.lsp.util")

        vim.lsp.buf_request_all(bufnr, "textDocument/hover", function(client)
            return util.make_position_params(0, client.offset_encoding)
        end, function(results, _)
            if vim.api.nvim_get_current_buf() ~= bufnr then
                return
            end

            local contents = {}
            local has_result = false

            for client_id, resp in pairs(results or {}) do
                local result = resp and resp.result
                if result and result.contents then
                    has_result = true
                    local client = vim.lsp.get_client_by_id(client_id)
                    if client then
                        contents[#contents + 1] = string.format("[%s]", client.name)
                    end
                    vim.list_extend(contents, util.convert_input_to_markdown_lines(result.contents))
                    contents[#contents + 1] = ""
                end
            end

            while #contents > 0 and contents[#contents] == "" do
                table.remove(contents, #contents)
            end

            if not has_result or vim.tbl_isempty(contents) then
                vim.notify("No information available", vim.log.levels.INFO)
                return
            end

            util.open_floating_preview(contents, "plaintext", {
                border = "rounded",
                focus_id = "textDocument/hover",
            })
        end)
    end

    local function lsp_keymaps(bufnr)
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        local function opts(desc)
            return { desc = "lsp: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code Action"))
        vim.keymap.set("n", "<leader>=", function() format_buffer(bufnr) end, opts("Format"))
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to Definition"))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to Implementation"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("References"))
        vim.keymap.set("n", "K", hover_documentation, opts("Hover Documentation"))
    end

    do
        local function gopts(desc)
            return { desc = "lsp: " .. desc, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, gopts("Rename"))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, gopts("Code Action"))
        vim.keymap.set("n", "<leader>=", format_buffer, gopts("Format"))
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, gopts("Go to Definition"))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, gopts("Go to Implementation"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, gopts("References"))
        vim.keymap.set("n", "K", hover_documentation, gopts("Hover Documentation"))
    end

    local on_attach = function(client, bufnr)
        if client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
        end

        if client.name == "lua_ls" then
            client.server_capabilities.documentFormattingProvider = false
        end

        if client.name == "gopls" then
            client.server_capabilities.semanticTokensProvider = nil
        end

        lsp_keymaps(bufnr)
        setup_document_highlight(client, bufnr)
    end

    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    for _, server in pairs(servers) do
        local server_opts = vim.deepcopy(opts)

        local require_ok, conf_opts = pcall(require, "langs." .. server)
        if require_ok then
            server_opts = vim.tbl_deep_extend("force", server_opts, conf_opts)
        end

        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
    end

    vim.diagnostic.config({
        virtual_text = false,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
            },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })
end

return M
