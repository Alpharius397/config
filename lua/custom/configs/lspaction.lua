local util = require("lspconfig.util")

local function expressComment(attrs)
  local cmd = "<ESC>O/**<CR>"
  for _, attr in ipairs(attrs) do
    cmd = cmd .. attr .. " <CR>"
  end
  cmd = cmd .. "<BS>/<ESC>" .. #attrs .. "kA"
  return cmd
end

return {
  goError = "<ESC>oif err != nil {<CR>}<ESC>O",

  type_ignore = "<ESC>A #type: ignore<ESC><CR>",

  tsExpectError = "<ESC>O//@ts-expect-error ",

  tsIgnoreError = "<ESC>O//@ts-ignore ",

  jsDocComment = "<ESC>O/**  */<ESC>2hi",

  expressComment = expressComment({ "@desc", "@route", "@method", "@access" }),

  deno_root = util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),

  node_root = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", "package.lock")
}
