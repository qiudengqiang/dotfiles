local function resolve_root(fname)
	if type(fname) == "number" then
		fname = vim.api.nvim_buf_get_name(fname)
	end
	if type(fname) ~= "string" or fname == "" then
		return vim.uv.cwd()
	end
	return vim.fs.root(fname, {"go.work", "go.mod"}) or vim.fs.dirname(fname)
end

return {
	cmd = {"gopls"},
	filetypes = {"go", "gomod", "gowork", "gotmpl"},
	root_dir = function(bufnr_or_fname, on_dir)
		local root = resolve_root(bufnr_or_fname)
		if type(on_dir) == "function" then
			on_dir(root)
			return
		end
		return root
	end,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}
