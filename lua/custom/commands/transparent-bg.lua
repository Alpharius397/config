local function makeTransparent()
  vim.cmd("hi Normal guibg=none")
end

local function reset()
  vim.cmd("hi Normal guibg=#1e222a")
end

return {
  load_commands = function()
    vim.api.nvim_create_user_command("Transparent", makeTransparent, { desc = "Make Bg transparent" })
    vim.api.nvim_create_user_command("ResetBg", reset, { desc = "Reset Bg" })
  end
}
