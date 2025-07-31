return {
 {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    lazy = false, -- Load on startup
    config = function()
      require("claude-code").setup()
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
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
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
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
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }

            -- Hover actions
            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp { "hover", "actions" }
            end, vim.tbl_extend("force", opts, { desc = "Show documentation" }))

            vim.keymap.set("n", "<leader>me", function()
              vim.cmd.RustLsp { "expandMacro" }
            end, { desc = "Expand macros" })
            -- Code actions
            vim.keymap.set("n", "<leader>a", function()
              vim.cmd.RustLsp "codeAction"
            end, vim.tbl_extend("force", opts, { desc = "Code actions" }))

            -- Runnables
            vim.keymap.set("n", "<F5>", function()
              vim.cmd.RustLsp "runnables"
            end, vim.tbl_extend("force", opts, { desc = "Show runnables" }))

            -- Debuggables
            vim.keymap.set("n", "<F4>", function()
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
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- falls du @function.inner etc. nutzt
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function(_, opts)
      local config = require "configs.treesitter"
      require("nvim-treesitter.configs").setup(config)
    end,
  },
}
