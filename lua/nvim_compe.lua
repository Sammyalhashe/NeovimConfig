local utils = require'utils'

require'compe'.setup({
    enabled = true,
    source = {
      path = true,
      buffer = true,
      nvim_lsp = true,
      documentation = true,
      snippetSupport = true,
      calc = true,
      treesitter = false,
      snippets_nvim = true,
    },
  })
