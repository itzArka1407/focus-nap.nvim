# context-nap.nvim

A lightweight, high-performance transient state toggler for Neovim. Temporarily silence diagnostics and clean up your UI canvas on-the-fly without altering your disk-backed session state.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "ItzArka1407/context-nap.nvim",
    keys = {
        { "<leader>fn", "<cmd>ContextNapToggle<CR>", desc = "Toggle Focus Mode" },
    },
    opts = {
        disable_diagnostics = true,
        hide_line_numbers = true, -- Try setting this to true!
    }
}
