return {
  -- RustaceanVim (Rust LSP + DAP helper)

  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    ft = "rust",
    lazy = false,
    config = function()
      local codelldb_pkg   = vim.fn.expand("$MASON") .. "/packages/codelldb"
      local extension_path = codelldb_pkg .. "/extension/"
      local codelldb_path  = extension_path .. "adapter/codelldb"
      local liblldb_path   = extension_path .. "lldb/lib/liblldb.dylib" -- ← fixed line

      local cfg            = require('rustaceanvim.config')
      vim.g.rustaceanvim   = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end
  },
  -- Optional: rust.vim (for rustfmt on save etc.)
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  -- DAP core
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Ensure UI is set up before wiring listeners
      dapui.setup()

      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end,
  },

  -- crates.nvim (Cargo.toml goodies)
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup({
        -- Use crates.nvim's in-process LSP for Cargo.toml
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
          -- optional: on_attach = function(client, bufnr) ... end,
        },
        -- You can keep this table or drop it entirely; cmp/blink keys are no longer needed
        completion = {},
      })
    end,
  }
}
