local present, bufferline = pcall(require, "bufferline")

if not present then
  return
end

local default = {
  colors = require("colors").get(),
}

default = {
  options = {
    offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
    buffer_close_icon = "",
    modified_icon = "",
    close_icon = "",
    show_close_icon = true,
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    show_tab_indicators = true,
    enforce_regular_tabs = false,
    -- view = "multiwindow",
    show_buffer_close_icons = true,
    separator_style = "thin",
    always_show_bufferline = true,
    diagnostics = false,
    --custom_filter = function(buf_number)
    --  if vim.fn.getbufvar(buf_number, "&buftype") == "terminal" then
    --    return false
    --  end
    --  return true
    --end,
  },

  highlights = {
    background = {
      fg = default.colors.grey_fg,
      bg = default.colors.black2,
    },

    -- buffers
    buffer_selected = {
      fg = default.colors.white,
      bg = default.colors.black,
    },
    buffer_visible = {
      fg = default.colors.light_grey,
      bg = default.colors.black2,
    },

    -- for diagnostics = "nvim_lsp"
    error = {
      fg = default.colors.light_grey,
      bg = default.colors.black2,
    },
    error_diagnostic = {
      fg = default.colors.light_grey,
      bg = default.colors.black2,
    },

    -- close buttons
    close_button = {
      fg = default.colors.light_grey,
      bg = default.colors.black2,
    },
    close_button_visible = {
      fg = default.colors.light_grey,
      bg = default.colors.black2,
    },
    close_button_selected = {
      fg = default.colors.red,
      bg = default.colors.black,
    },
    fill = {
      fg = default.colors.grey_fg,
      bg = default.colors.black2,
    },
    indicator_selected = {
      fg = default.colors.black,
      bg = default.colors.black,
    },

    -- modified
    modified = {
      fg = default.colors.red,
      bg = default.colors.black2,
    },
    modified_visible = {
      fg = default.colors.red,
      bg = default.colors.black2,
    },
    modified_selected = {
      fg = default.colors.green,
      bg = default.colors.black,
    },

    -- separators
    separator = {
      fg = default.colors.black2,
      bg = default.colors.black2,
    },
    separator_visible = {
      fg = default.colors.black2,
      bg = default.colors.black2,
    },
    separator_selected = {
      fg = default.colors.black2,
      bg = default.colors.black2,
    },

    -- tabs
    tab = {
      fg = default.colors.light_grey,
      bg = default.colors.one_bg3,
    },
    tab_selected = {
      fg = default.colors.black2,
      bg = default.colors.nord_blue,
    },
    tab_close = {
      fg = default.colors.red,
      bg = default.colors.black,
    },
  },
}

local M = {}

M.setup = function()
  bufferline.setup(default)
end

return M
