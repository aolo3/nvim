local function create_default_launch_json()
	local dir = vim.fn.getcwd() .. "/.vscode"
	local path = dir .. "/launch.json"

	if vim.fn.filereadable(path) == 1 then
		vim.cmd("edit " .. vim.fn.fnameescape(path))
		vim.notify("launch.json esiste già, apro quello esistente", vim.log.levels.WARN)
		return
	end

	vim.fn.mkdir(dir, "p")

	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local template = string.format(
		[[{
	"version": "0.2.0",
	"configurations": [
		{
			"name": "Debug %s",
			"type": "codelldb",
			"request": "launch",
			"preLaunchTask": "build",
			"program": "${workspaceFolder}/%s",
			"cwd": "${workspaceFolder}",
			"args": [],
			"stopOnEntry": false
		}
	]
}
]],
		project_name,
		project_name
	)

	local file = io.open(path, "w")
	if not file then
		vim.notify("Impossibile creare " .. path, vim.log.levels.ERROR)
		return
	end
	file:write(template)
	file:close()

	vim.cmd("edit " .. vim.fn.fnameescape(path))
	vim.notify("Creato .vscode/launch.json — controlla il campo 'program'", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("DapCreateLaunchJson", create_default_launch_json, {})
