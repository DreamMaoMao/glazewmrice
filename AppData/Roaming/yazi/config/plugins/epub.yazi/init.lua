local M = {}

function M:peek()
	local cache = ya.file_cache(self)
	if not cache then
		return
	end

	if self:preload() == 1 then
		ya.image_show(cache, self.area)
		ya.preview_widgets(self, {})
	end
end

function M:seek(units)
	local h = cx.active.current.hovered
	if h and h.url == self.file.url then
		local step = ya.clamp(-1, units, 1)
		ya.manager_emit("peek", { math.max(0, cx.active.preview.skip + step), only_if = self.file.url })
	end
end

function M:preload()
	local cache = ya.file_cache(self)
	if not cache or fs.cha(cache) then
		return 1
	end

	local LINUX_BASE_PATH = "/.config/yazi/plugins/epub.yazi/epubtocover"
	local WINDOWS_BASE_PATH = "\\yazi\\config\\plugins\\epub.yazi\\epubtocover_win"
	local MAC_BASE_PATH = "/.config/yazi/plugins/epub.yazi/epubtocover_mac"
	local COMMAND_PATH
	
	local OS = ya.target_os()
	
	if OS == "linux" then
		COMMAND_PATH = os.getenv("HOME") .. LINUX_BASE_PATH
	elseif OS == "windows" then
		COMMAND_PATH = os.getenv("APPDATA") .. WINDOWS_BASE_PATH
	else
		COMMAND_PATH = os.getenv("HOME") .. MAC_BASE_PATH
	end

	local output = Command(COMMAND_PATH)
		:args({ tostring(self.file.url) })
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not output then
		return 0
	elseif not output.status.success then
		local pages = tonumber(output.stderr:match("the last page %((%d+)%)")) or 0
		if self.skip > 0 and pages > 0 then
			ya.manager_emit("peek", { math.max(0, pages - 1), only_if = self.file.url, upper_bound = true })
		end
		return 0
	end

	return fs.write(cache, output.stdout) and 1 or 2
end

return M
