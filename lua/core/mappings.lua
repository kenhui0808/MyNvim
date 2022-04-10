local utils = require "core.utils"

local cmd = vim.cmd
local map_wrapper = utils.map

local configs = require("core.configs")

local maps = configs.mappings
local plugin_maps = maps.plugins

local settings = configs.options.settings

-- This is a wrapper function made to disable a plugin mapping from configs
-- If keys are nil, false or empty string, then the mapping will be not applied
-- Useful when one wants to use that keymap for any other purpose
local map = function(...)
  local keys = select(2, ...)
  if not keys or keys == "" then
    return
  end
  map_wrapper(...)
end

local M = {}

-- These mappings will only be called during initialization
M.misc = function()
  local function non_config_mappings()
    -- Don't copy the replaced text after pasting in visual mode
    map_wrapper("v", "p", "p:let @+=@0<CR>")

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    map_wrapper({"n", "x", "o"}, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    map_wrapper({"n", "x", "o"}, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
    map_wrapper("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    map_wrapper("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

    -- use ESC to turn off search highlighting
    map_wrapper("n", "<Esc>", ":noh <CR>")

    -- yank from current cursor to end of line
    map_wrapper("n", "Y", "yg$")
  end

  local function optional_mappings()
    -- don't yank text on cut ( x )
    if not settings.copy_cut then
      map_wrapper({ "n", "v" }, "x", '"_x')
    end

    -- don't yank text on delete ( dd )
    if not settings.copy_del then
      map_wrapper({ "n", "v" }, "d", '"_d')
    end

    -- navigation within insert mode
    if settings.insert_nav then
      local inav = maps.insert_nav

      map("i", inav.backward, "<Left>")
      map("i", inav.end_of_line, "<End>")
      map("i", inav.forward, "<Right>")
      map("i", inav.next_line, "<Up>")
      map("i", inav.prev_line, "<Down>")
      map("i", inav.beginning_of_line, "<ESC>^i")
    end

    -- easier navigation between windows
    if settings.window_nav then
      local wnav = maps.window_nav

      map("n", wnav.moveLeft, "<C-w>h")
      map("n", wnav.moveRight, "<C-w>l")
      map("n", wnav.moveUp, "<C-w>k")
      map("n", wnav.moveDown, "<C-w>j")
    end
  end

  local function required_mappings()
    map("n", maps.misc.close_buffer, ":lua require('core.utils').close_buffer() <CR>") -- close buffer
    map("n", maps.misc.close_window, ":lua require('core.utils').close_window() <CR>") -- close window
    map("v", maps.misc.cp_selection, "\"*y <CR>")
    map("n", maps.misc.cp_whole_file, ":%y+ <CR>") -- copy whole file content
    map("n", maps.misc.line_number_toggle, ":set nu! <CR>")

    map("n", maps.misc.new_buffer, ":enew <CR>") -- new buffer
    map("n", maps.misc.new_tabpage, ":tabnew <CR>") -- new tabs

    map("n", maps.misc.next_tabpage, ":tabn <CR>") -- next tabpage
    map("n", maps.misc.prev_tabpage, ":tabp <CR>") -- next tabpage
    map("n", maps.misc.close_tabpage, ":tabc <CR>") -- next tabpage

    map("n", maps.misc.split_horizontal, ":sp | enew <CR>") -- split horizontal
    map("n", maps.misc.split_vertical, ":vsp | enew <CR>") -- split vertical
  
    -- window resize --
    map("n", maps.misc.window_resize_up, ":resize -1<CR>") -- new tabs
    map("n", maps.misc.window_resize_down, ":resize +1<CR>") -- new tabs
    map("n", maps.misc.window_resize_left, ":vertical resize -1<CR>") -- new tabs
    map("n", maps.misc.window_resize_right, ":vertical resize +1<CR>") -- new tabs

    -- terminal mappings --
    local term_maps = maps.terminal
    map("t", term_maps.esc_termmode, "<C-\\><C-n>")
    map("n", term_maps.new_terminal, ":execute 'terminal' | startinsert <CR>")

    -- Add Packer commands because we are not loading it at startup
    cmd "silent! command PackerClean lua require 'plugins' require('packer').clean()"
    cmd "silent! command PackerCompile lua require 'plugins' require('packer').compile()"
    cmd "silent! command PackerInstall lua require 'plugins' require('packer').install()"
    cmd "silent! command PackerStatus lua require 'plugins' require('packer').status()"
    cmd "silent! command PackerSync lua require 'plugins' require('packer').sync()"
    cmd "silent! command PackerUpdate lua require 'plugins' require('packer').update()"
  end

  non_config_mappings()
  optional_mappings()
  required_mappings()
end

-- below are all plugin related mappings

M.bufferline = function()
  local m = plugin_maps.bufferline

  map("n", m.next_buffer, ":BufferLineCycleNext <CR>")
  map("n", m.prev_buffer, ":BufferLineCyclePrev <CR>")

  map("n", m.buffer_move_right, ":BufferLineMoveNext <CR>")
  map("n", m.buffer_move_left, ":BufferLineMovePrev <CR>")
end

M.comment = function()
  local m = plugin_maps.comment.toggle
  map("n", m, ":lua require('Comment.api').toggle_current_linewise()<CR>")
  map("v", m, ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")
end

M.lspconfig = function()
  local m = plugin_maps.lspconfig

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map("n", m.declaration, "<cmd>lua vim.lsp.buf.declaration()<CR>")
  map("n", m.definition, "<cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", m.hover, "<cmd>lua vim.lsp.buf.hover()<CR>")
  map("n", m.implementation, "<cmd>lua vim.lsp.buf.implementation()<CR>")
  map("n", m.signature_help, "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  map("n", m.type_definition, "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  map("n", m.rename, "<cmd>lua vim.lsp.buf.rename()<CR>")
  map("n", m.references, "<cmd>lua vim.lsp.buf.references()<CR>")
  map("n", m.float_diagnostics, "<cmd>lua vim.diagnostic.open_float()<CR>")
  map("n", m.goto_prev, "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  map("n", m.goto_next, "<cmd>lua vim.diagnostic.goto_next()<CR>")
  map("n", m.formatting, "<cmd>lua vim.lsp.buf.formatting()<CR>")
  map("v", m.formatting, "<cmd>lua vim.lsp.buf.formatting()<CR>")
end

M.nvimtree = function()
  map("n", plugin_maps.nvimtree.toggle, ":NvimTreeToggle <CR>")
  map("n", plugin_maps.nvimtree.focus, ":NvimTreeFindFile <CR>")
end

M.telescope = function()
  local m = plugin_maps.telescope

  map("n", m.buffers, ":Telescope buffers <CR>")
  map("n", m.find_files, ":Telescope find_files <CR>")
  map("n", m.find_hiddenfiles, ":Telescope find_files follow=true no_ignore=true hidden=true <CR>")
  map("n", m.git_commits, ":Telescope git_commits <CR>")
  map("n", m.git_status, ":Telescope git_status <CR>")
  map("n", m.help_tags, ":Telescope help_tags <CR>")
  map("n", m.live_grep, ":Telescope live_grep <CR>")
  map("n", m.oldfiles, ":Telescope oldfiles <CR>")
end

return M
