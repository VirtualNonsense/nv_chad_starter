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

  -- General LSP mappings
  map("n", "gd", vim.lsp.buf.definition, "LSP: Goto Definition")
  map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
  map("n", "<leader>a", vim.lsp.buf.code_action, "LSP: Code Action")
  map("n", "<leader>dd", vim.diagnostic.open_float, "LSP: Show diagnostics")

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
