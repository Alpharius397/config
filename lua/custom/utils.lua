return {
  ---comment
  ---@param table table
  ---@return nil
  applyMappings = function(table)
    for mode, config in pairs(table) do
      for lhs, rhs in pairs(config) do
        vim.keymap.set(mode, lhs, rhs[1], { desc = rhs[2] })
      end
    end
  end,

  ---@param list1 any[]
  ---@param list2 any[]
  ---@return any[]
  extend = function(list1, list2)
    for key, value in pairs(list2) do
      if type(key) == "number" then
        table.insert(list1, value)
      end
    end

    return list1
  end,

  ---@param a string
  ---@return string
  captialize = function(a)
    return string.upper(a:sub(0, 1)) .. string.lower(a:sub(2, string.len(a)))
  end,

  ---@param name string
  ---@param command string | fun(args: vim.api.keyset.create_user_command.command_args)
  ---@param opts vim.api.keyset.user_command
  ---@return nil
  create_user_command = function(name, command, opts)
    pcall(function()
      vim.api.nvim_del_user_command(name)
    end)
    vim.api.nvim_create_user_command(name, command, opts)
  end
}
