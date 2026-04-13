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

-- The goal of nvim-bqf is to make Neovim's quickfix window better.
local bqf_ok, bqf = pcall(require, "bqf")
if bqf_ok then
    bqf.setup({})
end

-- folke/trouble.nvim - trouble
local trouble_ok, trouble = pcall(require, "trouble")
if trouble_ok then
    trouble.setup({
        position = "right", -- 侧边栏显示在右侧
        width = 50,         -- 侧边栏宽度
        height = 10,        -- 侧边栏高度
        padding = false,    -- 不使用内边距
        mode = "document_diagnostics", -- 默认只显示当前文档诊断
        group = true, -- 分组相似诊断
        cycle_results = false, -- 不循环结果
        auto_jump = {}, -- 自动跳转到特定诊断类型
    })
end

-- rebelot/kanagawa.nvim
local kanagawa_ok, kanagawa = pcall(require, "kanagawa")
if kanagawa_ok then
    kanagawa.setup({
        commentStyle = { italic = false },   -- 取消注释的斜体
        keywordStyle = { italic = false },   -- 取消关键字的斜体
        functionStyle = { italic = false },  -- 取消函数名的斜体
    })
    vim.cmd("colorscheme kanagawa")
end

-- indent-blankline.nvim
local blankline_ok, blankline = pcall(require, "ibl")
if blankline_ok then
    blankline.setup({
        indent = {
            char = "│"
        },
        scope = {
            enabled = true,
            show_start = false,
            show_end = false,
        },
    })
end

-- folke/todo-comments.nvim - todo-comments
local todo_comments_ok, todo_comments = pcall(require, "todo-comments")
if todo_comments_ok then
    todo_comments.setup()
end

-- folke/flash.nvim - flash
local flash_ok, flash = pcall(require, "flash")
if flash_ok then
    flash.setup({
        labels = "abcdefghijklmnopqrstuvwxyz",
        search = {
            mode = "fuzzy",
        },
        jump = {
            autojump = true,
        },
    })
end

-- neotest.nvim
local neotest_ok, neotest = pcall(require, "neotest")
if neotest_ok then
    neotest.setup({
        overseer = {
            enabled = true,
            -- When this is true (the default), it will replace all neotest.run.* commands
            force_default = false,
        },
        adapters = {
            require("neotest-go")({
                -- You can provide optional configuration here, like:
                experimental = {
                    test_table = true,
                },
                args = { "-count=1", "-timeout=60s" },
            }),
        },
        output = {
            open_on_run = "short",
            -- max_height = 15,
            -- max_width = 80,
        },
        output_panel = {
            enabled = true,
            open = "botright split | resize 15",
        },
        quickfix = {
            open = function()
                vim.cmd("copen") -- 自动打开 quickfix 窗口
            end,
            -- 只显示失败的测试
            -- filter = function(positions)
            --     return vim.tbl_filter(function(pos)
            --         return pos.status == "failed"
            --     end, positions)
            -- end,
        },
    })
end

-- nvim-tree
local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree")
if nvim_tree_ok then
    local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "C", api.tree.change_root_to_node,   opts("CD"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "l", api.node.open.edit,             opts("Open"))
        vim.keymap.set("n", "y", api.fs.copy.node,               opts("Copy"))
        vim.keymap.set("n", "c", api.fs.create,                  opts("Create"))
        vim.keymap.set("n", "v", api.node.open.vertical,         opts("Open: Vertical Split"))
        vim.keymap.set("n", "s", api.node.open.horizontal,       opts("Open: Horizontal Split"))
    end

    nvim_tree.setup {
        on_attach = my_on_attach,
        update_focused_file = {
            enable = true,
            update_cwd = false,
        },
        renderer = {
            icons = {
                show = {
                    file = false,
                    folder = false,
                    -- folder_arrow = false,
                },
                glyphs = {
                    default = "",
                    symlink = "",
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "",
                        staged = "",
                        unmerged = "",
                        renamed = "",
                        untracked = "",
                        deleted = "",
                        ignored = "",
                    },
                },
            },
        },
        diagnostics = {
            enable = false,
            show_on_dirs = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        filters = {
            dotfiles = true,
            git_clean = false,
            no_buffer = false,
            custom = {},
            exclude = {".conf"},
        },
        filesystem_watchers = {
            enable = true,
            debounce_delay = 50,
            ignore_dirs = {},
        },
    }
end

