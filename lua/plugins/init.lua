return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
      })
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
      vim.g.rustaceanvim = {
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }

            -- Hover actions
            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp { "hover", "actions" }
            end, opts)

            -- Code actions
            vim.keymap.set("n", "<leader>a", function()
              vim.cmd.RustLsp "codeAction"
            end, opts)

            -- Runnables
            vim.keymap.set("n", "<leader>rr", function()
              vim.cmd.RustLsp "runnables"
            end, opts)

            -- Debuggables
            vim.keymap.set("n", "<leader>rd", function()
              vim.cmd.RustLsp "debuggables"
            end, opts)

            -- Explain error
            vim.keymap.set("n", "<leader>e", function()
              vim.cmd.RustLsp "explainError"
            end, opts)
          end,
          default_settings = {
            ["rust_analyser"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
  },
  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
