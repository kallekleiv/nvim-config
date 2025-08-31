return {
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'

      -- keep capabilities from your Kickstart LSP setup if present
      local caps = (opts and opts.capabilities) or nil

      lspconfig.sourcekit.setup {
        cmd = ((vim.uv or vim.loop).os_uname().sysname == 'Darwin') and { 'xcrun', 'sourcekit-lsp' } or { 'sourcekit-lsp' },
        filetypes = { 'swift' },
        root_dir = util.root_pattern('Package.swift', '.git'),
        capabilities = caps,
      }
    end,
  },
}
