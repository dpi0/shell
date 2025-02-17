local function setup()
	ps.sub("cd", function()
		local cwd = cx.active.current.cwd
		if cwd:ends_with("Downloads") then
			ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
		elseif cwd:ends_with("Screenshots") then
			ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
		elseif cwd:ends_with("Backup") then
			ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
		elseif cwd:ends_with("Wallpapers") then
			ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
		else
			ya.manager_emit("sort", { "alphabetical", reverse = false, dir_first = true })
		end
	end)
end

return { setup = setup }
