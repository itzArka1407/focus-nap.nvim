local M = {}
local config = require("focus-nap.config")

local is_focused = false -- If the local mode is turned on
local cache = {
    diagnostics_enabled = true,
    wo_number = true,
    wo_relativenumber = true,
}

-- Toggling the states
function M.toggle()
    local current_win = vim.api.nvim_get_current_win()

    if not is_focused then
        is_focused = true -- Enter focus mode

        -- Stop all the diagnostics
        if config.options.disable_diagnostics then
            cache.diagnostics_enabled = vim.diagnostic.is_enabled()
            vim.diagnostic.enable(false)
        end

        -- Hide the line numbers, hide the relative line numbers
        if config.options.hide_line_numbers then
            cache.wo_number = vim.wo[current_win].number
            cache.wo_relativenumber = vim.wo[current_win].relativenumber

            vim.wo[current_win].number = false
            vim.wo[current_win].relativenumber = false
        end

        print("[ContextNap]: Focus Mode activated")
    else
        -- Existing focus mode, read from cache and apply the rules
        is_focused = false

        if config.options.disable_diagnostics then
            vim.diagnostic.enable(cache.diagnostics_enabled)
        end

        if config.options.hide_line_numbers then
            vim.wo[current_win].number = cache.wo_number
            vim.wo[current_win].relativenumber = cache.wo_relativenumber
        end

        print("[ContextNap]: Focus Mode deactivated")
    end
end

-- Pass the args provided by the user to the initializer
function M.setup(opts)
    config.setup(opts)
end

return M
