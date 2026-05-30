return {
  applyMappings = function(table)
    for mode, config in pairs(table) do
      for lhs, rhs in pairs(config) do
        vim.keymap.set(mode, lhs, rhs[1], { desc = rhs[2] })
      end
    end
  end
}
