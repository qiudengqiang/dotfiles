local M = {}

function M.setup()
    local neotest_ok, neotest = pcall(require, "neotest")
    if neotest_ok then
        neotest.setup({
            overseer = {
                enabled = true,
                force_default = false,
            },
            adapters = {
                require("neotest-go")({
                    experimental = {
                        test_table = true,
                    },
                    args = { "-count=1", "-timeout=60s" },
                }),
            },
            output = {
                open_on_run = "short",
            },
            output_panel = {
                enabled = true,
                open = "botright split | resize 15",
            },
            quickfix = {
                open = function()
                    vim.cmd("copen")
                end,
            },
        })
    end

    local luasnip_ok, luasnip = pcall(require, "luasnip")
    if luasnip_ok then
        require("luasnip/loaders/from_vscode").lazy_load()
    end

    local copilot_plugin_path = vim.fn.stdpath("data") .. "/lazy/copilot.lua"
    local is_macos = vim.fn.has("macunix") == 1
    if is_macos and vim.uv.fs_stat(copilot_plugin_path) then
        local copilot_ok, copilot = pcall(require, "copilot")
        if copilot_ok then
            local copilot_node = (vim.fn.executable("/opt/homebrew/bin/node") == 1) and "/opt/homebrew/bin/node" or "node"
            copilot.setup({
                copilot_node_command = copilot_node,
                panel = {
                    enabled = false,
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<C-y>",
                        accept_word = false,
                        accept_line = false,
                        next = "<C-j>",
                        prev = "<C-k>",
                        dismiss = "<C-]>",
                    },
                },
                filetypes = {
                    help = false,
                },
            })
        end
    end

    local cmp_ok, cmp = pcall(require, "cmp")
    if cmp_ok then
        local kind_icons = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
        }

        cmp.setup({
            snippet = {
                expand = function(args)
                    if not luasnip_ok then
                        return
                    end
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<c-p>"] = cmp.mapping.select_prev_item(),
                ["<c-n>"] = cmp.mapping.select_next_item(),
                ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                ["<c-f>"] = cmp.mapping.scroll_docs(4),
                ["<c-l>"] = cmp.mapping.complete(),
                ["<c-y>"] = cmp.config.disable,
                ["<c-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snippet]",
                        buffer = "[Buffer]",
                        path = "[Path]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            },
            confirm_opts = {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            },
            window = {
                documentation = {
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                },
            },
            experimental = {
                ghost_text = false,
                native_menu = false,
            },
        })
    end

    local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
    if autopairs_ok then
        autopairs.setup({
            check_ts = true,
            ts_config = {
                lua = { "string", "source" },
                javascript = { "string", "template_string" },
                java = false,
            },
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
            fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'" },
                pattern = string.gsub([[ [%"%"%)%>%]%)%}%,] ]], "%s+", ""),
                offset = 0,
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "PmenuSel",
                highlight_grey = "LineNr",
            },
        })

        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp_status_ok, cmp_instance = pcall(require, "cmp")
        if cmp_status_ok then
            cmp_instance.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
        end
    end
end

return M
