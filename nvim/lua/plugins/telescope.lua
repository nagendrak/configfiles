return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
  },
  keys = {
    {"<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files"},
    {"<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Select buffer"},
    { "<leader>fg",
      function()
        local lga = require("telescope").extensions.live_grep_args
        lga.live_grep_args({
          default_text ='-i --hidden ""',
          attach_mappings = function(_, _)
            -- A single <Left> shifts cursor inside the trailing pair: -i --hidden "|"
            local left_key = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
            vim.api.nvim_feedkeys(left_key, "n", false)
            return true
          end,
        })
      end,
      desc = "Live grep"
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("live_grep_args")
  end,
}
