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
      snippets_nvim = true,
    },
  })
