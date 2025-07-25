-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

require("filetype_mappings").setup()
M.base46 = {
  theme = "gruvbox",

  hl_override = {
  	Comment = { italic = true },
  	["@comment"] = { italic = true },
  },
}

M.ui = {
      tabufline = {
         lazyload = false
     }
}
return M
