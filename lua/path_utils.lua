local M = {}

-- Create a function for finding the git root of a project
-- Based on function from NixCats example config
M.find_git_root = function()
	local dot_git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(dot_git_path, ":h")
end

return M
