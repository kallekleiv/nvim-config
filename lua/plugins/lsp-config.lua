-- Custom LSP configurations and enhancements
return {
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      local lspconfig = require 'lspconfig'
      local tb = require 'telescope.builtin'

      -- Extend on_attach to add custom keymaps (keep Kickstart's if present)
      local old_on_attach = opts.on_attach
      opts.on_attach = function(client, bufnr)
        if old_on_attach then
          old_on_attach(client, bufnr)
        end
        
        local map = function(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end
        
        -- Custom Telescope-based LSP keymaps
        -- Note: These override the default Kickstart keymaps with Telescope versions
        map('gr', tb.lsp_references, 'LSP: References (Telescope)')
        map('gd', tb.lsp_definitions, 'LSP: Definitions (Telescope)')
        map('gi', tb.lsp_implementations, 'LSP: Implementations (Telescope)')
        map('gt', tb.lsp_type_definitions, 'LSP: Type defs (Telescope)')
      end

      -- Configure SourceKit LSP for Swift
      lspconfig.sourcekit.setup {
        cmd = { 'xcrun', 'sourcekit-lsp' },
        filetypes = { 'swift' },
        root_dir = function(fname)
          local util = require 'lspconfig.util'
          return util.root_pattern('Package.swift', '*.xcodeproj', '*.xcworkspace', '.git')(fname)
            or util.find_git_ancestor(fname)
            or vim.fn.getcwd()
        end,
        capabilities = opts.capabilities or vim.lsp.protocol.make_client_capabilities(),
        settings = {},
      }
    end,
  },
}