-- bufferline.nvim
local bufferline_ok, bufferline = pcall(require, "bufferline")
if bufferline_ok then
    bufferline.setup({
        options = {
            numbers = "none",
            indicator = { style = "none" },
            max_name_length = 30, -- prefix used when a buffer is de-duplicated
            max_prefix_length = 30,
            tab_size = 0,
            diagnostics = false,
            diagnostics_update_in_insert = false,
            show_buffer_icons = false,
            show_buffer_close_icons = false,
            show_close_icon = false,
            show_tab_indicators = false,
            show_duplicate_prefix = false,
            persist_buffer_sort = false,
            separator_style = {},
            enforce_regular_tabs = false,
            always_show_bufferline = true,
        },
        highlights = {
            fill = {
                fg = "#9e9e9e",
                bg = "#262626",
            },
            background = {
                fg = "#262626",
                bg = "#444444",
            },
            buffer_selected = {
                fg = "#080808",
                bg = "#AFFA02",
                italic = false,
            },
            buffer_visible = {
                fg = "#87FBAF",
                bg = "#262626",
            },
            indicator_selected = {
                fg = "#080808",
                bg = "#AFFA02",
            },
            indicator_visible = {
                fg = "#9e9e9e",
                bg = "#262626",
            },
            close_button = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            close_button_visible = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            close_button_selected = {
                fg = { attribute = "fg", highlight = "TabLineSel" },
                bg = { attribute = "bg", highlight = "TabLineSel" }
            },
            tab_selected = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "Normal" },
            },
            tab = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            tab_close = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            duplicate_selected = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            duplicate_visible = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            duplicate = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            modified = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            modified_selected = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "Normal" },
            },
            modified_visible = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
        },

    })
end

-- nvim-lualine/lualine.nvim
local lualine_ok, lualine = pcall(require, "lualine")
if lualine_ok then
    local filetype = {
        "filetype",
        icons_enabled = false,
        icon = nil,
    }

    local branch = {
        "branch",
        icons_enabled = true,
        icon = "",
    }

    local location = {
        "location",
    }

    local filename = {
        "filename",
        path = 3,
        shorting_target = 40,
    }

    local fileformat = {
        "fileformat",
        icons_enabled = false,
    }

    local mode = {
        "mode",
        fmt = function(str)
            return str:sub(1, 1)
        end,
    }

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = "powerline",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { mode },
            lualine_b = { branch },
            lualine_c = { filename },
            lualine_x = { "encoding", fileformat, filetype },
            lualine_y = { location },
            lualine_z = { "progress" },
        },
        inactive_sections = {
            lualine_a = { filename },
            lualine_b = {},
            lualine_c = {},
            lualine_x = { location },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {},
    })
end

-- nvimdev/lspsaga.nvim - lspsaga
local lspsaga_ok, lspsaga = pcall(require, "lspsaga")
if lspsaga_ok then
    lspsaga.setup({
        lightbulb = {
            enable = false,
        },
        -- symbol_in_winbar = {
        --     enable = true,
        --     separator = "  ",
        --     hide_keyword = false,
        -- },
    })
end

-- L3MON4D3/LuaSnip - luasnip
local luasnip_ok, luasnip = pcall(require, "luasnip")
if luasnip_ok then
    require("luasnip/loaders/from_vscode").lazy_load()

    -- local check_backspace = function()
    --   local col = vim.fn.col "." - 1
    --   return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
    -- end
end

-- zbirenbaum/copilot.lua - copilot
-- If lazy failed to install this plugin (e.g. weak network), do not trigger lazy loader errors.
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


