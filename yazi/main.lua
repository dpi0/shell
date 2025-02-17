-- enable eza tree preview by default
-- require("eza-preview"):setup()

-- enable folder specific rules
require("folder-rules"):setup()

Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	})
end, 500, Status.RIGHT)

Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line({})
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)

local function setup()
	ps.sub("cd", function()
		local cwd = cx.active.current.cwd
		if cwd:ends_with("Downloads") then
			ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
		else
			ya.manager_emit("sort", { "alphabetical", reverse = false, dir_first = true })
		end
	end)
end

-- function Linemode:size_and_mtime()
-- 	local time = math.floor(self._file.cha.modified or 0)
-- 	if time == 0 then
-- 		time = ""
-- 	elseif os.date("%Y", time) == os.date("%Y") then
-- 		time = os.date("%b %d %H:%M", time)
-- 	else
-- 		time = os.date("%b %d  %Y", time)
-- 	end
--
-- 	local size = self._file:size()
-- 	return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "-", time))
-- end

-- local function relative_time(timestamp)
-- 	local now = os.time()
-- 	local diff = now - timestamp
-- 
-- 	if diff < 60 then
-- 		local unit = diff == 1 and "second" or "seconds"
-- 		return string.format("%d %s", diff, unit)
-- 	elseif diff < 3600 then
-- 		local minutes = math.floor(diff / 60)
-- 		local unit = minutes == 1 and "minute" or "minutes"
-- 		return string.format("%d %s", minutes, unit)
-- 	elseif diff < 86400 then
-- 		local hours = math.floor(diff / 3600)
-- 		local unit = hours == 1 and "hour" or "hours"
-- 		return string.format("%d %s", hours, unit)
-- 	elseif diff < 604800 then -- Less than 7 days
-- 		local days = math.floor(diff / 86400)
-- 		local unit = days == 1 and "day" or "days"
-- 		return string.format("%d %s", days, unit)
-- 	elseif diff < 2592000 then -- Less than 30 days (1 month)
-- 		local weeks = math.floor(diff / 604800)
-- 		local unit = weeks == 1 and "week" or "weeks"
-- 		return string.format("%d %s", weeks, unit)
-- 	elseif diff < 31536000 then
-- 		local months = math.floor(diff / 2592000)
-- 		local unit = months == 1 and "month" or "months"
-- 		return string.format("%d %s", months, unit)
-- 	else
-- 		local years = math.floor(diff / 31536000)
-- 		local unit = years == 1 and "year" or "years"
-- 		return string.format("%d %s", years, unit)
-- 	end
-- end

-- function Linemode:size_and_mtime()
-- 	local time = math.floor(self._file.cha.mtime or 0)
-- 	if time == 0 then
-- 		time = ""
-- 	else
-- 		time = relative_time(time)
-- 	end
-- 
-- 	local size = self._file:size()
-- 	return ui.Line(string.format("%s %s", time, size and ya.readable_size(size) or "-"))
-- end

-- ~/.config/yazi/init.lua
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end


return { setup = setup }
