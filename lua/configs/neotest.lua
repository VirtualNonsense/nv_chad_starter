local js_watch_query = [[
  ;query
  ;Captures named imports
  (import_specifier name: (identifier) @symbol)
  ;Captures default import
  (import_clause (identifier) @symbol)
  ;Capture require statements
  (variable_declarator 
  name: (identifier) @symbol
  value: (call_expression (identifier) @function  (#eq? @function "require")))
  ;Capture namespace imports
  (namespace_import (identifier) @symbol)
]]

require("neotest").setup {
  log_level = vim.log.levels.WARN,
  adapters = {   
    require("neotest-python")({
      dap = { justMyCode = false }, -- Debugging Support via nvim-dap
      runner = "pytest",            -- Alternativen: unittest, nose
    }),
  },
  discovery = {
    enabled = true,
    concurrent = 0,
    filter_dir = nil,
  },
  running = {
    concurrent = true,
  },
  consumers = {},
  icons = {
    -- Ascii:
    -- { "/", "|", "\\", "-", "/", "|", "\\", "-"},
    -- Unicode:
    -- { "", "🞅", "🞈", "🞉", "", "", "🞉", "🞈", "🞅", "", },
    -- {"◴" ,"◷" ,"◶", "◵"},
    -- {"◢", "◣", "◤", "◥"},
    -- {"◐", "◓", "◑", "◒"},
    -- {"◰", "◳", "◲", "◱"},
    -- {"⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷"},
    -- {"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"},
    -- {"⠋", "⠙", "⠚", "⠞", "⠖", "⠦", "⠴", "⠲", "⠳", "⠓"},
    -- {"⠄", "⠆", "⠇", "⠋", "⠙", "⠸", "⠰", "⠠", "⠰", "⠸", "⠙", "⠋", "⠇", "⠆"},
    -- { "⠋", "⠙", "⠚", "⠒", "⠂", "⠂", "⠒", "⠲", "⠴", "⠦", "⠖", "⠒", "⠐", "⠐", "⠒", "⠓", "⠋" },
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    passed = "",
    running = "",
    failed = "",
    skipped = "",
    unknown = "",
    non_collapsible = "─",
    collapsed = "─",
    expanded = "╮",
    child_prefix = "├",
    final_child_prefix = "╰",
    child_indent = "│",
    final_child_indent = " ",
    watching = "",
    test = "",
    notify = "",
  },
  highlights = {
    passed = "NeotestPassed",
    running = "NeotestRunning",
    failed = "NeotestFailed",
    skipped = "NeotestSkipped",
    test = "NeotestTest",
    namespace = "NeotestNamespace",
    focused = "NeotestFocused",
    file = "NeotestFile",
    dir = "NeotestDir",
    border = "NeotestBorder",
    indent = "NeotestIndent",
    expand_marker = "NeotestExpandMarker",
    adapter_name = "NeotestAdapterName",
    select_win = "NeotestWinSelect",
    marked = "NeotestMarked",
    target = "NeotestTarget",
    unknown = "NeotestUnknown",
    watching = "NeotestWatching",
  },
  floating = {
    border = nil,
    max_height = 0.6,
    max_width = 0.6,
    options = {},
  },
  default_strategy = "integrated",
  strategies = {
    integrated = {
      width = 120,
      height = 40,
    },
  },
  summary = {
    enabled = true,
    count = true,
    animated = true,
    follow = true,
    expand_errors = true,
    open = "botright vsplit | vertical resize 50",
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      expand_all = "e",
      output = "o",
      short = "O",
      attach = "a",
      jumpto = "i",
      stop = "u",
      run = "r",
      debug = "d",
      mark = "m",
      run_marked = "R",
      debug_marked = "D",
      clear_marked = "M",
      target = "t",
      clear_target = "T",
      next_failed = "J",
      prev_failed = "K",
      watch = "w",
      help = "?",
    },
  },
  benchmark = {
    enabled = true,
  },
  output = {
    enabled = true,
    open_on_run = "short",
  },
  output_panel = {
    enabled = true,
    open = "botright split | resize 15",
  },
  diagnostic = {
    enabled = true,
    severity = vim.diagnostic.severity.ERROR,
  },
  status = {
    enabled = true,
    virtual_text = false,
    signs = true,
  },
  run = {
    enabled = true,
  },
  jump = {
    enabled = true,
  },
  quickfix = {
    enabled = true,
    open = false,
  },
  state = {
    enabled = true,
  },
  watch = {
    enabled = true,
    symbol_queries = {
      typescript = js_watch_query,
      javascript = js_watch_query,
      tsx = js_watch_query,
      python = [[
        ;query
        ;Captures imports and modules they're imported from
        (import_from_statement (_ (identifier) @symbol))
        (import_statement (_ (identifier) @symbol))
      ]],
      go = [[
        ;query
        ;Captures imported types
        (qualified_type name: (type_identifier) @symbol)
        ;Captures package-local and built-in types
        (type_identifier)@symbol
        ;Captures imported function calls and variables/constants
        (selector_expression field: (field_identifier) @symbol)
        ;Captures package-local functions calls
        (call_expression function: (identifier) @symbol)
      ]],
      lua = [[
        ;query
        ;Captures module names in require calls
        (function_call
          name: ((identifier) @function (#eq? @function "require"))
          arguments: (arguments (string) @symbol))
      ]],
      elixir = function(root, content)
        local lib = require "neotest.lib"
        local query = lib.treesitter.normalise_query(
          "elixir",
          [[;; query
            (call (identifier) @_func_name
              (arguments (alias) @symbol)
              (#match? @_func_name "^(alias|require|import|use)")
              (#gsub! @symbol ".*%.(.*)" "%1")
            )
          ]]
        )
        local symbols = {}
        for _, match, metadata in query:iter_matches(root, content, nil, nil, { all = false }) do
          for id, node in pairs(match) do
            local name = query.captures[id]

            if name == "symbol" then
              local start_row, start_col, end_row, end_col = node:range()
              if metadata[id] ~= nil then
                local real_symbol_length = string.len(metadata[id]["text"])
                start_col = end_col - real_symbol_length
              end

              symbols[#symbols + 1] = { start_row, start_col, end_row, end_col }
            end
          end
        end
        return symbols
      end,
      ruby = [[
        ;query
        ;rspec - class name
        (call
          method: (identifier) @_ (#match? @_ "^(describe|context)")
          arguments: (argument_list (constant) @symbol )
        )

        ;rspec - namespaced class name
        (call
          method: (identifier)
          arguments: (argument_list
            (scope_resolution
              name: (constant) @symbol))
        )
      ]],
      rust = [[
        ;query
        ;submodule import
        (mod_item
          name: (identifier) @symbol)
        ;single import
        (use_declaration
          argument: (scoped_identifier
            name: (identifier) @symbol))
        ;import list
        (use_declaration
          argument: (scoped_use_list
            list: (use_list
                [(scoped_identifier
                   path: (identifier)
                   name: (identifier) @symbol)
                 ((identifier) @symbol)])))
        ;wildcard import
        (use_declaration
          argument: (scoped_use_list
            path: (identifier)
            [(use_list
              [(scoped_identifier
                path: (identifier)
                name: (identifier) @symbol)
                ((identifier) @symbol)
              ])]))
      ]],
      swift = [[
        ;query
        ;import
        (simple_identifier) @symbol
      ]],
      haskell = [[
        ;query
        ;explicit import
        (import_name (variable) @symbol)
        ;symbols that may be imported implicitly
        ((type) @symbol)
        (qualified (name) @symbol)
        (apply (variable) @symbol)
        ((constructor) @symbol)
        ((operator) @symbol)
      ]],
      java = [[
        ;query
        ;captures imported classes
        (import_declaration
            (scoped_identifier name: ((identifier) @symbol))
        )
      ]],
    },
    filter_path = nil,
  },
  projects = {},
}
