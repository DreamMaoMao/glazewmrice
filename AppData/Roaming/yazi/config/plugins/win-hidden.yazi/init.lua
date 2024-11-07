local selected_or_hovered = ya.sync(function(state)
	state.file = {}

	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
		state.file[tostring(u)] = #paths + 1
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
		state.file[tostring(tab.current.hovered.url)] = 1
	end
	state.filenum = #paths
	return paths
end)

local is_show_hidden = ya.sync(function()
	return cx.active.conf.show_hidden
end)

local set_attr = ya.sync(function(state,action,auto_hide)
	state.action = action
	state.auto_hide = auto_hide
end)

local function notify(str)
	ya.notify({
		title = "win hidden",
		content = str,
		timeout = 3,
		level = "info",
	})
end

return {

 	setup = function(state,config)

		local color = config.color and config.color or "#88c2f4"

    	local function header_hidden(self)
			local hidden = cx.active.conf.show_hidden
			return hidden and ui.Line { ui.Span(" [H]"):fg(color):bold() }
		end

		local function linemode_hidden(self)
			local f = self._file
			local h = cx.active.current.hovered

			if state.file and f.cha.is_hidden and state.action == 'hide' and state.file[tostring(f.url)] then
				state.file[tostring(f.url)] = nil
				state.filenum = state.filenum - 1
				if state.filenum == 0 and state.auto_hide then
					state.file = nil
					notify("hide flush complete")
					ya.manager_emit("hidden", { "hide" })
				elseif state.filenum == 0 and not state.auto_hide then
					state.file = nil
					notify("hide flush complete")
				end
			elseif state.file and not f.cha.is_hidden and state.action ~= 'hide' and state.file[tostring(f.url)] then
				state.file[tostring(f.url)] = nil
				state.filenum = state.filenum - 1
				if state.filenum == 0 and state.auto_hide then
					state.file = nil
					notify("unhide flush complete")
					ya.manager_emit("hidden", { "hide" })
				elseif state.filenum == 0 and not state.auto_hide then
					state.file = nil
					notify("unhide flush complete")
				end
			end
			
			if h and h.url == f.url then
				return f.cha.is_hidden and ui.Span(" H "):bold() or {}
			else
				return f.cha.is_hidden and ui.Span(" H "):fg(color):bold() or {}
			end
		end

		Header:children_add(header_hidden,8000,Header.LEFT)
		Linemode:children_add(linemode_hidden,7000)
	end,

	entry = function(_, args)
		local child,files,cmd_args
		local output, err
		local urls = selected_or_hovered()
		if args == nil then
			return ya.notify({ title = "file hidden", content = "miss args", level = "warn", timeout = 5 })
		end
		files = table.concat(urls, [[","]])
		cmd_args = args[1] == 'hide' and string.format([[Resolve-Path "%s" | ForEach-Object { attrib +h $_.Path }]], files) or string.format([[Resolve-Path "%s" | ForEach-Object { attrib -h $_.Path }]], files)
		child, _ = Command("powershell"):args({"-Command",cmd_args}):spawn()	
		

		if is_show_hidden() then
			set_attr(args[1],false)
			output, _ = child:wait_with_output()
		else
			set_attr(args[1],true)
			ya.manager_emit("hidden", { "show" })
			output, _ = child:wait_with_output()
		end

		if output and output.status.success then
			notify("Succesfully change attr to "..args[1])
		else
			notify("Could not change attr")
		end
	end

}

