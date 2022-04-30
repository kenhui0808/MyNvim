local M = {}

-- if theme given, load given theme if given, otherwise color_theme
M.init = function(theme)
  if not theme then
    theme = require("core.configs").ui.theme
  end

  -- set the global theme, used at various places like theme switcher, highlights
  vim.g.color_theme = theme

  local present, base16 = pcall(require, "base16")

  if present then
    -- first load the base16 theme
    local ok, array = pcall(base16.themes, theme)

    if ok then
      base16(array, true)
      -- unload to force reload
      package.loaded["colors.highlights" or false] = nil
      -- then load the highlights
      require "colors.highlights"
    else
      pcall(vim.cmd, "colo " .. theme)
    end
  else
    pcall(vim.cmd, "colo " .. theme)
  end
end

-- returns a table of colors for given or current theme
M.get = function(theme)
  if not theme then
   theme = vim.g.color_theme
  end

  return require("hl_themes." .. theme)
end

return M
