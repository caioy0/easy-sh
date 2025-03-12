local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/lua/snippets/"
vim.cmd("au BufRead,BufNewFile *.templ setfiletype templ")
local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = { "*.templ" },
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_option(buf, "filetype", "templ")
	end,
})

vim.opt.rtp:prepend(lazypath)