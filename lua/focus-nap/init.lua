-- lua/focus-nap/init.lua
local M = {}
local config = require("focus-nap.config")

-- Track diagnostic state globally for the plugin session
local is_diag_enabled = vim.diagnostic.is_enabled()

-- Toggle the Diagnostics globally
function M.toggle_diagnostics()
    if is_diag_enabled then
        is_diag_enabled = false
        print("[FocusNap] Diagnostics muted globally.")
    else
        is_diag_enabled = true
        print("[FocusNap] Diagnostics restored globally.")
    end
    vim.diagnostic.enable(is_diag_enabled)
end

-- Toggle line numbers
function M.toggle_numbers()
    local operation_window = vim.api.nvim_get_current_win()
    local is_win_lines_vis = vim.wo[operation_window].number

    if is_win_lines_vis then
        print("[FocusNap] Switching off lines")
    else
        print("[FocusNap] Showing Lines")
    end

    vim.o.number = not is_win_lines_vis
    vim.o.relativenumber = not is_win_lines_vis
    vim.wo[operation_window].number = not is_win_lines_vis
end

-- Open the main menu
function M.open_menu()
    local target_window = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)

    local lines = {
        "[1]. Toggle Diagnostics",
        "[2]. Toggle Line Numbers",
        "[3]. Toggle Signcolumn"
    }

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local screen_width = vim.o.columns
    local screen_height = vim.o.lines

    local win_width = 30
    local win_height = #lines

    -- Centering logic
    local col = math.ceil((screen_width - win_width) / 2)
    local row = math.ceil((screen_height - win_height) / 2) - 1

    local window_ui_opts = {
        relative = "editor",
        row = row,
        col = col,
        width = win_width,
        height = win_height,
        style = "minimal",
        border = "rounded",
    }

    local window = vim.api.nvim_open_win(buf, true, window_ui_opts)

    vim.wo[window].wrap = false
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "focusnapmenu"

    local map_opts = { silent = true, noremap = true, buffer = buf }
    vim.keymap.set("n", "q", "<cmd>close<CR>", map_opts)
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", map_opts)

    vim.keymap.set("n", "<CR>", function()
        local cursor_line = vim.api.nvim_win_get_cursor(window)[1]
        vim.api.nvim_win_close(window, true)

        if cursor_line == 1 then
            -- Notice we don't pass target_window anymore; it's a global toggle now
            M.toggle_diagnostics()
        elseif cursor_line == 2 then
            M.toggle_numbers(target_window)
        elseif cursor_line == 3 then
            print("[FocusNap] SignColumn feature coming soon")
        end
    end, map_opts)

    return buf, window
end

function M.setup(opts)
    config.setup(opts)
end

return M
