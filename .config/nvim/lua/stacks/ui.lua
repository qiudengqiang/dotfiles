local M = {}

function M.setup()
    local bqf_ok, bqf = pcall(require, "bqf")
    if bqf_ok then
        bqf.setup({})
    end

    local trouble_ok, trouble = pcall(require, "trouble")
    if trouble_ok then
        trouble.setup({
            position = "right",
            width = 50,
            height = 10,
            padding = false,
            mode = "document_diagnostics",
            group = true,
            cycle_results = false,
            auto_jump = {},
        })
    end

    local kanagawa_ok, kanagawa = pcall(require, "kanagawa")
    if kanagawa_ok then
        kanagawa.setup({
            commentStyle = { italic = false },
            keywordStyle = { italic = false },
            functionStyle = { italic = false },
        })
        vim.cmd("colorscheme kanagawa")
    end

    local blankline_ok, blankline = pcall(require, "ibl")
    if blankline_ok then
        blankline.setup({
            indent = {
                char = "│",
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
            },
        })
    end

    local todo_comments_ok, todo_comments = pcall(require, "todo-comments")
    if todo_comments_ok then
        todo_comments.setup()
    end

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

    local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree")
    if nvim_tree_ok then
        local function my_on_attach(bufnr)
            local api = require("nvim-tree.api")

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
            vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
            vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
            vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
            vim.keymap.set("n", "c", api.fs.create, opts("Create"))
            vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
            vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
        end

        nvim_tree.setup({
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
                exclude = { ".conf" },
            },
            filesystem_watchers = {
                enable = true,
                debounce_delay = 50,
                ignore_dirs = {},
            },
        })
    end

    local bufferline_ok, bufferline = pcall(require, "bufferline")
    if bufferline_ok then
        bufferline.setup({
            options = {
                numbers = "none",
                indicator = { style = "none" },
                max_name_length = 30,
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
                fill = { fg = "#9e9e9e", bg = "#262626" },
                background = { fg = "#262626", bg = "#444444" },
                buffer_selected = { fg = "#080808", bg = "#AFFA02", italic = false },
                buffer_visible = { fg = "#87FBAF", bg = "#262626" },
                indicator_selected = { fg = "#080808", bg = "#AFFA02" },
                indicator_visible = { fg = "#9e9e9e", bg = "#262626" },
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
                    bg = { attribute = "bg", highlight = "TabLineSel" },
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

    local lualine_ok, lualine = pcall(require, "lualine")
    if lualine_ok then
        local filetype = { "filetype", icons_enabled = false, icon = nil }
        local branch = { "branch", icons_enabled = true, icon = "" }
        local location = { "location" }
        local filename = { "filename", path = 3, shorting_target = 40 }
        local fileformat = { "fileformat", icons_enabled = false }
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

    local telescope_ok, telescope = pcall(require, "telescope")
    if telescope_ok then
        local actions = require("telescope.actions")
        telescope.setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                path_display = { "smart" },
                mappings = {
                    i = {
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
                        ["<C-_>"] = actions.which_key,
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
            pickers = {},
            extensions = {},
        })
    end

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

    local which_key_ok, which_key = pcall(require, "which-key")
    if which_key_ok then
        which_key.setup({
            delay = 300,
            plugins = {
                marks = true,
                registers = true,
                spelling = {
                    enabled = true,
                    suggestions = 20,
                },
            },
            show_help = true,
        })
        which_key.add({
            { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },
            { "<leader>f", group = "file/find" },
            { "<leader>g", group = "git" },
            { "<leader>c", group = "code/config" },
            { "<leader>d", group = "debug" },
            { "<leader>t", group = "test" },
        })
    end
end

return M
