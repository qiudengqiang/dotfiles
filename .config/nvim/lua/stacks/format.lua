local M = {}

local function external_formatter_command(bufnr)
    local filetype = vim.bo[bufnr].filetype
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local stdin_name = filename ~= "" and filename or ("stdin." .. filetype)

    if filetype == "lua" and vim.fn.executable("stylua") == 1 then
        return { "stylua", "--stdin-filepath", stdin_name, "-" }
    end

    if filetype == "python" and vim.fn.executable("black") == 1 then
        return { "black", "--fast", "--quiet", "-" }
    end

    local prettier_filetypes = {
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
        json = true,
        css = true,
        scss = true,
        less = true,
        html = true,
        markdown = true,
        markdown_inline = true,
        yaml = true,
    }
    if prettier_filetypes[filetype] and vim.fn.executable("prettier") == 1 then
        return {
            "prettier",
            "--stdin-filepath",
            stdin_name,
            "--no-semi",
            "--single-quote",
            "--jsx-single-quote",
        }
    end
end

local function run_external_formatter(bufnr)
    local cmd = external_formatter_command(bufnr)
    if not cmd then
        vim.notify("当前 buffer 没有可用的外部 formatter", vim.log.levels.WARN)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, "\n")
    if vim.bo[bufnr].endofline then
        input = input .. "\n"
    end

    local result = vim.system(cmd, { stdin = input, text = true }):wait()
    if result.code ~= 0 then
        local stderr = (result.stderr or ""):gsub("%s+$", "")
        vim.notify(stderr ~= "" and stderr or ("formatter failed: " .. table.concat(cmd, " ")), vim.log.levels.ERROR)
        return
    end

    local output = result.stdout or ""
    local formatted = vim.split(output, "\n", { plain = true })
    if #formatted > 0 and formatted[#formatted] == "" then
        table.remove(formatted, #formatted)
    end

    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
    vim.fn.winrestview(view)
end

function M.new(lsp_supports_method)
    return {
        format_buffer = function(bufnr)
            bufnr = bufnr or vim.api.nvim_get_current_buf()
            if lsp_supports_method(bufnr, "textDocument/formatting") then
                vim.lsp.buf.format({
                    bufnr = bufnr,
                    async = true,
                })
                return
            end

            run_external_formatter(bufnr)
        end,
    }
end

return M
