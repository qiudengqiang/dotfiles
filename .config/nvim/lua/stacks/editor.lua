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
    end
end

return M
