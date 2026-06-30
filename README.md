# focus-nap.nvim

Lightweight, transient state toggler for Neovim. Temporarily silence diagnostics and clean up UI canvas for the session.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "ItzArka1407/focus-nap.nvim",
    keys = {
        { "<leader>fn", "<cmd>ContextNapToggle<CR>", desc = "Toggle Focus Mode" },
    },
    opts = {
        disable_diagnostics = true,
        hide_line_numbers = true, -- Try setting this to true!
    }
}
