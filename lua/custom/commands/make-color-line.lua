local bit = require("bit")
local utils = require("custom.utils")

---@param code integer
---@return string
local function getAsciiForegroundColor(code)
  local r = bit.band(bit.rshift(code, 16), 255)
  local g = bit.band(bit.rshift(code, 8), 255)
  local b = bit.band(code, 255)

  return "\\\\e[38;2;" .. r .. ";" .. g .. ";" .. b .. "m"
end

---@param color string
---@return string
local function makefileColorEcho(color)
  local color_code = vim.api.nvim_get_color_by_name(utils.captialize(color))

  local str = "@echo $(call Color_Line," .. getAsciiForegroundColor(color_code) .. ",)"

  return "<ESC>o" .. str .. "<ESC>$i"
end


local function makefileColors()
  local str = "Color_Line = \"$(1)$(2)" .. "\\\\e[0m\""
  return "<ESC>o" .. str .. "<ESC>"
end

return {
  load_commands = function()
    utils.create_user_command("MakeColor", function(opts)
      local keys = vim.api.nvim_replace_termcodes(makefileColorEcho(opts.fargs[1]), true, false, true)
      vim.api.nvim_feedkeys(keys, "n", false)
    end, { desc = "Make Color line", nargs = "*" })
  end,

  makefileColors = makefileColors(),

  makefileColorEcho = makefileColorEcho
}
