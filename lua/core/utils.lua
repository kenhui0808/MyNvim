local M = {}

local cmd = vim.cmd

M.close_window = function()
  local wins = vim.fn.gettabinfo(vim.fn.tabpagenr())[1].windows

  if #wins > 2 then
    cmd("close")
    return
  end

  if #wins == 2 then
    for _, win in ipairs(wins) do
      local buf = vim.fn.getwininfo(win)[1].bufnr
      if vim.fn.getbufvar(buf, "&filetype") == "NvimTree" then
        return
      end
    end
    cmd("close")
  end
end

-- Switch to buffer 'buf' on each tabpage each window from list 'windows'
local function switch_buffer(windows, buf)
  local cur_tab = vim.fn.tabpagenr()
  local cur_win = vim.fn.winnr()
  for _, winid in ipairs(windows) do
    winid = tonumber(winid) or 0
    if winid > 0 then
      local tabwin = vim.fn.win_id2tabwin(winid)
      local tab = tonumber(tabwin[1])
      local win = tonumber(tabwin[2])
      cmd(string.format("tabn %d", tab))
      cmd(string.format("%d wincmd w", win))
      cmd(string.format("buffer %d", buf))
    end
  end
  -- return to original window
  cmd(string.format("tabn %d", cur_tab))
  cmd(string.format("%d wincmd w", cur_win))
end

