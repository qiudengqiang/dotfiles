local M = {}

function M.setup()
    local mason_ok, mason = pcall(require, "mason")
    if mason_ok then
        mason.setup({
            ui = {
                border = "none",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
                log_level = vim.log.levels.INFO,
                max_concurrent_installers = 4,
            },
        })
    end

    local dap_ok, dap = pcall(require, "dap")
    if not dap_ok then
        return
    end

    local dapui = require("dapui")
    local dapgo = require("dap-go")

    dap.listeners.before.attach.dapui_config = function()
        vim.opt.mouse = "a"
        dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
        vim.opt.mouse = "a"
        dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
        vim.opt.mouse = ""
        dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
        vim.opt.mouse = ""
        dapui.close()
    end
    dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

    dapui.setup({
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.33 },
                    { id = "breakpoints", size = 0.17 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 0.25 },
                },
                position = "left",
                size = 40,
            },
            {
                elements = {
                    { id = "repl", size = 0.45 },
                    { id = "console", size = 0.55 },
                },
                size = 20,
                position = "bottom",
            },
        },
        floating = {
            max_height = 0.9,
            max_width = 0.5,
            border = vim.g.border_chars,
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
    })

    require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, _, _, _, options)
            if options.virt_text_pos == "inline" then
                return " = " .. variable.value:gsub("%s+", " ")
            end
            return variable.name .. " = " .. variable.value:gsub("%s+", " ")
        end,
        virt_text_pos = "inline",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = 80,
    })

    dapgo.setup({
        dap_configurations = {
            {
                type = "go",
                name = "Attach remote",
                mode = "remote",
                request = "attach",
            },
        },
    })
end

return M
