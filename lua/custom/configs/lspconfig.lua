local utils = require("custom.utils")

local lspaction = require("custom.configs.lspaction")

-- TODO: add this into lsp
-- local normalConfigLsp = { "cssls", "html", "djlsp" }

local lua = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  },
}

local function non_deno_root_dir(bufnr, on_dir)
  local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  root_markers = { root_markers, { '.git' } }

  local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
  local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
  local project_root = vim.fs.root(bufnr, root_markers)

  if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
    return
  end
  if deno_root and (not project_root or #deno_root >= #project_root) then
    return
  end

  on_dir(project_root or vim.fn.getcwd())
end

local function ts_on_attach(_, _)
  vim.keymap.set('n', '<leader>je', lspaction.tsExpectError,
    { noremap = true, silent = true, desc = "insert expects-errors" })

  vim.keymap.set('n', '<leader>ji', lspaction.tsIgnoreError,
    { noremap = true, silent = true, desc = "insert ignore-errors" })

  vim.keymap.set('n', '<leader>jc', lspaction.jsDocComment, { noremap = true, silent = true, desc = "insert jsDoc" })

  vim.keymap.set('n', '<leader>pe', lspaction.expressComment,
    { noremap = true, silent = true, desc = "insert express/server comment" })

  vim.keymap.set('n', '<leader>jse', lspaction.tsxExpectError,
    { noremap = true, silent = true, desc = "insert tsx expects-errors" })

  vim.keymap.set('n', '<leader>jsi', lspaction.tsxIgnoreError,
    { noremap = true, silent = true, desc = "insert tsx ignore-errors" })

  vim.keymap.set('n', '<leader>jd', lspaction.eslintTsDisable,
    { noremap = true, silent = true, desc = "insert ts eslint disable" })

  vim.keymap.set('n', '<leader>jsd', lspaction.eslintTsxDisable,
    { noremap = true, silent = true, desc = "insert tsx eslint disable" })
end

local TsFileTypes = { "javascript", "typescript" }
local ReactFileTypes = { "javascriptreact", "typescriptreact" }

local ts = {
  tailwindcss = {
    cmd = { 'tailwindcss-language-server', "--stdio" },
    filetypes = ReactFileTypes,
    root_dir = function(bufnr, on_dir)
      local root_markers = { 'tailwind.config.js' }
      local project_root = vim.fs.root(bufnr, root_markers)

      if (project_root) then
        on_dir(project_root)
      end
    end,
  },

  deno_ls = {
    cmd = { 'deno', 'lsp' },
    cmd_env = { NO_COLOR = true },
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },

    root_dir = function(bufnr, on_dir)
      local root_markers = { 'deno.lock', 'deno.json', 'deno.jsonc' }
      root_markers = { root_markers, { '.git' } }
      local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
      local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
      local project_root = vim.fs.root(bufnr, root_markers)

      if
          (deno_lock_root and (not project_root or #deno_lock_root > #project_root))
          or (deno_root and (not project_root or #deno_root >= #project_root))
      then
        on_dir(project_root or deno_lock_root or deno_root)
      end
    end,
  },

  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    on_attach = ts_on_attach,
    filetypes = utils.extend(TsFileTypes, ReactFileTypes),
    root_dir = non_deno_root_dir
  },

  -- tsgo = {
  --   cmd = { "tsgo", "--lsp", "--stdio" },
  --   on_attach = ts_on_attach,
  --   filetypes = TsFileTypes,
  --   root_dir = function(bufnr, on_dir)
  --     local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  --     root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
  --
  --         or vim.list_extend(root_markers, { '.git' })
  --
  --     local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
  --     local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
  --     local project_root = vim.fs.root(bufnr, root_markers)
  --
  --     if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
  --       return
  --     end
  --     if deno_root and (not project_root or #deno_root >= #project_root) then
  --       return
  --     end
  --
  --     on_dir(project_root or vim.fn.getcwd())
  --   end,
  -- },
}

local go = {
  gopls = {
    on_attach = function(_, _)
      vim.keymap.set('n', '<leader>ee', lspaction.goError, { noremap = true, silent = true, desc = "Error Block" })
      vim.keymap.set('i', '<C-e>', lspaction.goError, { noremap = true, silent = true, desc = "Error Block" })
    end,

    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    }
  },

  templ = {
    cmd = { 'templ', 'lsp' },
    filetypes = { 'templ' },
    root_markers = { 'go.work', 'go.mod', '.git' },
  }
}

local c = {
  clangd = {
    cmd = {
      "clangd",
      "--clang-tidy",
      "--background-index",
      "--enable-config"
    },
    filetypes = { "c", "cpp" }
  },
}

local sql = {
  postgres_lsp = {
    cmd = { "postgres-language-server", "lsp-proxy" },
    filetypes = { "sql" },
  },
}

local elixir = {
  elixirls = {
    cmd = { "language_server.sh" },
    filetypes = { "elixir" }
  },

}

local function python_on_attach(_, _)
  vim.keymap.set('n', '<leader>tt', lspaction.type_ignore, { noremap = true, silent = true, desc = "Type Ignore" })
  vim.keymap.set('i', '<C-t>', lspaction.type_ignore, { noremap = true, silent = true, desc = "Type Ignore" })
end

local python = {
  ruff = {
    cmd = { 'ruff', 'server' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    filetypes = { "python" },
    on_attach = python_on_attach
  },

  pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
      'pyrightconfig.json',
      'pyproject.toml',
      'setup.py',
      'setup.cfg',
      'requirements.txt',
      'Pipfile',
    },
    on_attach = python_on_attach
  }
}

-- local rust = {
--   rust_analyzer = {
--     filetypes = { "rust" },
--   },
--
-- }

local utility = {
  bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' }
  },

  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
    filetypes = { "json", "jsonc" },
    format = {
      enable = true,
    },
    trailingCommas = "none"
  },
}

return {
  lua = lua,
  go = go,
  ts = ts,
  elixir = elixir,
  utility = utility,
  c = c,
  python = python,
  sql = sql
}
