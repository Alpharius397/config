local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })

local function prettier_format()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local text = table.concat(lines, '\n')

  local file = vim.api.nvim_buf_get_name(0)

  local result = vim.system({
    "prettier", "--stdin-filepath", file
  }, {
    stdin = text
  }):wait()


  if result.code ~= 0 then
    vim.notify(result.stderr, vim.log.levels.ERROR)
    return
  end

  local view = vim.fn.winsaveview()

  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result.stdout, "\n", { plain = true }))

  vim.fn.winrestview(view)
end

local function on_attach(_, bufnr)
  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    group = group,
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr, async = false })
    end,
    desc = "[lsp] format on save",
  })
end

return {
  group = group,
  on_attach = on_attach,
  prettier_forma = prettier_format
}
