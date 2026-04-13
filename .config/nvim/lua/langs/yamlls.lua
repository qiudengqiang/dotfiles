return {
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
	settings = {
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
		yaml = {
			format = {
				enable = true,
			},
		},
	},
}
