local cmp = require 'cmp'
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

cmp.setup{
  formatting = {
    format = require('lspkind').cmp_format({
      with_text = false,
    }),
  },

  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        cmp_ultisnips_mappings.jump_backwards(fallback)
      end
    end, { 'i', 's' }),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
      end
    end, { 'i', 's' }),
  }),

  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },

  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp_signature_help' },
    },
    {
      { name = 'nvim_lsp', keyword_length = 3 },
      { name = 'ultisnips' },
      {
        name = 'buffer',
        keyword_length = 5,

        option = {
          get_bufnrs = function()
            local bufs = {}

            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end

            return vim.tbl_keys(bufs)
          end
        },
      },
    }
  ),

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
}

require('nvim-autopairs').setup()
