-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'neovim/nvim-lspconfig',
    -- Merge into Kickstart's LSP setup
    opts = function(_, opts)
      local tb = require 'telescope.builtin'

      -- extend on_attach (keep Kickstart's if present)
      local old_on_attach = opts.on_attach
      opts.on_attach = function(client, bufnr)
        if old_on_attach then
          old_on_attach(client, bufnr)
        end
        local map = function(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end
        map('gr', tb.lsp_references, 'LSP: References (Telescope)')
        -- nice extras:
        map('gd', tb.lsp_definitions, 'LSP: Definitions (Telescope)')
        map('gi', tb.lsp_implementations, 'LSP: Implementations (Telescope)')
        map('gt', tb.lsp_type_definitions, 'LSP: Type defs (Telescope)')
      end

      -- enable the Swift server
      opts.servers = opts.servers or {}
      -- If sourcekit-lsp isn't auto-discovered, set cmd explicitly using xcrun
      local sourcekit_path = vim.fn.systemlist('xcrun --find sourcekit-lsp')[1]
      opts.servers.sourcekit = {
        cmd = (sourcekit_path and #sourcekit_path > 0) and { sourcekit_path } or nil,
      }
    end,
  },
}
