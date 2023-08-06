local null_ls = require("null-ls")

local function on_attach(client, bufnr)
	require("plugins.config.lspconfig_cfg").on_attach(client, bufnr)
end

null_ls.setup({
	sources = {
		-- null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.completion.spell,
		-- null_ls.builtins.diagnostics.flake8,
		null_ls.builtins.diagnostics.chktex,
		null_ls.builtins.formatting.latexindent,
	},
	on_attach = on_attach,
})
