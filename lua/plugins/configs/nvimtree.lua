local status_ok, nvim_tree = pcall(require, "nvim-tree")

if not status_ok then
  return
end

-- globals must be set prior to requiring nvim-tree to function
--local g = vim.g

local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', '<C-y>', api.node.open.vertical, opts('Open: Vertical Split'))
end

local default = {
  on_attach = my_on_attach,
  filters = {
    dotfiles = false,
  },
  disable_netrw = true,
  hijack_netrw = true,
  open_on_tab = false,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  view = {
    side = "left",
    width = 25,
    preserve_window_proportions = true,
  },
  git = {
    enable = false,
    ignore = false,
  },
  actions = {
    open_file = {
      resize_window = false,
    },
  },
  renderer = {
    add_trailing = false,
    highlight_git = false,
    highlight_opened_files = "none",
    root_folder_label = false,
    root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" },
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        folder = true,
        file = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        git = {
          deleted = "",
          ignored = "◌",
          renamed = "➜",
          staged = "✓",
          unmerged = "",
          unstaged = "✗",
          untracked = "★",
        },
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
        },
      },
    },
  },
}

local M = {}

M.setup = function()
  nvim_tree.setup(default)
end

return M
