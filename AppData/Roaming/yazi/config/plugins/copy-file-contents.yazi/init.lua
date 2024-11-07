local get_hovered_file_path = ya.sync(function()
	return cx.active.current.hovered.url
end)

local function notify(str)
	ya.notify({
		title = "Copy-file-contents",
		content = str,
		timeout = 3,
		level = "info",
	})
end


local function entry()


	local cmd_args = "get-content " .. tostring(get_hovered_file_path()) .. " | " .. "clip"

	-- Spawn the command to copy the file contents to clipboard
	local output, err = Command("pwsh"):args({ "-Command", cmd_args }):spawn():wait()

	if not output then
		return ya.err("Cannot spawn clipboard command, error code " .. tostring(err))
	end

	notify("Copied file contents to clipboard")
end

return {

	entry = entry,
}