-- hrsh7th/nvim-cmp - cmp
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
    -- find more here: https://www.nerdfonts.com/cheat-sheet
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
                luasnip.lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        mapping = {
            ["<c-p>"] = cmp.mapping.select_prev_item(),
            ["<c-n>"] = cmp.mapping.select_next_item(),
            ["<c-b>"] = cmp.mapping.scroll_docs(-4),
            ["<c-f>"] = cmp.mapping.scroll_docs(4),
            ["<c-l>"] = cmp.mapping.complete(),
            ["<c-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ["<c-e>"] = cmp.mapping.abort(),
            -- Set `select` to `false` to only confirm explicitly selected items.
            -- Accept currently selected item. If none selected, `select` first item.
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                -- Kind icons
                vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                -- vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
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


-- hrsh7th/cmp-nvim-lsp -- cmp-nvim-lsp
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")


-- neovim/nvim-lspconfig -- lspconfig
local has_new_lsp_api = (vim.lsp ~= nil and vim.lsp.config ~= nil and type(vim.lsp.enable) == "function")
local lspconfig_ok, lspconfig = false, nil
if not has_new_lsp_api then
    lspconfig_ok, lspconfig = pcall(require, "lspconfig")
end

if has_new_lsp_api or lspconfig_ok then
    -- Compatibility shim for plugins still calling deprecated API on nvim 0.11+.
    if has_new_lsp_api and vim.lsp.buf_get_clients then
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

    local format = require("format").new(lsp_supports_method)
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
        end, function(results, ctx)
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

    -- Global fallback mappings so keys are always available.
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


    for _, server in pairs(lspconfig_ensure_installed) do
        local server_opts = vim.deepcopy(opts)

        local require_ok, conf_opts = pcall(require, "langs." .. server)
        if require_ok then
            server_opts = vim.tbl_deep_extend("force", server_opts, conf_opts)
        end

        if has_new_lsp_api then
            vim.lsp.config(server, server_opts)
            vim.lsp.enable(server)
        elseif lspconfig and lspconfig[server] then
            lspconfig[server].setup(server_opts)
        end
    end

    -- handlers.setup (modernized)
    vim.diagnostic.config({
        virtual_text = false,  -- 不显示内联错误
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN]  = "",
                [vim.diagnostic.severity.HINT]  = "",
                [vim.diagnostic.severity.INFO]  = "",
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

-- nvim-treesitter/nvim-treesitter - nvim_treesitter_configs
local treesitter_configs_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if treesitter_configs_ok then
    treesitter_configs.setup({
        ensure_installed = { "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx", "css", "rust", "yaml", "markdown", "markdown_inline", "go" }, -- one of "all" or a list of languages
        ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = { "css", "markdown", "markdown_inline" }, -- list of language that will be disabled
        },
        autopairs = {
            enable = true,
        },
        indent = { enable = true, disable = { "python", "css" } },
    })
end

-- telescope
-- nvim-telescope/telescope.nvim - telescope
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
    local actions = require "telescope.actions"
    telescope.setup({
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = { "smart" },

            mappings = {
                i = {
                    -- ["<C-n>"] = actions.cycle_history_next,
                    -- ["<C-p>"] = actions.cycle_history_prev,

                    ["<CR>"] = actions.select_default,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,

                    ["<C-c>"] = actions.close,

                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,

                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,

                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,

                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,

                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-l>"] = actions.complete_tag,
                    ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                },

                n = {
                    ["<esc>"] = actions.close,
                    ["<CR>"] = actions.select_default,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,

                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                    ["<c-n>"] = actions.move_selection_next,
                    ["<c-p>"] = actions.move_selection_previous,
                    ["H"] = actions.move_to_top,
                    ["M"] = actions.move_to_middle,
                    ["L"] = actions.move_to_bottom,

                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,
                    ["gg"] = actions.move_to_top,
                    ["G"] = actions.move_to_bottom,

                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,

                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,

                    ["?"] = actions.which_key,
                },
            },
        },
        pickers = {
        },
        extensions = {
        },
    })
end

-- windwp/nvim-autopairs - nvim-autopairs
local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
if autopairs_ok then
    autopairs.setup {
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
            offset = 0, -- Offset from pattern match
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            highlight = "PmenuSel",
            highlight_grey = "LineNr",
        },
    }

    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if cmp_status_ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
    end
end

-- ahmedkhalf/project.nvim - project_nvim
local project_nvim_ok, project_nvim = pcall(require, "project_nvim")
if project_nvim_ok then
    project_nvim.setup({
        active = true,
        on_config_done = nil,
        manual_mode = false,
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "package.json", "Makefile" },
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "win",
        exclude_dirs = { "~/.cargo/*" },
        datapath = vim.fn.stdpath("data"),
    })

    if telescope_ok then
        telescope.load_extension("projects")
    end

end

-- folke/which-key.nvim -- which-key
local which_key_ok, which_key = pcall(require, "which-key")
if which_key_ok then
    which_key.setup({
        delay = 300,  -- 延迟显示
        plugins = {
            marks = true, -- shows a list of your marks on " in NORMAL or ' in VISUAL mode
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            spelling = {
                enabled = true, -- enabling this will show WhichKey when pressing z= to spell check
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
        },
        show_help = true, -- 显示帮助信息
    })
    which_key.add({
        { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code/config" },
        { "<leader>d", group = "debug" },
        -- { "<leader>a", group = "avante" },
        { "<leader>t", group = "test" },
    })
end

--  williamboman/mason.nvim -- mason
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
    mason.setup({
        ui = {
            border = "none",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            },
            log_level = vim.log.levels.INFO,
            max_concurrent_installers = 4,
        },
    })

    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if mason_lspconfig_ok then
        mason_lspconfig.setup({
            ensure_installed = mason_lsp_servers,
            automatic_installation = true,
        })
    end
end


-- debug, test
-- mfussenegger/nvim-dap -- dap
local dap_ok, dap = pcall(require, "dap")
if dap_ok then
    -- dap {{{
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
                size = 40
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
            max_width = 0.5, -- Floats will be treated as percentage of your screen.
            border = vim.g.border_chars, -- Border style. Can be "single", "double" or "rounded"
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
    })


    -- https://github.com/theHamsta/nvim-dap-virtual-text
    require("nvim-dap-virtual-text").setup({
        enabled = true,                        -- enable this plugin (the default)
        enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = true,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true,               -- show stop reason when stopped for exceptions
        commented = false,                     -- prefix virtual text with comment string
        only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
        all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
        clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
        display_callback = function(variable, buf, stackframe, node, options)
            -- by default, strip out new line characters
            if options.virt_text_pos == "inline" then
                return " = " .. variable.value:gsub("%s+", " ")
            else
                return variable.name .. " = " .. variable.value:gsub("%s+", " ")
            end
        end,
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use "eol" to set to end of line
        virt_text_pos = vim.fn.has "nvim-0.10" == 1 and "inline" or "eol",

        -- experimental features:
        all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = 80                 -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    })

    -- go
    dap.adapters.go = {
        type = "server",
        port = "${port}",
        executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
        },
    }


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
