-- lua/focus-nap/init.lua
local M = {}
local config = require("focus-nap.config")

-- Toggle the Diagnostics globally
function M.toggle_diagnostics()
    local is_diag_enabled = not vim.diagnostic.is_enabled()
    vim.diagnostic.enable(is_diag_enabled)

    return is_diag_enabled
end

-- Toggle line numbers
function M.toggle_lines_number()
    local operation_window = vim.api.nvim_get_current_win()
    local is_win_lines_vis = vim.wo[operation_window].number

    is_win_lines_vis = not is_win_lines_vis
    vim.o.number = is_win_lines_vis
    vim.o.relativenumber = is_win_lines_vis
    vim.wo[operation_window].number = is_win_lines_vis

    return is_win_lines_vis
end

function M.toggle_focus_mode()
    local opt_win = vim.api.nvim_get_current_win()
    local is_win_lines_vis = vim.wo[opt_win].number

    -- Both lines and diagnostics are off(focus mode on) -- so turn off focus mode now
    if not is_win_lines_vis and not is_diag_enabled then
        M.toggle_lines_number()
        M.toggle_diagnostics()
        print("[FocusNap] Focus Mode off")
    else
        if is_win_lines_vis then
            M.toggle_lines_number()
        end
        if is_diag_enabled then
            M.toggle_diagnostics()
        end
        print("[FocusNap] Focus Mode on")
    end
end

-- Open the main menu
function M.open_menu()
    local buf = vim.api.nvim_create_buf(false, true)

    local lines = {
        "[1]. Toggle Focus Mode",
        "[2]. Toggle Diagnostics",
        "[3]. Toggle Line Numbers",
        "[4]. Toggle Signcolumn"
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
            M.toggle_focus_mode()
        elseif cursor_line == 2 then
            local is_diag_enabled = M.toggle_diagnostics()
            if is_diag_enabled then
                print("[FocusNap] Diagnostics turned on globally")
            else
                print("[FocusNap] Diagnostics turned off globally")
            end
        elseif cursor_line == 3 then
            local lines_are_vis = M.toggle_lines_number()

            if lines_are_vis then
                print("[FocusNap] Line numbers switched on")
            else
                print("[FocusNap] Line numbers switched off")
            end
        elseif cursor_line == 4 then
            print("[FocusNap] SignColumn feature coming soon")
        end
    end, map_opts)

    return buf, window
end

function M.setup(opts)
    config.setup(opts)
end

return M