M.close_buffer = function()
  local present, buffers = pcall(require, 'bufferline.buffers')
  if not present then
    return 
  end

  local state = require('bufferline.state')
  local components = buffers.get_components(state)

  if #components <= 1 then
    return
  end

  local cur_buf = vim.fn.bufnr()

  local exists = false
  for _, component in ipairs(components) do
    if component.id == cur_buf then
      exists = true
      break
    end
  end

  if not exists then
    return
  end

  local wins = vim.fn.getbufinfo(cur_buf)[1].windows

  if cur_buf == components[#components].id then
    cmd("BufferLineCyclePrev")
  else
    cmd("BufferLineCycleNext")
  end

  local switch_buf = vim.fn.bufnr()
  switch_buffer(wins, switch_buf)
  cmd(string.format("silent! confirm bd %d", cur_buf))
end

M.map = function(mode, keys, command, opt)
  local options = { noremap = true, silent = true }
  if opt then
    options = vim.tbl_extend("force", options, opt)
  end

  -- all valid modes allowed for mappings
  -- :h map-modes
  local valid_modes = {
    [""] = true,
    ["n"] = true,
    ["v"] = true,
    ["s"] = true,
    ["x"] = true,
    ["o"] = true,
    ["!"] = true,
    ["i"] = true,
    ["l"] = true,
    ["c"] = true,
    ["t"] = true,
  }

  -- helper function for M.map
  -- can gives multiple modes and keys
  local function map_wrapper(sub_mode, lhs, rhs, sub_options)
    if type(lhs) == "table" then
      for _, key in ipairs(lhs) do
        map_wrapper(sub_mode, key, rhs, sub_options)
      end
    else
      if type(sub_mode) == "table" then
        for _, m in ipairs(sub_mode) do
          map_wrapper(m, lhs, rhs, sub_options)
        end
      else
        if valid_modes[sub_mode] and lhs and rhs then
          vim.api.nvim_set_keymap(sub_mode, lhs, rhs, sub_options)
        else
          sub_mode, lhs, rhs = sub_mode or "", lhs or "", rhs or ""
          print(
            "Cannot set mapping [ mode = '" .. sub_mode .. "' | key = '" .. lhs .. "' | cmd = '" .. rhs .. "' ]"
          )
        end
      end
    end
  end

  map_wrapper(mode, keys, command, options)
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
  if plugin then
    timer = timer or 0
    vim.defer_fn(function()
      require("packer").loader(plugin)
    end, timer)
  end
end

-- Highlights functions

-- Define bg color
-- @param group Group
-- @param color Color

M.bg = function(group, col)
  cmd("hi " .. group .. " guibg=" .. col)
end

-- Define fg color
-- @param group Group
-- @param color Color
M.fg = function(group, col)
  cmd("hi " .. group .. " guifg=" .. col)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
M.fg_bg = function(group, fgcol, bgcol)
  cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

-- Config of a plugin based on the path provided in the plugins/configs
-- Arguments:
--  1st - name of plugin
--  2nd - default config path
--  3rd - optional function name which will called from default_config path
--  e.g: if given args - "telescope", "plugins.configs.telescope", "setup"
--      then return "require('plugins.configs.telescope').setup()"
--      if 3rd arg not given, then return "require('plugins.configs.telescope')"
M.config_require = function(name, config_path, config_function)
  local result = config_path
  result = "('" .. result .. "')"
  if type(config_function) == "string" and config_function ~= "" then
    -- add the . to call the functions and concatenate true or false as argument
    result = result .. "." .. config_function .. "()"
  end
  return "require" .. result
end

-- provide labels to plugins instead of integers
M.label_plugins = function(plugins)
  local plugins_labeled = {}
  for _, plugin in ipairs(plugins) do
    plugins_labeled[plugin[1]] = plugin
  end
  return plugins_labeled
end

-- Desc:
--    Moves up or down the current cursor line
--    mantaining the cursor over the line
-- Parameter:
--    dir -> Movement direction (-1, +1)
M.move_line = function(dir)
  if dir == nil then
    error('Missing offset', 3)
  end

  -- Get the last line of current buffer
  local last_row = vim.fn.line('$')

  -- Get current cursor row
  local current_row = vim.api.nvim_win_get_cursor(0)[1]

  if current_row < 1 or current_row > last_row then
    return
  end

  -- Edges
  if current_row == 1 and dir < 0 then
    return
  end

  if current_row == last_row and dir > 0 then
    return
  end

  -- Swap line
  local source_line = vim.api.nvim_buf_get_lines(0, current_row - 1, current_row, true)
  local target_line = vim.api.nvim_buf_get_lines(0, current_row + dir - 1, current_row + dir, true)

  vim.api.nvim_buf_set_lines(0, current_row - 1, current_row, true, target_line)
  vim.api.nvim_buf_set_lines(0, current_row + dir - 1, current_row + dir, true, source_line)

  -- Set cursor position
  local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
  vim.api.nvim_win_set_cursor(0, { current_row + dir, cursor_column })
end

-- Desc:
--    Moves up or down a visual area
--    mantaining the selection
-- Parameter:
--    dir -> Movement direction (-1, +1)
M.move_block = function(dir)
  local _, start_row, _, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, _, _ = unpack(vim.fn.getpos("'>"))
  local last_row = vim.fn.line('$')

  -- Zero-based and end exclusive
  start_row = start_row - 1

  -- Edges
  if start_row == 0 and dir < 0 then
    cmd(':normal! '..start_row..'ggV'..(end_row)..'gg')
    return
  end

  if end_row == last_row and dir > 0 then
    cmd(':normal! '..(start_row + 1)..'ggV'..(end_row + dir)..'gg')
    return
  end

  local block = vim.api.nvim_buf_get_lines(0, start_row, end_row, true)

  if dir < 0 then
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, true)
    table.insert(block, lines[1])
  elseif dir > 0 then
    local lines = vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, true)
    table.insert(block, 1, lines[1])
  end

  -- Move block
  local target_start_row = (dir > 0 and start_row or start_row - 1)
  local target_end_row = (dir > 0 and end_row + 1 or end_row)
  vim.api.nvim_buf_set_lines(0, target_start_row, target_end_row, true, block)

  -- Reselect block
  local select_start_row = (dir > 0 and start_row + 2 or start_row)
  local select_end_row = (end_row + dir)
  cmd(':normal! \\e\\e')
  cmd(':normal! '..select_start_row..'ggV'..select_end_row..'gg')
end

return M
