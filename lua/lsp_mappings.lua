local M = {}

function M.on_attach(client, bufnr)
  local ft = vim.bo[bufnr].filetype
  print("LSP attachted to " .. client.name .. " on filetype " .. ft)

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      silent = true,
      desc = desc,
    })
  end
  local telescope = require("telescope.builtin")
  -- General LSP mappings
  map("n", "<C-b>", vim.lsp.buf.definition, "LSP: Goto Definition")
  map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
  map("n", "<A-r>", vim.lsp.buf.rename, "LSP: Rename")
  map("n", "<A-CR>", vim.lsp.buf.code_action, "LSP: Code Action")
  map("n", "<A-d>", vim.diagnostic.open_float, "LSP: Show diagnostics")
  map("n", "<A-b>", function ()
    telescope.lsp_references()
  end, "LSP: Search references")
  -- Rust
  if client.name == "rust-analyzer" then
    local opts = { buffer = bufnr, silent = true }

    -- Hover actions
    vim.keymap.set("n", "K", function()
      vim.cmd.RustLsp { "hover", "actions" }
    end, vim.tbl_extend("force", opts, { desc = "Show documentation" }))

    vim.keymap.set("n", "<leader>me", function()
      vim.cmd.RustLsp { "expandMacro" }
    end, { desc = "Expand macros" })
    -- Code actions
    vim.keymap.set("n", "<A-CR>", function()
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
    vim.keymap.set("n", "<A-e>", function()
      vim.cmd.RustLsp { "explainError", "current" }
    end, vim.tbl_extend("force", opts, { desc = "Explain error" }))

    -- Render diagnostics
    vim.keymap.set("n", "<A-d>", function()
      vim.cmd.RustLsp { "renderDiagnostic", "current" }
    end, vim.tbl_extend("force", opts, { desc = "Explain error" }))
  end

  local neotest = require "neotest"
  map("n", "<leader>tr", function()
    neotest.run.run()
  end, "Test: Run nearest")

  map("n", "<leader>td", function()
    neotest.run.run { strategy = "dap", suite = false }
  end, "Test: Debug nearest")

  map("n", "<leader>tf", function()
    neotest.run.run(vim.fn.expand "%")
  end, "Test: Run current file")

  map("n", "<leader>tD", function()
    neotest.run.run { suite = true, strategy = "dap" }
  end, "Test: Run current file")

  map("n", "<leader>ts", function()
    neotest.run.stop()
  end, "Test: stopt test")

  map({ "x", "n" }, "<leader>re", function()
    require("refactoring").refactor "Extract Function"
  end, "Refactor: Extract function")
  map({ "x", "n" }, "<leader>rf", function()
    require("refactoring").refactor "Extract Function To File"
  end, "Refactor: Extract to file")
  map({ "x", "n" }, "<leader>rv", function()
    require("refactoring").refactor "Extract Variable"
  end, "Refactor: Extract variable")
  -- Filetype-specific LSP mappings
  if ft == "tex" and client.name == "texlab" then
    map("n", "<leader>lb", "<cmd>TexlabBuild<CR>", "LaTeX: Build")
    map("n", "<leader>lf", "<cmd>TexlabForward<CR>", "LaTeX: Forward PDF")
    map("n", "<leader>lc", function()
      vim.cmd "TexlabCleanArtifacts"
      vim.cmd "TexlabCleanAuxiliary"
    end, "LaTeX: Clean artifacts")
    -- map("n", "<leader>")
  elseif (ft == "cpp" or ft == "c") and client.name == "clangd" then
    map("n", "<leader>hh", "<cmd>ClangdSwitchSourceHeader<CR>", "C/C++: Switch Header/Source")
  elseif ft == "python" and client.name == "pyright" then
    map("n", "<leader>oi", "<cmd>PyrightOrganizeImports<CR>", "Python: Organize Imports")
  end
end

return M
