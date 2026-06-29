local M = {}

-- @class ContextNapConfig
local defaults = {
    disable_diagnostics = true,
    hide_line_numbers = false,
}

M.options = {}

function M.setup(user_opts)
    M.options = vim.tbl_deep_extend("force", defaults, user_opts or {})
end

return M
