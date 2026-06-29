return {
    'Saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*', -- Use a release tag to ensure stability
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  }