-- Colorschemes and theming configuration
return {
  { -- Tokyo Night theme
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Options: 'tokyonight-night', 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'
      vim.cmd.colorscheme 'gruvdark'  -- Change this line to your preference
    end,
  },

  { -- Alternative theme (lazy loaded)
    'darianmorat/gruvdark.nvim',
    lazy = true, -- Don't load unless explicitly called
    priority = 1000,
    opts = {},
  },
}