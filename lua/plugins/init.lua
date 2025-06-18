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
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      require "configs.dap"
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
      vim.g.rustaceanvim = {
        tool = {
          runnables = {
            use_telescope = true,
          },
          debuggables = {

            use_telescope = true,
          },
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }

            -- Hover actions
            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp { "hover", "actions" }
            end, vim.tbl_extend("force", opts, { desc = "Show documentation" }))

            -- Code actions
            vim.keymap.set("n", "<leader>a", function()
              vim.cmd.RustLsp "codeAction"
            end, vim.tbl_extend("force", opts, { desc = "Code actions" }))

            -- Runnables
            vim.keymap.set("n", "<F5>", function()
              vim.cmd.RustLsp "runnables"
            end, vim.tbl_extend("force", opts, { desc = "Show runnables" }))

            -- Debuggables
            vim.keymap.set("n", "<C-F5>", function()
              vim.cmd.RustLsp "debuggables"
            end, vim.tbl_extend("force", opts, { desc = "Show debuggables" }))

            -- Explain error
            vim.keymap.set("n", "<leader>dd", function()
              vim.cmd.RustLsp "explainError"
            end, vim.tbl_extend("force", opts, { desc = "Explain error" }))
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
        -- DAP configuration
        dap = {},
      }
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", --optional
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    branch = "regexp", -- This is the regexp branch, use this for the new version
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" },
    },
    ---@type venv-selector.Config
    opts = {
      -- Your settings go here
    },
  },
  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Repositories", "~/Downloads", "/" },
      -- log_level = 'debug',
    },
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
