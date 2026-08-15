vim.api.nvim_create_user_command("W", function(opts)
	vim.cmd("w" .. (opts.bang and "!" or "") .. " " .. opts.args)
end, { bang = true, nargs = "*" })

-- :Q e :Q! -> :q e :q!
vim.api.nvim_create_user_command("Q", function(opts)
	vim.cmd("q" .. (opts.bang and "!" or ""))
end, { bang = true })

-- :Wq, :WQ e varianti con ! -> :wq e :wq!
local function wq(opts)
	vim.cmd("wq" .. (opts.bang and "!" or ""))
end
vim.api.nvim_create_user_command("Wq", wq, { bang = true })
vim.api.nvim_create_user_command("WQ", wq, { bang = true })

-- :Wa e :Wa! -> :wa e :wa!
vim.api.nvim_create_user_command("Wa", function(opts)
	vim.cmd("wa" .. (opts.bang and "!" or ""))
end, { bang = true })

-- :Qa, :QA e varianti con ! -> :qa e :qa!
local function qa(opts)
	vim.cmd("qa" .. (opts.bang and "!" or ""))
end
vim.api.nvim_create_user_command("Qa", qa, { bang = true })
vim.api.nvim_create_user_command("QA", qa, { bang = true })

local function create_default_launch_json()
	local dir = vim.fn.getcwd() .. "/.vscode"
	local path_launch = dir .. "/launch.json"
	local path_tasks = dir .. "/tasks.json"

	if vim.fn.filereadable(path_launch) == 1 then
		vim.cmd("edit " .. vim.fn.fnameescape(path_launch))
		vim.notify("launch.json esiste già, apro quello esistente", vim.log.levels.WARN)
		return
	end

	vim.fn.mkdir(dir, "p")

	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local template_launch = string.format(
		[[
		{
						"version": "0.2.0",
						"configurations": [
						{
										"name": "Debug %s",
										"type": "codelldb",
										"request": "launch",
										"preLaunchTask": "build",
										"program": "${workspaceFolder}/build/debug/%s",
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

	local template_tasks = string.format(
		[[
	{
					"version": "2.0.0",
					"tasks": [
					{
									"type": "shell",
									"label": "build",
									"command": "cmake --preset=debug && cmake --build --preset=debug"
					},
					{
									"type": "shell",
									"label": "run",
									"command": "cmake --preset=debug && cmake --build --preset=debug && ${workspaceFolder}/build/debug/%s"
					}
					]
	}
	]],
		project_name
	)

	local file_launch = io.open(path_launch, "w")
	local file_tasks = io.open(path_tasks, "w")
	if not file_launch then
		vim.notify("Unable to create " .. path_launch, vim.log.levels.ERROR)
		return
	end
	if not file_tasks then
		vim.notify("Unable to create " .. path_tasks, vim.log.levels.ERROR)
		return
	end
	file_launch:write(template_launch)
	file_launch:close()
	file_tasks:write(template_tasks)
	file_tasks:close()

	vim.cmd("edit " .. vim.fn.fnameescape(path_launch))
	vim.notify("Created .vscode/launch.json", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("DapCreateLaunchJson", create_default_launch_json, {})
