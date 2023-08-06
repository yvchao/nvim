local config = {
	snippet_engine = "vsnip",
	languages = {
		python = {
			template = { annotation_convention = "numpydoc" },
		},
	},
}

require("neogen").setup(config)
