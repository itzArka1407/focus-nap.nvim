if vim.g.loaded_context_nap then
    return
end
vim.g.loaded_context_nap = true

-- Expose user global command
vim.api.nvim_create_user_command("ContextNapToggle", function()
    require("context-nap").toggle()
end, {})
