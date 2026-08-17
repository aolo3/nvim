local cpus = #vim.loop.cpu_info()
local nproc = math.max(1, cpus - 1)
return {
	cmd = {
		"clangd",
		"--background-index",
		"-j",
		nproc,
		"--clang-tidy",
	},
}
