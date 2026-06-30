-- lua/focus-nap/init.lua
local M = {}
local config = require("focus-nap.config")

function M.toggle()
    local current_win = vim.api.nvim_get_current_win()

    -- Check if THIS SPECIFIC window is already focused by querying its metadata
    local is_win_focused = vim.w[current_win].focus_nap_active or false

    if not is_win_focused then
        -- 1. ENTER FOCUS MODE FOR THIS WINDOW
        vim.w[current_win].focus_nap_active = true

        if config.options.disable_diagnostics then
            -- Cache the diagnostic state directly inside the window's metadata
            vim.w[current_win].old_diagnostics_state = vim.diagnostic.is_enabled()
            vim.diagnostic.enable(false)
        end

        if config.options.hide_line_numbers then
            -- Cache the line number states directly inside the window's metadata
            vim.w[current_win].old_number = vim.wo[current_win].number
            vim.w[current_win].old_relativenumber = vim.wo[current_win].relativenumber

            vim.wo[current_win].number = false
            vim.wo[current_win].relativenumber = false
        end

        print("[FocusNap] Window distractions muted.")
    else
        -- 2. EXIT FOCUS MODE FOR THIS WINDOW
        vim.w[current_win].focus_nap_active = false

        if config.options.disable_diagnostics then
            -- Fallback to true if for some reason the metadata metadata is missing
            local old_diag = vim.w[current_win].old_diagnostics_state
            if old_diag ~= nil then
                vim.diagnostic.enable(old_diag)
            else
                vim.diagnostic.enable(true)
            end
        end

        if config.options.hide_line_numbers then
            -- Restore options to this window using its own stored metadata
            if vim.w[current_win].old_number ~= nil then
                vim.wo[current_win].number = vim.w[current_win].old_number
                vim.wo[current_win].relativenumber = vim.w[current_win].old_relativenumber
            end
        end

        print("[FocusNap] Window workspace restored.")
    end
end

function M.setup(opts)
    config.setup(opts)
end

return M
